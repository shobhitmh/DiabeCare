import 'dart:convert';
import 'package:clientapp/pages/health_recommendation.dart';
import 'package:clientapp/pages/health_tips.dart';
import 'package:clientapp/pages/recommendationscreen2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController pregnanciesController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController tricepsController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController dpfController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String output = "Prediction result will appear here";

  Future<void> predict() async {
    String url =
        'http://192.168.53.185:5000/predict?pregnancies=${pregnanciesController.text}&glucose=${glucoseController.text}&diastolic=${diastolicController.text}&triceps=${tricepsController.text}&insulin=${insulinController.text}&bmi=${bmiController.text}&dpf=${dpfController.text}&age=${ageController.text}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          output = jsonResponse['prediction'] != null
              ? 'Prediction: ${jsonResponse['prediction']}'
              : 'Error: ${jsonResponse['error']}';

          // Navigate to HealthTipsScreen if prediction is 1
          if (jsonResponse['prediction'] == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HealthTipsScreen()),
            );
          } else {
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
        drawer: Drawer(
          backgroundColor: Colors.teal,
          child: Column(
            children: [
              Icon(
                Icons.health_and_safety_rounded,
                size: 250,
                color: Colors.white,
              ),
              Text(
                'DiabeCare',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Divider(),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  title: Text(
                    'Home',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.arrow_right),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => healthrecommendationscreen2()));
                  },
                  trailing: Icon(Icons.arrow_right),
                  title: Text('Recommendations',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
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
                buildTextField("Triceps", tricepsController),
                buildTextField("Insulin", insulinController),
                buildTextField("BMI", bmiController),
                buildTextField("DPF", dpfController),
                buildTextField("Age", ageController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: predict,
                  child: const Text("Predict"),
                ),
                const SizedBox(height: 20),
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
                        offset: Offset(0, 3),
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

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
