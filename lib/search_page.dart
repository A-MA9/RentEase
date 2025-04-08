import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'room_details.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<dynamic>> _searchResultsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';
  Timer? _debounce;

  String get _baseUrl {
    return kIsWeb ? 'http://127.0.0.1:8000' : 'http://10.0.2.2:8000';
  }

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.initialQuery ?? '';
    _searchController.text = _currentQuery;
    _searchResultsFuture = _fetchSearchResults(_currentQuery);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 750), () {
      final query = _searchController.text.trim();
      if (query != _currentQuery) {
        _triggerSearch(query);
      }
    });
  }

  void _triggerSearch(String query) {
    final trimmedQuery = query.trim();
    print("Triggering search in SearchPage for: $trimmedQuery");
    setState(() {
      _currentQuery = trimmedQuery;
      _searchResultsFuture = _fetchSearchResults(trimmedQuery);
    });
  }

  Future<List<dynamic>> _fetchSearchResults(String query) async {
    if (query.isEmpty) return [];

    final searchUrl = Uri.parse(
      '$_baseUrl/properties/search',
    ).replace(queryParameters: {'location': query});

    print('SearchPage fetching from: $searchUrl');

    try {
      final response = await http
          .get(searchUrl, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('SearchPage found ${data.length} results.');
        return data;
      } else {
        print('SearchPage failed: ${response.statusCode} ${response.body}');
        throw Exception(
          'Failed to load search results (${response.statusCode})',
        );
      }
    } catch (e) {
      print('SearchPage error: $e');
      throw Exception('Error fetching search results: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search location...',
              prefixIcon: const Icon(Icons.search, color: Colors.brown),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 15,
              ),
            ),
            onSubmitted: (value) => _triggerSearch(value),
            textInputAction: TextInputAction.search,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterButton(
                    "Filter",
                    icon: Icons.filter_list,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Filter Tapped!")),
                      );
                    },
                  ),
                  _buildFilterButton("Special Promo", icon: Icons.local_offer),
                  _buildFilterButton("Top Rated", icon: Icons.star),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _searchResultsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                            onPressed: () => _triggerSearch(_currentQuery),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        _currentQuery.isEmpty
                            ? 'Enter a location to search'
                            : 'No properties found for "$_currentQuery".',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    );
                  }

                  final results = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Found ${results.length} Rentals for "$_currentQuery"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final property = results[index];
                            return GestureDetector(
                              onTap: () {
                                print('Tapped on search result: ${property['id']}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RoomDetailsPage(
                                      propertyId: property['id'],
                                    ),
                                  ),
                                );
                              },
                              child: PropertyCard(
                                property: Map<String, dynamic>.from(property),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    String text, {
    IconData? icon,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      child: ActionChip(
        avatar:
            icon != null
                ? Icon(
                  icon,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.brown,
                )
                : null,
        label: Text(text),
        onPressed:
            onTap ??
            () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("$text Filter Tapped!")));
            },
        backgroundColor: isSelected ? Colors.brown : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
        elevation: isSelected ? 2 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final title = property['title'] ?? 'No Title';
    final location = property['location'] ?? 'Unknown Location';
    final propertyType = property['property_type'] ?? 'N/A';
    final priceRaw = property['price_per_month'];
    final price =
        priceRaw != null ? '₹$priceRaw per month' : 'Price not available';
    final imageUrl =
        (property['image_urls'] is List && property['image_urls'].isNotEmpty)
            ? property['image_urls'][0]
            : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          print('Tapped on search result: ${property['id']}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailsPage(
                propertyId: property['id'],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child:
                  imageUrl != null
                      ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, size: 40),
                            ),
                      )
                      : const Center(
                        child: Icon(Icons.house_rounded, size: 50),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.brown.withOpacity(0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    propertyType,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
