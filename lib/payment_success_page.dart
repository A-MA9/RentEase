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

  @override
  void initState() {
    super.initState();
    _createBooking();
  }

  Future<void> _createBooking() async {
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
          _error = e.toString();
          _isCreatingBooking = false;
        });
      }
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
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 60,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16),
            if (_isCreatingBooking)
              Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Creating your booking...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            else if (_error != null)
              Column(
                children: [
                  Text(
                    _error!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                    ),
                    child: Text(
                      "Retry",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            else
              Text(
                "Your booking has been confirmed",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }
} 