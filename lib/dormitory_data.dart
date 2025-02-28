import 'package:flutter/material.dart';
import 'dormitory_details.dart';

class DormitoryDataScreen extends StatefulWidget {
  @override
  _DormitoryDataScreenState createState() => _DormitoryDataScreenState();
}

class _DormitoryDataScreenState extends State<DormitoryDataScreen> {
  List<bool> _isCompleted = [false, false, false, false, false, false];

  void _markAsCompleted(int index) {
    setState(() {
      _isCompleted[index] = true;
    });
  }

  Widget _buildStep(int index, String title, String description) {
    bool isCompleted = _isCompleted[index];

    return GestureDetector(
      onTap: () {
        // Simulating data entry completion
        _markAsCompleted(index);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.black : Colors.grey,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.black : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isCompleted ? Colors.black54 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Dormitory Details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DormitoryDetailsScreen()),
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Register your boarding house by filling the data below.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildStep(
                  0,
                  "Dormitory D",
                  "To set information about dormitory descriptions and room types",
                ),
                _buildStep(
                  1,
                  "Dormitory Address",
                  "To set the location and address details of the boarding house",
                ),
                _buildStep(
                  2,
                  "Dormitory Photo",
                  "To organize photos of the dormitory and its environment",
                ),
                _buildStep(
                  3,
                  "Dormitory Facility",
                  "To organize dormitory facilities and their contents",
                ),
                _buildStep(
                  4,
                  "Room Availability",
                  "To set the number of available and occupied rooms",
                ),
                _buildStep(5, "Price", "To set room prices and other fees"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
