import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home_page_owner.dart';
import 'services/aws_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:convert';

class DormitoryDetailsPage extends StatefulWidget {
  @override
  _DormitoryDetailsPageState createState() => _DormitoryDetailsPageState();
}

class _DormitoryDetailsPageState extends State<DormitoryDetailsPage> {
  String selectedGender = "Both";
  List<String> _uploadedImageUrls = [];
  List<String> _uploadedPanoramicUrls = [];
  bool _isUploading = false;
  String _uploadStatus = '';

  Future<void> _pickAndUploadImages({required bool isPanoramic}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? result = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (result != null) {
        setState(() { 
          _isUploading = true;
          _uploadStatus = 'Preparing image...';
        });

        dynamic fileToUpload;
        if (kIsWeb) {
          // For web, read the file as bytes
          setState(() => _uploadStatus = 'Reading image as bytes...');
          final bytes = await result.readAsBytes();
          fileToUpload = bytes;
        } else {
          // For mobile, use the File object
          fileToUpload = File(result.path);
        }

        setState(() => _uploadStatus = 'Uploading image to S3...');
        
        final String? imageUrl = await AwsService.uploadImage(fileToUpload);
        
        if (imageUrl != null) {
          setState(() {
            if (isPanoramic) {
              _uploadedPanoramicUrls.add(imageUrl);
            } else {
              _uploadedImageUrls.add(imageUrl);
            }
            _uploadStatus = 'Upload complete!';
          });
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // For debugging
          print('Image URL added: $imageUrl');
          print('Total images: ${isPanoramic ? _uploadedPanoramicUrls.length : _uploadedImageUrls.length}');
        } else {
          setState(() => _uploadStatus = 'Upload failed');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to upload image to S3'),
              backgroundColor: Colors.red,
            ),
          );
        }

        setState(() => _isUploading = false);
      }
    } catch (e) {
      print('Error picking/uploading images: $e');
      setState(() {
        _isUploading = false;
        _uploadStatus = 'Error: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Dormitory Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Dormitory Name", "Fill name Dormitory"),
              _buildTextField("Type of Room", "Fill type"),
              SizedBox(height: 10),
              Text(
                "Rented to Man/Woman?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderSelection("Man", "assets/man.png"),
                  _buildGenderSelection("Woman", "assets/woman.png"),
                  _buildGenderSelection("Both", "assets/man_woman.png"),
                ],
              ),
              SizedBox(height: 10),
              _buildTextField(
                "Description",
                "Fill in the description",
                maxLines: 3,
              ),
              _buildTextField("Address", "Fill in the address"),
              _buildTextField(
                "Room Availability",
                "Enter number of rooms available",
              ),
              _buildTextField("Price", "Enter price per month"),

              SizedBox(height: 10),
              Text(
                "Upload Dormitory Photos",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildImagePicker(isPanoramic: false),

              SizedBox(height: 20),
              Text(
                "Upload Panoramic Views",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildImagePicker(isPanoramic: true),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageOwner()),
                  );
                },
                child: Text("Continue", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection(String label, String imagePath) {
    return Column(
      children: [
        Image.asset(imagePath, width: 50, height: 50),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedGender = label;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: selectedGender == label ? Colors.brown : Colors.white,
              border: Border.all(color: Colors.brown),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selectedGender == label ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker({required bool isPanoramic}) {
    List<String> imageUrls = isPanoramic ? _uploadedPanoramicUrls : _uploadedImageUrls;

    return Column(
      children: [
        GestureDetector(
          onTap: _isUploading ? null : () => _pickAndUploadImages(isPanoramic: isPanoramic),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: _isUploading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(_uploadStatus),
                      ],
                    ),
                  )
                : const Center(
                    child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                  ),
          ),
        ),
        if (imageUrls.isNotEmpty) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = imageUrls[index];
                print('Displaying image: $imageUrl');
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageUrl.startsWith('data:image')
                            ? Image.memory(
                                base64Decode(imageUrl.split(',')[1]),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imageUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.error, color: Colors.red),
                                    ),
                                  );
                                },
                              ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.info, color: Colors.blue, size: 20),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Image URL'),
                                  content: SelectableText(imageUrl.length > 100 
                                    ? '${imageUrl.substring(0, 100)}... (data URL)' 
                                    : imageUrl),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            padding: EdgeInsets.all(5),
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
