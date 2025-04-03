import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/aws_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(String) onImageUploaded;
  final String? initialImageUrl;
  final String? label;
  final double? height;
  final double? width;

  const ImageUploadWidget({
    Key? key,
    required this.onImageUploaded,
    this.initialImageUrl,
    this.label,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _imageFile;
  bool _isUploading = false;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _uploadedImageUrl = widget.initialImageUrl;
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isUploading = true;
        });

        // Upload to AWS S3
        final String? imageUrl = await AwsService.uploadImage(_imageFile!);

        if (imageUrl != null) {
          setState(() {
            _uploadedImageUrl = imageUrl;
            _isUploading = false;
          });
          widget.onImageUploaded(imageUrl);
        } else {
          // Handle upload failure
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
          setState(() => _isUploading = false);
        }
      }
    } catch (e) {
      print('Error picking/uploading image: $e');
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Container(
          height: widget.height ?? 200,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _uploadedImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: _uploadedImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Room Image',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _isUploading ? null : _pickAndUploadImage,
          icon: _isUploading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload),
          label: Text(_isUploading ? 'Uploading...' : 'Upload Image'),
        ),
      ],
    );
  }
} 