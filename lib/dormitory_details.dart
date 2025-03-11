// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'home_screen.dart';

// class DormitoryDetailsPage extends StatefulWidget {
//   @override
//   _DormitoryDetailsPageState createState() => _DormitoryDetailsPageState();
// }

// class _DormitoryDetailsPageState extends State<DormitoryDetailsPage> {
//   String selectedGender = "Both";
//   File? _image;

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Dormitory Details",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildTextField("Dormitory Name", "Fill name Dormitory"),
//               _buildTextField("Type of Room", "Fill type"),
//               SizedBox(height: 10),
//               Text(
//                 "Rented to Man/Woman?",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildGenderSelection("Man", "assets/man.png"),
//                   _buildGenderSelection("Woman", "assets/woman.png"),
//                   _buildGenderSelection("Both", "assets/man_woman.png"),
//                 ],
//               ),
//               SizedBox(height: 10),
//               _buildTextField(
//                 "Description",
//                 "Fill in the description",
//                 maxLines: 3,
//               ),
//               _buildTextField("Address", "Fill in the address"),
//               _buildTextField(
//                 "Room Availability",
//                 "Enter number of rooms available",
//               ),
//               _buildTextField("Price", "Enter price per month"),
//               SizedBox(height: 10),
//               Text(
//                 "Upload Dormitory Photos",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: Container(
//                   height: 150,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child:
//                       _image == null
//                           ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
//                           : Image.file(_image!, fit: BoxFit.cover),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomeScreen()),
//                   );
//                 },
//                 child: Text("Continue", style: TextStyle(color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.brown,
//                   padding: EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(height: 5),
//           TextField(
//             maxLines: maxLines,
//             decoration: InputDecoration(
//               hintText: hint,
//               filled: true,
//               fillColor: Colors.grey[200],
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGenderSelection(String label, String imagePath) {
//     return Column(
//       children: [
//         Image.asset(imagePath, width: 50, height: 50),
//         SizedBox(height: 5),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedGender = label;
//             });
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             decoration: BoxDecoration(
//               color: selectedGender == label ? Colors.brown : Colors.white,
//               border: Border.all(color: Colors.brown),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: selectedGender == label ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home_screen.dart';

class DormitoryDetailsPage extends StatefulWidget {
  @override
  _DormitoryDetailsPageState createState() => _DormitoryDetailsPageState();
}

class _DormitoryDetailsPageState extends State<DormitoryDetailsPage> {
  String selectedGender = "Both";
  List<File> _images = [];
  List<File> _panoramicImages = [];

  Future<void> _pickImage({required bool isPanoramic}) async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        if (isPanoramic) {
          _panoramicImages.addAll(pickedFiles.map((e) => File(e.path)));
        } else {
          _images.addAll(pickedFiles.map((e) => File(e.path)));
        }
      });
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
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
    List<File> images = isPanoramic ? _panoramicImages : _images;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(isPanoramic: isPanoramic),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 10),
        images.isNotEmpty
            ? SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            images[index],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
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
            : SizedBox(),
      ],
    );
  }
}
