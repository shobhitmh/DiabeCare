import 'package:clientapp/pages/health_recommendation.dart';
import 'package:clientapp/pages/homescreen.dart';
import 'package:flutter/material.dart';

class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Icon(
                Icons.health_and_safety,
                color: Colors.white,
              ),
            ),
          )
        ],
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          "Health Tips",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have high risk of diabetes',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Here are some health tips',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.w100, fontSize: 20),
              ),
              const SizedBox(height: 20),
              _buildTipCard(
                context,
                Icons.restaurant_menu,
                'Diet',
                'Focus on a balanced diet rich in vegetables, whole grains, and lean proteins. Limit intake of sugary and processed foods.',
              ),
              const SizedBox(height: 16),
              _buildTipCard(
                context,
                Icons.fitness_center,
                'Exercise',
                'Aim for at least 30 minutes of moderate exercise most days of the week. Activities like brisk walking, swimming, or cycling are beneficial.',
              ),
              const SizedBox(height: 16),
              _buildTipCard(
                context,
                Icons.calendar_today,
                'Regular Check-ups',
                'Schedule regular check-ups with your healthcare provider to monitor your health and catch any issues early.',
              ),
              const SizedBox(height: 16),
              _buildTipCard(
                context,
                Icons.self_improvement,
                'Stress Management',
                'Practice stress-reducing techniques such as meditation, yoga, or deep breathing exercises.',
              ),
              const SizedBox(height: 16),
              _buildTipCard(
                context,
                Icons.local_drink,
                'Hydration',
                'Drink plenty of water throughout the day and limit sugary drinks.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(
      BuildContext context, IconData icon, String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.teal,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
