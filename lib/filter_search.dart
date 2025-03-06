import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedDormitory = "";
  String selectedPayTime = "Monthly";
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Type Dormitory"),
            _buildDormitorySelection(),
            _buildSectionTitle("Pay Time"),
            _buildPayTimeSelection(),
            _buildSectionTitle("Price"),
            _buildPriceInputs(),
            _buildSectionTitle("Room Facility"),
            _buildFacilitiesSelection(),
            Spacer(),
            _buildBottomButtons(),
          ],
        ),
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

  Widget _buildPayTimeSelection() {
    return Wrap(
      spacing: 10,
      children:
          ["Weekly", "Daily", "3 months", "Monthly", "Yearly", "6 months"].map((
            payTime,
          ) {
            return ChoiceChip(
              label: Text(payTime),
              selected: selectedPayTime == payTime,
              onSelected:
                  (selected) => setState(() => selectedPayTime = payTime),
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
                  selectedPayTime = "Monthly";
                  minPriceController.text = "5000";
                  maxPriceController.text = "9999";
                  selectedFacilities.clear();
                }),
            child: Text("Delete"),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            child: Text(
              "Show Dormitories",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
