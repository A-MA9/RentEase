import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? _selectedGender = 'Male';
  String? _selectedWork = 'Other';
  DateTime? _selectedDate;
  bool _isLoading = true;
  String _errorMessage = '';
  bool _saveInProgress = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // First try to get data from local storage
      final userData = await UserService.getLocalUserData();
      
      // Set the controllers with existing data
      _nameController.text = userData['full_name'] ?? '';
      _contactController.text = userData['phone_number'] ?? '';
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load profile data. Please try again.';
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _saveInProgress = true;
      _errorMessage = '';
    });
    
    try {
      final result = await UserService.updateUserProfile(
        fullName: _nameController.text,
        phoneNumber: _contactController.text,
      );
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      setState(() {
        _saveInProgress = false;
      });
      
      // Navigate back after successful save
      Navigator.pop(context);
    } catch (e) {
      print('Error saving profile: $e');
      setState(() {
        _saveInProgress = false;
        _errorMessage = 'Failed to update profile. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Information", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: Colors.brown))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Change Photo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(8),
                      color: Colors.red.shade100,
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          _buildTextField("Full Name", _nameController, false),
                          _buildDropdownField("Gender", ['Male', 'Female', 'Other'], _selectedGender, (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          }),
                          _buildDateField("Date of Birth"),
                          _buildDropdownField("Work", ['Athlete', 'Engineer', 'Doctor', 'Student','Other'], _selectedWork, (value) {
                            setState(() {
                              _selectedWork = value;
                            });
                          }),
                          _buildTextField("Contact Number", _contactController, true),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  _buildSendButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDateField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: _selectedDate == null ? "Select Date" : DateFormat('dd-MM-yyyy').format(_selectedDate!),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Colors.brown.shade700, Colors.brown.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _saveInProgress ? null : _saveProfile,
        child: _saveInProgress 
          ? CircularProgressIndicator(color: Colors.white)
          : Text("Save Changes", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}