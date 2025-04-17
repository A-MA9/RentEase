import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'check_in.dart';
import 'check_out.dart';

class CheckoutDatePage extends StatefulWidget {
  final DateTime checkInDate;
  final String dormitoryName;
  final String ownerEmail;
  final double totalAmount;
  final String propertyId;
  final String dormitoryImage;
  final String dormitoryDescription;
  final Map<String, dynamic> amenities;

  const CheckoutDatePage({
    Key? key,
    required this.checkInDate,
    required this.dormitoryName,
    required this.ownerEmail,
    required this.totalAmount,
    required this.propertyId,
    required this.dormitoryImage,
    required this.dormitoryDescription,
    required this.amenities,
  }) : super(key: key);

  @override
  _CheckoutDatePageState createState() => _CheckoutDatePageState();
}

class _CheckoutDatePageState extends State<CheckoutDatePage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.checkInDate.add(Duration(days: 1));
    _focusedDay = _selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Checkout Date",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: widget.checkInDate.add(Duration(days: 1)),
              lastDay: DateTime(2026, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.brown,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CheckoutPage(
                          selectedDate: widget.checkInDate,
                          checkoutDate: _selectedDay,
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
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Continue to Checkout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
