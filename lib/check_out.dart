import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'payment_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

class CheckoutPage extends StatefulWidget {
  final DateTime selectedDate; // check-in
  final DateTime checkoutDate;
  final String dormitoryName;
  final String ownerEmail;
  final double totalAmount; // price per month
  final String propertyId;
  final String dormitoryImage;
  final String dormitoryDescription;
  final Map<String, dynamic> amenities;

  const CheckoutPage({
    Key? key,
    required this.selectedDate,
    required this.checkoutDate,
    required this.dormitoryName,
    required this.ownerEmail,
    required this.totalAmount,
    required this.propertyId,
    required this.dormitoryImage,
    required this.dormitoryDescription,
    required this.amenities,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isLoading = false;

  int get _numberOfDays {
    return widget.checkoutDate.difference(widget.selectedDate).inDays;
  }

  double get _actualTotalAmount {
    return (widget.totalAmount * _numberOfDays) / 30;
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }

  Future<void> _navigateToPayment() async {
    if (widget.ownerEmail.isEmpty) {
      _fetchOwnerEmail();
      return;
    }
    await _createBooking(); // Create booking before navigating

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaymentPage(
              dormitoryName: widget.dormitoryName,
              ownerEmail: widget.ownerEmail,
              checkInDate: widget.selectedDate,
              checkoutDate: widget.checkoutDate,
              totalAmount: _actualTotalAmount,
            ),
      ),
    );
  }

  Future<void> _createBooking() async {
    final userId = await storage.read(key: "user_id");
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please log in to book.')));
      return;
    }

    final url = Uri.parse('${baseUrl}/bookings/');
    final bookingPayload = {
      'user_id': userId,
      'property_id': widget.propertyId,
      'check_in_date': widget.selectedDate.toIso8601String(),
      'check_out_date': widget.checkoutDate.toIso8601String(),
      'total_amount': _actualTotalAmount.toStringAsFixed(2),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bookingPayload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Booking created successfully");
      } else {
        print(
          "❌ Booking creation failed: ${response.statusCode} - ${response.body}",
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to create booking')));
      }
    } catch (e) {
      print("❌ Error creating booking: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating booking: $e')));
    }
  }

  Future<void> _fetchOwnerEmail() async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse('${baseUrl}/get_property/${widget.propertyId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final propertyData = json.decode(response.body);
        final ownerEmail =
            propertyData['owner_email'] ??
            propertyData['creator_email'] ??
            propertyData['email'] ??
            '';

        setState(() => isLoading = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => PaymentPage(
                  dormitoryName: widget.dormitoryName,
                  ownerEmail: ownerEmail.isNotEmpty ? ownerEmail : 'b@a.com',
                  checkInDate: widget.selectedDate,
                  checkoutDate: widget.checkoutDate,
                  totalAmount: _actualTotalAmount,
                ),
          ),
        );
      } else {
        _fallbackToDefaultEmail();
      }
    } catch (_) {
      _fallbackToDefaultEmail();
    }
  }

  void _fallbackToDefaultEmail() {
    setState(() => isLoading = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaymentPage(
              dormitoryName: widget.dormitoryName,
              ownerEmail: 'b@a.com',
              checkInDate: widget.selectedDate,
              checkoutDate: widget.checkoutDate,
              totalAmount: _actualTotalAmount,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.dormitoryImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.dormitoryName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.dormitoryDescription,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                'Amenities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    widget.amenities.entries
                        .where((entry) => entry.value == true)
                        .map(
                          (entry) => Chip(
                            label: Text(entry.key),
                            backgroundColor: Colors.brown.shade100,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Booking Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildDetailRow(
                'Check-in Date',
                _formatDate(widget.selectedDate),
              ),
              _buildDetailRow(
                'Check-out Date',
                _formatDate(widget.checkoutDate),
              ),
              _buildDetailRow('Number of Days', '$_numberOfDays days'),
              _buildDetailRow(
                'Price per Month',
                '₹${widget.totalAmount.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${_actualTotalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _navigateToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Proceed to Payment',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
