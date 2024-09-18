import 'package:clientapp/pages/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class healthrecommendationscreen2 extends StatefulWidget {
  const healthrecommendationscreen2({super.key});

  @override
  State<healthrecommendationscreen2> createState() =>
      _healthrecommendationscreen2State();
}

class _healthrecommendationscreen2State
    extends State<healthrecommendationscreen2> {
  // Controllers for input fields
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController sleepHoursController = TextEditingController();
  String gender = "male"; // Default gender
  String activityLevel = "low"; // Default activity level
  String stressLevel = "low"; // Default stress level

  String dietRecommendation = "";
  String exerciseRecommendation = "";
  String additionalTips = "";
  String sleepRecommendation = "";
  String stressManagementRecommendation = "";

  // Function to send HTTP request and fetch recommendations
  Future<void> fetchHealthRecommendations() async {
    final age = ageController.text;
    final weight = weightController.text;
    final height = heightController.text;
    final sleepHours = sleepHoursController.text;

    if (age.isEmpty || weight.isEmpty || height.isEmpty || sleepHours.isEmpty) {
      // Validate input
      setState(() {
        dietRecommendation = "Please enter all fields.";
        exerciseRecommendation = "";
        additionalTips = "";
        sleepRecommendation = "";
        stressManagementRecommendation = "";
      });
      return;
    }

    final url = Uri.parse(
        'http://192.168.185.184:5000/health_recommendations?age=$age&weight=$weight&height=$height&gender=$gender&activity_level=$activityLevel&sleep_hours=$sleepHours&stress_level=$stressLevel');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);

        setState(() {
          dietRecommendation = data['diet'] ?? "No diet recommendation";
          exerciseRecommendation =
              data['exercise'] ?? "No exercise recommendation";
          additionalTips = data['additional_tips'] ?? "No additional tips ";
          sleepRecommendation = data['sleep'] ?? "No sleep recommendation";
          stressManagementRecommendation =
              data['stress_management'] ?? "No stress management advice ";
        });
      } else {
        setState(() {
          dietRecommendation =
              "Error fetching recommendations. Please try again.";
          exerciseRecommendation = "";
          additionalTips = "";
          sleepRecommendation = "";
          stressManagementRecommendation = "";
        });
      }
    } catch (e) {
      setState(() {
        dietRecommendation = "Failed to connect to the server.";
        exerciseRecommendation = "";
        additionalTips = "";
        sleepRecommendation = "";
        stressManagementRecommendation = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        title: Text(
          'Recommendations',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),

              Text(
                'Get your personalized health and wellness guidance',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20),

              // Title
              Text(
                'Enter Your Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),

              // Age Input
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Age",
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Weight Input
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Weight (kg)",
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Height Input
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Height (m)",
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Sleep Hours Input
              TextField(
                controller: sleepHoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Sleep Hours",
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                ],
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Activity Level Dropdown
              DropdownButtonFormField<String>(
                value: activityLevel,
                decoration: InputDecoration(
                  labelText: 'Activity Level',
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
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
              ),
              SizedBox(height: 20),

              // Stress Level Dropdown
              DropdownButtonFormField<String>(
                value: stressLevel,
                decoration: InputDecoration(
                  labelText: 'Stress Level',
                  labelStyle: TextStyle(color: Colors.teal),
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: "low", child: Text("Low")),
                  DropdownMenuItem(value: "moderate", child: Text("Moderate")),
                  DropdownMenuItem(value: "high", child: Text("High")),
                ],
                onChanged: (value) {
                  setState(() {
                    stressLevel = value!;
                  });
                },
              ),
              SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: fetchHealthRecommendations,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Get Recommendations',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Recommendations Card
              if (dietRecommendation.isNotEmpty) ...[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diet Recommendation:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(dietRecommendation),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exercise Recommendation:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(exerciseRecommendation),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Additional Tips:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(additionalTips),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
