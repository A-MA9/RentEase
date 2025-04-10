import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'check_out.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';

class CheckInDatePage extends StatefulWidget {
  final String dormitoryName;
  final String ownerEmail;
  final double totalAmount;
  final String propertyId;
  final String dormitoryImage;
  final String dormitoryDescription;
  final Map<String, dynamic> amenities;

  const CheckInDatePage({
    Key? key,
    required this.dormitoryName,
    required this.ownerEmail,
    required this.totalAmount,
    required this.propertyId,
    required this.dormitoryImage,
    required this.dormitoryDescription,
    required this.amenities,
  }) : super(key: key);

  @override
  _CheckInDatePageState createState() => _CheckInDatePageState();
}

class _CheckInDatePageState extends State<CheckInDatePage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> _createBooking() async {
    try {
      final userId = await storage.read(key: "user_id");
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to book')),
        );
        return;
      }

      final url = Uri.parse('${baseUrl}/bookings/');
      print('Creating booking with data: ${json.encode({
        'user_id': userId,
        'property_id': widget.propertyId,
        'check_in_date': _selectedDay.toIso8601String(),
        'total_amount': widget.totalAmount.toString(),
      })}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'property_id': widget.propertyId,
          'check_in_date': _selectedDay.toIso8601String(),
          'total_amount': widget.totalAmount.toString(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking created successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        print('Failed to create booking: ${response.statusCode} - ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create booking: ${response.body}')),
          );
        }
      }
    } catch (e) {
      print('Error creating booking: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating booking: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Select Check-in date",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "The following are the available check-in dates.",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.black54,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.brown.shade400,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(fontSize: 16, color: Colors.black),
                weekendTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.black54),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(
                        selectedDate: _selectedDay,
                        dormitoryName: widget.dormitoryName,
                        ownerEmail: widget.ownerEmail,
                        totalAmount: widget.totalAmount,
                        propertyId: widget.propertyId,
                        dormitoryImage: widget.dormitoryImage,
                        dormitoryDescription: widget.dormitoryDescription,
                        amenities: widget.amenities,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Continue to Checkout",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
