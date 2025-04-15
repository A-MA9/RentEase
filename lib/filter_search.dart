import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'search_page.dart';

class FilterPage extends StatefulWidget {
  final String? currentLocation;
  final Function(Map<String, dynamic>)? onFiltersApplied;

  const FilterPage({Key? key, this.currentLocation, this.onFiltersApplied})
    : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedDormitory = "";
  int selectedMinStay = 1;
  TextEditingController minPriceController = TextEditingController(
    text: "5000",
  );
  TextEditingController maxPriceController = TextEditingController(
    text: "9999",
  );
  final List<Map<String, String>> facilities = [
    {"name": "TV", "image": "assets/tv.png"},
    {"name": "Fan", "image": "assets/fan.png"},
    {"name": "AC", "image": "assets/ac.png"},
    {"name": "Chair", "image": "assets/chair.png"},
    {"name": "Ventilation", "image": "assets/ventilation.png"},
    {"name": "Bath Tub", "image": "assets/bathtub.png"},
    {"name": "UPS", "image": "assets/ups.png"},
    {"name": "Sofa", "image": "assets/sofa.png"},
    {"name": "Lamp", "image": "assets/lamp.png"},
  ];
  Set<String> selectedFacilities = {};
  bool isLoading = false;

  Future<void> _applyFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Prepare filter parameters
      final filterParams = {
        'dormitory_type': selectedDormitory,
        'min_stay_months': selectedMinStay,
        'min_price': minPriceController.text,
        'max_price': maxPriceController.text,
        'facilities': selectedFacilities.toList(),
      };

      // Call the backend API
      final response = await http.post(
        Uri.parse('${baseUrl}/properties/filter'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(filterParams),
      );

      if (response.statusCode == 200) {
        final filteredProperties = json.decode(response.body);

        // Pass the filtered results back to the search page
        if (widget.onFiltersApplied != null) {
          widget.onFiltersApplied!(filterParams);
        }

        Navigator.pop(context, filteredProperties);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply filters: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error applying filters: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Type Dormitory"),
                _buildDormitorySelection(),
                _buildSectionTitle("Minimum Stay"),
                _buildMinStaySelection(),
                _buildSectionTitle("Price"),
                _buildPriceInputs(),
                _buildSectionTitle("Room Facility"),
                _buildFacilitiesSelection(),
                Spacer(),
                _buildBottomButtons(),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildDormitorySelection() {
    final dormitoryOptions = [
      {"type": "Man", "image": "assets/man.png"},
      {"type": "Woman", "image": "assets/woman.png"},
      {"type": "Mix", "image": "assets/man_woman.png"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          dormitoryOptions.map((option) {
            String type = option["type"]!;
            String imagePath = option["image"]!;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDormitory = (selectedDormitory == type) ? "" : type;
                });
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            selectedDormitory == type
                                ? Colors.brown
                                : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(6),
                    child: Image.asset(
                      imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 5),
                  ChoiceChip(
                    label: Text(type),
                    selected: selectedDormitory == type,
                    onSelected: (selected) {
                      setState(() {
                        selectedDormitory = selected ? type : "";
                      });
                    },
                    selectedColor: Colors.brown.withOpacity(0.2),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color:
                          selectedDormitory == type
                              ? Colors.brown
                              : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildMinStaySelection() {
    return Wrap(
      spacing: 10,
      children:
          [1, 3, 6, 12].map((months) {
            return ChoiceChip(
              label: Text("$months ${months == 1 ? 'month' : 'months'}"),
              selected: selectedMinStay == months,
              onSelected:
                  (selected) => setState(() => selectedMinStay = months),
              selectedColor: Colors.brown.withOpacity(0.2),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selectedMinStay == months ? Colors.brown : Colors.black,
                fontWeight:
                    selectedMinStay == months
                        ? FontWeight.bold
                        : FontWeight.normal,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPriceInputs() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: minPriceController,
            decoration: InputDecoration(labelText: "Minimum"),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: maxPriceController,
            decoration: InputDecoration(labelText: "Maximum"),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesSelection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          facilities.map((facility) {
            String facilityName = facility["name"]!;
            String facilityImage = facility["image"]!;
            bool isSelected = selectedFacilities.contains(facilityName);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedFacilities.remove(facilityName);
                  } else {
                    selectedFacilities.add(facilityName);
                  }
                });
              },
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.brown
                                : Colors.grey.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color:
                          isSelected
                              ? Colors.brown.withOpacity(0.1)
                              : Colors.white,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Image.asset(facilityImage, fit: BoxFit.contain),
                  ),
                  SizedBox(height: 4),
                  Text(
                    facilityName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.brown : Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed:
                () => setState(() {
                  selectedDormitory = "";
                  selectedMinStay = 1;
                  minPriceController.text = "5000";
                  maxPriceController.text = "9999";
                  selectedFacilities.clear();
                }),
            child: Text("Reset"),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : _applyFilters,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            child: Text("Apply"),
          ),
        ),
      ],
    );
  }
}
