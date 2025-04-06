import 'dart:typed_data';
import 'dart:convert';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:crypto/crypto.dart';

class AwsService {
  // AWS credentials from .env file
  static String get _accessKey => dotenv.env['AWS_ACCESS_KEY'] ?? '';
  static String get _secretKey => dotenv.env['AWS_SECRET_KEY'] ?? '';
  static String get _region => dotenv.env['AWS_REGION'] ?? '';
  static String get _bucketName => dotenv.env['AWS_BUCKET_NAME'] ?? '';

  static String get _baseUrl => 'https://$_bucketName.s3.$_region.amazonaws.com';

  // Upload image and return the URL
  static Future<String?> uploadImage(dynamic file) async {
    try {
      // Log credentials for debugging (be careful with this in production)
      print('AWS Upload - Using credentials:');
      print('Access Key: ${_accessKey.substring(0, 5)}...');
      print('Secret Key: ${_secretKey.substring(0, 5)}...');
      print('Region: $_region');
      print('Bucket: $_bucketName');
      
      // Generate unique filename
      final uuid = Uuid().v4();
      final String key = 'uploads/$uuid.jpg';
      
      print('File type: ${file.runtimeType}');
      
      String? uploadedFileUrl;
      
      if (file is Uint8List) {
        print('Uploading Uint8List (${file.length} bytes)');
        
        // For web, we need to create a data URL as fallback
        final base64 = base64Encode(file);
        final dataUrl = 'data:image/jpeg;base64,$base64';
        
        if (kIsWeb) {
          print('Web environment detected, using data URL');
          return dataUrl;
        }
        
        try {
          // For non-web platforms, try to create a temporary file and upload it
          final tempDir = await path_provider.getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/$uuid.jpg');
          await tempFile.writeAsBytes(file);
          
          print('Created temp file at: ${tempFile.path}');
          
          uploadedFileUrl = await AwsS3.uploadFile(
            accessKey: _accessKey,
            secretKey: _secretKey,
            bucket: _bucketName,
            region: _region,
            key: key,
            file: tempFile,
            contentType: 'image/jpeg',
            metadata: {
              'x-amz-acl': 'public-read'
            },
          );
          
          // Delete temp file after upload
          await tempFile.delete();
          
          print('S3 upload completed. URL: $uploadedFileUrl');
          
          if (uploadedFileUrl != null) {
            return uploadedFileUrl;
          } else {
            print('Upload failed, using data URL as fallback');
            return dataUrl;
          }
        } catch (e) {
          print('S3 upload failed: $e');
          // Return data URL as fallback
          return dataUrl;
        }
      } else if (file is File) {
        print('Uploading File: ${file.path}');
        
        try {
          print('Attempting S3 upload from mobile with AWS S3 package...');
          print('File exists: ${await file.exists()}');
          print('File size: ${await file.length()} bytes');
          
          uploadedFileUrl = await AwsS3.uploadFile(
            accessKey: _accessKey,
            secretKey: _secretKey,
            bucket: _bucketName,
            region: _region,
            key: key,
            file: file,
            contentType: 'image/jpeg',
            metadata: {
              'x-amz-acl': 'public-read'
            },
          );
          
          if (uploadedFileUrl == null) {
            print('Upload returned null URL, constructing URL manually');
            uploadedFileUrl = '$_baseUrl/$key';
          }
          
          print('S3 upload completed. URL: $uploadedFileUrl');
          
          // Verify the upload
          try {
            final response = await http.head(Uri.parse(uploadedFileUrl!));
            print('Verification status: ${response.statusCode}');
            if (response.statusCode >= 200 && response.statusCode < 300) {
              return uploadedFileUrl;
            } else {
              print('URL verification failed, URL might still work');
              return uploadedFileUrl;
            }
          } catch (e) {
            print('Verification error: $e');
            return uploadedFileUrl; // Return URL anyway
          }
        } catch (e) {
          print('S3 upload failed with error: $e');
          
          // Fallback: Try manual upload using http
          try {
            print('Attempting manual HTTP upload...');
            final bytes = await file.readAsBytes();
            final url = Uri.parse('https://$_bucketName.s3.$_region.amazonaws.com/$key');
            
            // The AWS S3 date format
            final date = DateTime.now().toUtc().toString().replaceAll(' ', 'T') + 'Z';
            date.replaceAll(RegExp(r'\.\d+'), '');
            
            // Create the signature
            final stringToSign = 'PUT\n\nimage/jpeg\n$date\n/$_bucketName/$key';
            final hmacSha1 = Hmac(sha1, utf8.encode(_secretKey));
            final signature = base64.encode(hmacSha1.convert(utf8.encode(stringToSign)).bytes);
            
            // Send the request
            final response = await http.put(
              url,
              headers: {
                'Content-Type': 'image/jpeg',
                'Date': date,
                'Authorization': 'AWS $_accessKey:$signature',
                'x-amz-acl': 'public-read'
              },
              body: bytes,
            );
            
            print('Manual upload status: ${response.statusCode}, ${response.reasonPhrase}');
            
            if (response.statusCode >= 200 && response.statusCode < 300) {
              return url.toString();
            } else {
              print('Manual upload failed: ${response.body}');
              return null;
            }
          } catch (manualError) {
            print('Manual upload failed: $manualError');
            return null;
          }
        }
      } else {
        print('Unsupported file type: ${file.runtimeType}');
        return null;
      }
    } catch (e) {
      print('Error in uploadImage: $e');
      return null;
    }
  }
}