import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'home_screen.dart';
import 'dormitory_data.dart';

class SelectPropertyTypeScreen extends StatefulWidget {
  const SelectPropertyTypeScreen({super.key});

  @override
  State<SelectPropertyTypeScreen> createState() =>
      _SelectPropertyTypeScreenState();
}

class _SelectPropertyTypeScreenState extends State<SelectPropertyTypeScreen> {
  String selectedProperty = "Dormitory"; // Default selection

  void _selectProperty(String property) {
    setState(() {
      selectedProperty = property;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 28),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: const Text(
          "Select property type",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Dormitory Selection
            GestureDetector(
              onTap: () => _selectProperty("Dormitory"),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        selectedProperty == "Dormitory"
                            ? Colors.brown
                            : Colors.grey.shade300,
                  ),
                  color:
                      selectedProperty == "Dormitory"
                          ? Colors.brown.shade50
                          : Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.home, color: Colors.brown),
                    const SizedBox(width: 10),
                    const Text("Dormitory", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Apartment Selection
            GestureDetector(
              onTap: () => _selectProperty("Apartment"),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        selectedProperty == "Apartment"
                            ? Colors.brown
                            : Colors.grey.shade300,
                  ),
                  color:
                      selectedProperty == "Apartment"
                          ? Colors.brown.shade50
                          : Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.building, color: Colors.brown),
                    const SizedBox(width: 10),
                    const Text("Apartment", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Create Now Button
            ElevatedButton(
              onPressed: () {
                if (selectedProperty == "Dormitory") {
                  // Handle dormitory creation
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DormitoryDataScreen(),
                    ),
                  );
                } else {
                  // Handle apartment creation
                }
                // Handle next step logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Create now",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
