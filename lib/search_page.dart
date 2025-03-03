import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Map<String, dynamic>> dormitories = [
    {
      "title": "VIP Dormitory Jaipur Double Bed",
      "location": "Sindhi Camp",
      "amenities": "Wifi - AC - Attached bath - 24/7 UPS",
      "rating": 4.9,
      "price": 5000,
      "discount": "10% OFF",
      "category": "Woman",
      "image": "assets/dorm1.jpg",
    },
    {
      "title": "VIP Dormitory Jaipur Double Bed",
      "location": "Badi Chaupar, Jaipur",
      "amenities": "Wifi - AC - Attached bath - 24/7 UPS",
      "rating": 4.2,
      "price": 4500,
      "discount": "15% OFF",
      "category": "Mixed",
      "image": "assets/dorm2.jpg",
    },
    {
      "title": "VIP Dormitory Jaipur Single Bed",
      "location": "Kalyan Circle",
      "amenities": "Wifi - Ventilated - Attached bath - 12hr UPS",
      "rating": 4.8,
      "price": 5000,
      "discount": "20% OFF",
      "category": "Man",
      "image": "assets/dorm3.jpg",
    },
    {
      "title": "VIP Dormitory Jaipur Single Bed",
      "location": "Patrika Gate, Jaipur",
      "amenities": "Wifi - Ventilated - Common bath - No UPS",
      "rating": 4.9,
      "price": 4500,
      "discount": "25% OFF",
      "category": "Man",
      "image": "assets/dorm4.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              ),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Jaipur',
              prefixIcon: Icon(Icons.search, color: Colors.brown),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter & Promo Buttons
            Row(
              children: [
                _buildFilterButton("Filter", isSelected: true),
                _buildFilterButton("Speeding Promo"),
                _buildFilterButton("Managed by Molly"),
              ],
            ),
            SizedBox(height: 16),

            // Found Results Text
            Text(
              "Found 99+ Dormitories",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Dormitories List
            Expanded(
              child: ListView.builder(
                itemCount: dormitories.length,
                itemBuilder: (context, index) {
                  return _buildDormitoryCard(dormitories[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.map, color: Colors.white),
          label: Text("Map"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.brown : Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.brown),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildDormitoryCard(Map<String, dynamic> dorm) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          // Dormitory Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Image.asset(
                  dorm["image"],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Best",
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 130, 54),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      dorm["category"],
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),

          // Dormitory Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dorm["title"],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.brown, size: 16),
                    SizedBox(width: 4),
                    Text(
                      dorm["location"],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  dorm["amenities"],
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.brown, size: 16),
                    SizedBox(width: 4),
                    Text(
                      dorm["rating"].toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.yellow[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        dorm["discount"],
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "₹${dorm["price"]}/month",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
