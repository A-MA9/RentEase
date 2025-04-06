import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home_page_owner.dart';
import 'services/aws_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'dart:convert';
import 'services/property_service.dart';
import 'owner_houses.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DormitoryDetailsPage extends StatefulWidget {
  @override
  _DormitoryDetailsPageState createState() => _DormitoryDetailsPageState();
}

class _DormitoryDetailsPageState extends State<DormitoryDetailsPage> {
  String selectedGender = "Both";
  List<String> _uploadedImageUrls = [];
  List<String> _uploadedPanoramicUrls = [];
  bool _isUploading = false;
  bool _isCreating = false;
  String _uploadStatus = '';

  // Text controllers to capture user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _roomsAvailableController = TextEditingController(text: "1");
  final TextEditingController _priceController = TextEditingController();
  
  // Amenities checkboxes
  Map<String, bool> amenities = {
    'tv': false,
    'fan': false,
    'ac': false,
    'chair': false,
    'ventilation': false,
    'ups': false,
    'sofa': false,
    'lamp': false,
  };
  int bathrooms = 1;

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

  Future<void> _createDormitory() async {
    // Validate input fields
    if (_nameController.text.isEmpty ||
        _typeController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _uploadedImageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields and upload at least one image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add bathrooms to amenities
    amenities['bath'] = bathrooms > 0;

    setState(() {
      _isCreating = true;
    });

    try {
      // Create the property
      await PropertyService.createProperty(
        title: _nameController.text,
        propertyType: _typeController.text,
        description: _descriptionController.text,
        location: _addressController.text,
        pricePerMonth: double.parse(_priceController.text),
        minStayMonths: 1, // Default minimum stay
        imageUrls: _uploadedImageUrls,
        panoramicUrls: _uploadedPanoramicUrls,
        sizeSqft: null, // We're not collecting this field from UI
        amenities: amenities,
        gender: selectedGender,
        roomsAvailable: int.parse(_roomsAvailableController.text),
      );

      setState(() {
        _isCreating = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dormitory created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the owner's properties page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OwnerHouses()),
      );
    } catch (e) {
      setState(() {
        _isCreating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating dormitory: ${e.toString()}'),
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
              _buildTextField(
                "Dormitory Name", 
                "Fill name Dormitory",
                controller: _nameController,
              ),
              _buildTextField(
                "Type of Room", 
                "Fill type",
                controller: _typeController,
              ),
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
                controller: _descriptionController,
              ),
              _buildTextField(
                "Address", 
                "Fill in the address",
                controller: _addressController,
              ),
              _buildTextField(
                "Room Availability",
                "Enter number of rooms available",
                controller: _roomsAvailableController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                "Price", 
                "Enter price per month",
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 20),
              Text(
                "Amenities",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildAmenityCheckbox('TV', 'tv'),
                  _buildAmenityCheckbox('Fan', 'fan'),
                  _buildAmenityCheckbox('AC', 'ac'),
                  _buildAmenityCheckbox('Chair', 'chair'),
                  _buildAmenityCheckbox('Ventilation', 'ventilation'),
                  _buildAmenityCheckbox('UPS', 'ups'),
                  _buildAmenityCheckbox('Sofa', 'sofa'),
                  _buildAmenityCheckbox('Lamp', 'lamp'),
                ],
              ),
              
              SizedBox(height: 15),
              Row(
                children: [
                  Text("Bathrooms:", style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      if (bathrooms > 1) {
                        setState(() {
                          bathrooms--;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.remove, size: 20),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    bathrooms.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      setState(() {
                        bathrooms++;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),

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
                onPressed: _isCreating ? null : _createDormitory,
                child: _isCreating 
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Creating...", style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : Text("Create Dormitory", style: TextStyle(color: Colors.white)),
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

  Widget _buildAmenityCheckbox(String label, String key) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: CheckboxListTile(
        title: Text(label, style: TextStyle(fontSize: 14)),
        value: amenities[key],
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.brown,
        onChanged: (value) {
          setState(() {
            amenities[key] = value ?? false;
          });
        },
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {
    int maxLines = 1, 
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextField(
            maxLines: maxLines,
            controller: controller,
            keyboardType: keyboardType,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isUploading && _uploadStatus.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _uploadStatus,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
        SizedBox(height: 8),
        ElevatedButton.icon(
          icon: Icon(Icons.add_a_photo),
          label: Text(isPanoramic ? "Add Panoramic View" : "Add Photo"),
          onPressed: _isUploading
              ? null
              : () => _pickAndUploadImages(isPanoramic: isPanoramic),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[100],
            foregroundColor: Colors.brown[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 10),
        imageUrls.isNotEmpty
            ? Container(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageUrls[index].startsWith('data:')
                                    ? MemoryImage(
                                        base64Decode(
                                          imageUrls[index].split(',')[1],
                                        ),
                                      ) as ImageProvider
                                    : NetworkImage(imageUrls[index]),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  imageUrls.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Text(
                  isPanoramic
                      ? "No panoramic views uploaded yet"
                      : "No images uploaded yet",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
      ],
    );
  }
}
