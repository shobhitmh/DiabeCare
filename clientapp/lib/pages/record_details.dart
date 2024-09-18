import 'package:clientapp/pages/recommendationscreen2.dart';
import 'package:flutter/material.dart';

class RecordDetailPage extends StatelessWidget {
  final Map record;

  const RecordDetailPage({Key? key, required this.record}) : super(key: key);

  Widget buildInfoTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPositive = record['prediction'] == 1;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          'Record Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Card(
              margin: EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: isPositive ? Colors.redAccent : Colors.greenAccent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      isPositive ? Icons.warning : Icons.check_circle,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      isPositive
                          ? 'High Risk of Diabetes'
                          : 'Low Risk of Diabetes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      isPositive
                          ? 'Please consult a healthcare professional.'
                          : 'Keep up the good work!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Information Card
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: Column(
                children: [
                  buildInfoTile(
                    'Pregnancies',
                    '${record['pregnancies']}',
                    Icons.pregnant_woman,
                  ),
                  Divider(height: 1),
                  buildInfoTile(
                    'Glucose',
                    '${record['glucose']}',
                    Icons.local_drink,
                  ),
                  Divider(height: 1),
                  buildInfoTile(
                    'Diastolic Blood Pressure',
                    '${record['diastolic']} mm Hg',
                    Icons.favorite,
                  ),
                  Divider(height: 1),
                  buildInfoTile(
                    'Triceps Skin Fold Thickness',
                    '${record['triceps']} mm',
                    Icons.fitness_center,
                  ),
                  Divider(height: 1),
                  buildInfoTile(
                    'Insulin',
                    '${record['insulin']} µU/mL',
                    Icons.healing,
                  ),
                  Divider(height: 1),
                  buildInfoTile(
                    'BMI',
                    '${record['bmi']} kg/m²',
                    Icons.accessibility_new,
                  ),
                  Divider(height: 1),
                  buildInfoTile(
                    'Diabetes Pedigree Function',
                    '${record['dpf']}',
                    Icons.show_chart,
                  ),
                  Divider(height: 1),
                  buildInfoTile(
                    'Age',
                    '${record['age']} years',
                    Icons.cake,
                  ),
                ],
              ),
            ),

            // Date Card
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.teal),
                title: Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${record['date']}'),
              ),
            ),

            // Action Button
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Implement navigation to recommendations or further action
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => healthrecommendationscreen2()));
              },
              icon: Icon(Icons.health_and_safety),
              label: Text('Get Health Recommendations'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
