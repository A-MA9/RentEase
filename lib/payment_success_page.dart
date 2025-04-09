import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_screen.dart';
import 'services/booking_service.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String dormitoryName;
  final String ownerEmail;
  final DateTime checkInDate;
  final double totalAmount;

  const PaymentSuccessPage({
    Key? key,
    required this.dormitoryName,
    required this.ownerEmail,
    required this.checkInDate,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentSuccessPageState createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  final storage = FlutterSecureStorage();
  bool _isCreatingBooking = false;
  String? _error;
  int _retryCount = 0;
  final int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _createBooking();
  }

  Future<void> _createBooking() async {
    if (_retryCount >= _maxRetries) {
      setState(() {
        _error = 'Maximum retry attempts reached. Please try again later or contact support.';
        _isCreatingBooking = false;
      });
      return;
    }

    try {
      setState(() {
        _isCreatingBooking = true;
        _error = null;
      });

      // Check for token first
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }

      final userEmail = await storage.read(key: 'email');
      print('🔹 Retrieved user email: $userEmail'); // Debug log
      
      if (userEmail == null) {
        throw Exception('User email not found. Please log in again.');
      }

      print('🔹 Creating booking with data:');
      print('  - Dormitory: ${widget.dormitoryName}');
      print('  - Seeker Email: $userEmail');
      print('  - Owner Email: ${widget.ownerEmail}');
      print('  - Check-in Date: ${widget.checkInDate}');
      print('  - Total Amount: ${widget.totalAmount}');

      if (widget.ownerEmail.isEmpty) {
        print('❌ Owner email is empty! This will cause the booking to fail.');
        throw Exception('Owner email is missing. Please try again or contact support.');
      }

      await BookingService.createBooking(
        dormitoryName: widget.dormitoryName,
        seekerEmail: userEmail,
        ownerEmail: widget.ownerEmail,
        checkInDate: widget.checkInDate,
        totalAmount: widget.totalAmount,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print('❌ Error creating booking: $e');
      if (mounted) {
        setState(() {
          _error = _getUserFriendlyErrorMessage(e.toString());
          _isCreatingBooking = false;
          _retryCount++;
        });
      }
    }
  }

  String _getUserFriendlyErrorMessage(String error) {
    if (error.contains('timed out')) {
      return 'Connection timed out. Please check your internet connection and try again.';
    } else if (error.contains('Failed to create booking')) {
      return 'Failed to create booking. Please try again later.';
    } else if (error.contains('No authentication token found')) {
      return 'You are not logged in. Please log in again.';
    } else if (error.contains('User email not found')) {
      return 'User information not found. Please log in again.';
    } else {
      return 'An error occurred: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isCreatingBooking) ...[
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
              ),
              const SizedBox(height: 20),
              const Text(
                'Creating your booking...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else if (_error != null) ...[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              if (_retryCount < _maxRetries)
                ElevatedButton(
                  onPressed: _createBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Go to Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ] else ...[
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 48,
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your booking has been confirmed.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Go to Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 