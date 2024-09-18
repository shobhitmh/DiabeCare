import 'package:clientapp/pages/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OnboardingPage extends StatefulWidget {
  final Future<void> Function() onboardingCompleted;

  OnboardingPage({required this.onboardingCompleted});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  'Please provide the following details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildTextField('Name', nameController),
                _buildTextField('Age', ageController),
                _buildTextField('Email', emailController),
                _buildTextField('Phone', phoneController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        ageController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty) {
                      await _saveUserInfo();
                      widget.onboardingCompleted();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields')),
                      );
                    }
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Text('Save and Continue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> _saveUserInfo() async {
    final box = Hive.box('app_data');
    await box.put('userName', nameController.text);
    await box.put('userAge', ageController.text);
    await box.put('userEmail', emailController.text);
    await box.put('userPhone', phoneController.text);
  }
}
