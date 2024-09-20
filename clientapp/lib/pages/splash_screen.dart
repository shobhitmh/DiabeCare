import 'package:clientapp/pages/home.dart';
import 'package:clientapp/pages/homescreen.dart';
import 'package:clientapp/pages/onboard.dart';
import 'package:clientapp/pages/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Import the UserProfilePage file

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox('app_data');
    _checkIfFirstLaunch();
  }

  Future<void> _checkIfFirstLaunch() async {
    final box = Hive.box('app_data');
    final hasLaunched = box.get('hasLaunched', defaultValue: false);

    if (!hasLaunched) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OnboardingPage(onboardingCompleted: _saveUserInfo)),
          );
        }
      });
    } else {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }
      });
    }
  }

  Future<void> _saveUserInfo() async {
    final box = Hive.box('app_data');
    await box.put('hasLaunched', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => UserProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
              'https://img.freepik.com/free-vector/online-doctor-concept_23-2148514648.jpg?t=st=1726601802~exp=1726605402~hmac=ae506b749a99320af20a694e7446838797297fe95f2b09de7bf84591e404e09d&w=740'),
          Text(
            'DiabeCare',
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}
