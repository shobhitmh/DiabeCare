import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HealthRecommendationScreen extends StatefulWidget {
  @override
  _HealthRecommendationScreenState createState() =>
      _HealthRecommendationScreenState();
}

class _HealthRecommendationScreenState
    extends State<HealthRecommendationScreen> {
  // Controllers for input fields
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String gender = "male"; // Default gender
  String activityLevel = "low"; // Default activity level

  String dietRecommendation = "";
  String exerciseRecommendation = "";
  String additionalTips = "";

  // Function to send HTTP request and fetch recommendations
  Future<void> fetchHealthRecommendations() async {
    final age = ageController.text;
    final weight = weightController.text;

    if (age.isEmpty || weight.isEmpty) {
      // Validate input
      setState(() {
        dietRecommendation = "Please enter all fields.";
        exerciseRecommendation = "";
        additionalTips = "";
      });
      return;
    }

    final url = Uri.parse(
        'http://192.168.53.185:5000/health_recommendations?age=$age&weight=$weight&gender=$gender&activity_level=$activityLevel');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          dietRecommendation =
              data['diet'] ?? "No diet recommendation available.";
          exerciseRecommendation =
              data['exercise'] ?? "No exercise recommendation available.";
          additionalTips =
              data['additional_tips'] ?? "No additional tips available.";
        });
      } else {
        setState(() {
          dietRecommendation =
              "Error fetching recommendations. Please try again.";
          exerciseRecommendation = "";
          additionalTips = "";
        });
      }
    } catch (e) {
      setState(() {
        dietRecommendation = "Failed to connect to the server.";
        exerciseRecommendation = "";
        additionalTips = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            'Recommendations',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Age"),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Weight (kg)"),
              ),
              DropdownButton<String>(
                value: gender,
                items: [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                ],
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
                hint: Text("Select Gender"),
              ),
              DropdownButton<String>(
                value: activityLevel,
                items: [
                  DropdownMenuItem(value: "low", child: Text("Low")),
                  DropdownMenuItem(value: "moderate", child: Text("Moderate")),
                  DropdownMenuItem(value: "high", child: Text("High")),
                ],
                onChanged: (value) {
                  setState(() {
                    activityLevel = value!;
                  });
                },
                hint: Text("Select Activity Level"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchHealthRecommendations,
                child: Text('Get Recommendations'),
              ),
              SizedBox(height: 20),
              // Display recommendations
              Text(
                'Diet Recommendation:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(dietRecommendation),
              SizedBox(height: 10),
              Text(
                'Exercise Recommendation:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(exerciseRecommendation),
              SizedBox(height: 10),
              Text(
                'Additional Tips:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(additionalTips),
            ],
          ),
        ),
      ),
    );
  }
}
