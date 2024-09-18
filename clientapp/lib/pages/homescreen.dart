import 'dart:convert';
import 'package:clientapp/pages/health_recommendation.dart';
import 'package:clientapp/pages/health_tips.dart';
import 'package:clientapp/pages/recommendationscreen2.dart';
import 'package:clientapp/pages/record.dart';
import 'package:clientapp/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers for the input fields
  final TextEditingController pregnanciesController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController tricepsController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController dpfController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Variable to hold the prediction output
  String output = "Prediction result will appear here";

  // Function to reset all input fields
  void clearFields() {
    pregnanciesController.clear();
    glucoseController.clear();
    diastolicController.clear();
    tricepsController.clear();
    insulinController.clear();
    bmiController.clear();
    dpfController.clear();
    ageController.clear();
  }

  // Function to handle prediction API request
  Future<void> predict() async {
    String url = 'http://192.168.185.184:5000/predict';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pregnancies': pregnanciesController.text,
          'glucose': glucoseController.text,
          'diastolic': diastolicController.text,
          'triceps': tricepsController.text,
          'insulin': insulinController.text,
          'bmi': bmiController.text,
          'dpf': dpfController.text,
          'age': ageController.text,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          output = jsonResponse['prediction'] != null
              ? 'Prediction: ${jsonResponse['prediction']}'
              : 'Error: ${jsonResponse['error']}';
          String date = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
          final box = Hive.box('user_records');
          box.add({
            'pregnancies': pregnanciesController.text,
            'glucose': glucoseController.text,
            'diastolic': diastolicController.text,
            'triceps': tricepsController.text,
            'insulin': insulinController.text,
            'bmi': bmiController.text,
            'dpf': dpfController.text,
            'age': ageController.text,
            'prediction': jsonResponse['prediction'],
            'date': date,
          });

          // Handle navigation based on prediction
          if (jsonResponse['prediction'] == 1) {
            clearFields();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HealthTipsScreen()),
            );
          } else {
            clearFields();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HealthRecommendationScreen()),
            );
          }
        });
      } else {
        setState(() {
          output = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        output = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Drawer for navigation
        drawer: Drawer(
          backgroundColor: Colors.teal,
          child: Column(
            children: [
              Icon(
                Icons.health_and_safety_rounded,
                size: 250,
                color: Colors.white,
              ),
              const Text(
                'DiabeCare',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              const Divider(),
              buildDrawerItem('Home', Icons.home, () {
                clearFields(); // Clear fields before navigating
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              }),
              buildDrawerItem('Recommendations', Icons.lightbulb, () {
                clearFields(); // Clear fields before navigating
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => healthrecommendationscreen2()));
              }),
              buildDrawerItem('Past Records', Icons.history, () {
                clearFields(); // Clear fields before navigating
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RecordsPage()));
              }),
              buildDrawerItem('Profile', Icons.person, () {
                clearFields(); // Clear fields before navigating
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserProfilePage()));
              }),
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.health_and_safety,
                  color: Colors.white,
                ),
              ),
            )
          ],
          title: const Text(
            "DiabeCare App",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter your details below:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 20),
                buildTextField("Pregnancies", pregnanciesController),
                buildTextField("Glucose", glucoseController),
                buildTextField("Diastolic", diastolicController),
                buildTextField(
                    "Triceps (Skin fold thickness)", tricepsController),
                buildTextField("Insulin", insulinController),
                buildTextField("BMI", bmiController),
                buildTextField("DPF", dpfController),
                buildTextField("Age", ageController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: predict,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Predict"),
                ),
                const SizedBox(height: 20),
                // Display the prediction result or error message
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    output,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to create a styled text field
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.teal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  // Function to create a styled drawer item
  Widget buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_right),
      ),
    );
  }
}
