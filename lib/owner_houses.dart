import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dormitory_details.dart';
import 'services/property_service.dart';
import 'models/property_model.dart';
import 'home_page_owner.dart';

final FlutterSecureStorage storage = const FlutterSecureStorage();

class OwnerHouses extends StatefulWidget {
  const OwnerHouses({Key? key}) : super(key: key);

  @override
  _OwnerHousesState createState() => _OwnerHousesState();
}

class _OwnerHousesState extends State<OwnerHouses> {
  List<Property> properties = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final propertiesList = await PropertyService.getOwnerProperties();
      setState(() {
        properties = propertiesList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load properties: $e';
        _isLoading = false;
      });
      print('Error loading properties: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageOwner()),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Rentals'),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DormitoryDetailsPage()),
            ).then((_) => _loadProperties());
          },
          backgroundColor: Colors.brown,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.brown));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProperties,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_work, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No properties yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first property',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];

        return Card(
          margin: EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property image
              property.imageUrls.isNotEmpty
                  ? Image.network(
                    property.imageUrls[0],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (ctx, err, _) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                  )
                  : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.home, size: 50)),
                  ),

              // Property details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.home_work, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              property.propertyType,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(
                          '₹${property.pricePerMonth.toStringAsFixed(0)} per month',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              'For ${property.gender}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(
                          '${property.roomsAvailable} room${property.roomsAvailable > 1 ? 's' : ''} available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Amenities',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        if (property.tv) _buildAmenityChip('TV'),
                        if (property.ac) _buildAmenityChip('AC'),
                        if (property.fan) _buildAmenityChip('Fan'),
                        if (property.chair) _buildAmenityChip('Chair'),
                        if (property.ventilation)
                          _buildAmenityChip('Ventilation'),
                        if (property.ups) _buildAmenityChip('UPS'),
                        if (property.sofa) _buildAmenityChip('Sofa'),
                        if (property.lamp) _buildAmenityChip('Lamp'),
                        _buildAmenityChip(
                          '${property.bath} Bath${property.bath > 1 ? 's' : ''}',
                        ),
                      ],
                    ),

                    SizedBox(height: 16),
                    Text(
                      'Listing Date: ${_formatDate(property.createdAt)}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenityChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.brown[100]!),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: Colors.brown)),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
