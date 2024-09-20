import 'dart:convert';
import 'dart:math';
import 'package:clientapp/pages/recommendationscreen2.dart';
import 'package:clientapp/pages/record_details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:clientapp/pages/healthadvices.dart';
import 'package:clientapp/pages/homescreen.dart';
import 'package:clientapp/pages/user_profile.dart';
import 'package:clientapp/pages/record.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('user_records');

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            SizedBox(height: 20),
            const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'DiabeCare',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Your personalized diabetes care app.',
              style: TextStyle(fontSize: 16, color: Colors.teal[600]),
            ),
            SizedBox(height: 20),

            // Latest Health Update
            ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box recordsBox, _) {
                if (recordsBox.isEmpty) {
                  return _buildEmptyState();
                }

                final latestRecord =
                    recordsBox.getAt(recordsBox.length - 1) as Map;
                return _buildHealthUpdateCard(context, latestRecord);
              },
            ),

            // Quick Access Buttons using GridView
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1, // Adjust aspect ratio for button size
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Prevent scrolling
              crossAxisSpacing: 8, // Set smaller spacing between columns
              mainAxisSpacing: 8, // Set smaller spacing between rows
              children: [
                _buildQuickAccessButton(Icons.person, 'Profile', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UserProfilePage()),
                  );
                }),
                _buildQuickAccessButton(Icons.history, 'View Records', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RecordsPage()),
                  );
                }),
                _buildQuickAccessButton(Icons.lightbulb, 'Predict', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }),
                _buildQuickAccessButton(
                    Icons.check_circle_outline, 'Recommendation', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => healthrecommendationscreen2()),
                  );
                }),
              ],
            ),

            // Daily Health Tips
            _buildHealthTipCard(getRandomTip()),
            SizedBox(height: 20),

            // Motivational Quote
            Center(
              child: Text(
                '"Empower yourself with knowledge!"',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No health updates available.',
        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildHealthUpdateCard(BuildContext context, Map latestRecord) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordDetailPage(record: latestRecord),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Latest Diabetes Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 12),

              // Prediction
              Row(
                children: [
                  Icon(
                    latestRecord['prediction'] == 1
                        ? Icons.warning
                        : Icons.check_circle,
                    color: latestRecord['prediction'] == 1
                        ? Colors.red
                        : Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Prediction: ${latestRecord['prediction'] == 1 ? 'High Risk' : 'Low Risk'}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: latestRecord['prediction'] == 1
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Date
              Text(
                'Recorded on: ${latestRecord['date']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthTipCard(String tip) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.tealAccent.withOpacity(0.2),
              Color.fromARGB(255, 217, 237, 218),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info, color: Colors.teal, size: 30),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  tip,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(
      IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade50,
            child: Icon(
              icon,
              size: 50,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
