import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:clientapp/pages/record_details.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserProfilePage extends StatelessWidget {
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
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No user data found'));
          }
          final userInfo = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.teal[100],
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.teal[600],
                        ),
                      ),
                      SizedBox(height: 20),

                      // User Info Card
                      Text(
                        userInfo['userName'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              SizedBox(height: 8),
                              Text(
                                '${userInfo['userAge']} Years old',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.teal[600],
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 8),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "Email: " + userInfo['userEmail'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.teal[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Phone: " + userInfo['userPhone'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.teal[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Update Profile Button
                      ElevatedButton(
                        onPressed: () {
                          // Action for updating profile
                        },
                        child: Text('Update Profile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Records Section
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Past Records',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            RecordsList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserInfo() async {
    final box = await Hive.openBox('app_data');
    return {
      'userName': box.get('userName', defaultValue: 'N/A'),
      'userAge': box.get('userAge', defaultValue: 'N/A'),
      'userEmail': box.get('userEmail', defaultValue: 'N/A'),
      'userPhone': box.get('userPhone', defaultValue: 'N/A'),
    };
  }
}

class RecordsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('user_records');
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box recordsBox, _) {
        if (recordsBox.isEmpty) {
          return Center(
            child: Text(
              'No records found.',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recordsBox.length,
          itemBuilder: (context, index) {
            final record = recordsBox.getAt(index) as Map;
            return Slidable(
              key: ValueKey(record),
              startActionPane: ActionPane(
                motion: StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      _confirmDelete(context, recordsBox, index);
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  leading: Icon(
                    record['prediction'] == 1
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    color:
                        record['prediction'] == 1 ? Colors.red : Colors.green,
                    size: 40,
                  ),
                  title: Text(
                    "Prediction: ${record['prediction'] == 1 ? 'High Risk' : 'Low Risk'}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          record['prediction'] == 1 ? Colors.red : Colors.green,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        "Pregnancies: ${record['pregnancies']}, Glucose: ${record['glucose']}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Diastolic: ${record['diastolic']}, BMI: ${record['bmi']}",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Recorded on: ${record['date']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.teal,
                  ),
                  onTap: () {
                    // Navigate to the record detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecordDetailPage(record: record),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Method to show a confirmation dialog before deleting a record
  void _confirmDelete(BuildContext context, Box recordsBox, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                recordsBox.deleteAt(index);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
