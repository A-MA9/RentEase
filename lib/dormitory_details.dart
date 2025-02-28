import 'package:flutter/material.dart';

class DormitoryDetailsScreen extends StatefulWidget {
  @override
  _DormitoryDetailsScreenState createState() => _DormitoryDetailsScreenState();
}

class _DormitoryDetailsScreenState extends State<DormitoryDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedGender = "";

  bool get isFormValid {
    return _nameController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedGender.isNotEmpty;
  }

  void _onGenderSelected(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dormitory Data"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please Complete Dormitory data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Help prospective tenants find out which boarding house you are going to rent out.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),

            // Dormitory Name
            Text(
              "1. What is the name of this Dormitory?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Suggestion: Dormitory (space) Name of the dormitory. No name of District or City.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Fill name Dormitory",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 16),

            // Room Type
            Text(
              "2. Type of Room?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Suggestion: Type A or VVIP or Executive",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                hintText: "Fill type",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
            SizedBox(height: 16),

            // Rented to (Man, Woman, Both)
            Text(
              "3. Rented to Man/Woman?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Please choose a suitable dormitory type.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  ["Man", "Woman", "Both"].map((gender) {
                    bool isSelected = _selectedGender == gender;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onGenderSelected(gender),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.brown : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                gender == "Man"
                                    ? Icons.man
                                    : gender == "Woman"
                                    ? Icons.woman
                                    : Icons.people,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                              Text(
                                gender,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 16),

            // Description
            Text(
              "4. Description?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Tell us something interesting about your Dormitory",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Fill in the description",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => setState(() {}),
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isFormValid
                        ? () {
                          Navigator.pop(
                            context,
                            true,
                          ); // Return 'true' to previous page
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("Continue", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
