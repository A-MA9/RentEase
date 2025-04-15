import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'room_details.dart';
import 'login.dart';
import 'constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isLoading = true;
  List<dynamic> favorites = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<bool> _isUserLoggedIn() async {
    String? token = await storage.read(key: "access_token");
    return token != null;
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Login Required"),
            content: const Text(
              "Please log in to view your favorite properties.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ).then((_) => fetchFavorites());
                },
                child: const Text("Login"),
              ),
            ],
          ),
    );
  }

  Future<void> fetchFavorites() async {
    setState(() {
      isLoading = true;
    });

    bool isLoggedIn = await _isUserLoggedIn();
    if (!isLoggedIn) {
      setState(() {
        isLoading = false;
        favorites = [];
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        _showLoginPrompt(context);
      });
      return;
    }

    try {
      String? token = await storage.read(key: "access_token");
      if (token == null) {
        setState(() {
          isLoading = false;
          favorites = [];
        });
        return;
      }

      final url = Uri.parse('${baseUrl}/favorites');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          favorites = data;
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load favorites. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
          favorites = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network error. Please check your connection.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
        favorites = [];
      });
    }
  }

  Future<void> toggleFavorite(String propertyId) async {
    try {
      String? token = await storage.read(key: "access_token");
      if (token == null) {
        _showLoginPrompt(context);
        return;
      }

      setState(() {
        isLoading = true;
      });

      final url = Uri.parse('${baseUrl}/favorites/toggle');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'property_id': propertyId}),
      );

      if (response.statusCode == 200) {
        fetchFavorites();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to toggle favorite. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network error. Please check your connection.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          'My Favorites',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: fetchFavorites,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : favorites.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 70,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Properties you like will appear here',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final property = favorites[index];
                  return PropertyCard(
                    property: property,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  RoomDetailsPage(propertyId: property['id']),
                        ),
                      ).then((_) => fetchFavorites());
                    },
                    onRemove: () async {
                      await toggleFavorite(property['id'].toString());
                    },
                  );
                },
              ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.onTap,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child:
                      property['image_urls'] != null &&
                              property['image_urls'].isNotEmpty
                          ? Image.network(
                            property['image_urls'][0],
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                          )
                          : Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.home,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                if (property['price_per_month'] != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Text(
                        '₹${property['price_per_month']}/month',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property['location'] ?? 'Unknown Location',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildFeature(
                        Icons.hotel,
                        '${property['rooms_available'] ?? 1} Room${property['rooms_available'] != 1 ? 's' : ''}',
                      ),
                      const SizedBox(width: 16),
                      _buildFeature(
                        Icons.bathroom,
                        '${property['bath'] ?? 1} Bath${property['bath'] != 1 ? 's' : ''}',
                      ),
                      if (property['size_sqft'] != null) ...[
                        const SizedBox(width: 16),
                        _buildFeature(
                          Icons.square_foot,
                          '${property['size_sqft']} sqft',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.brown),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
