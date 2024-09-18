import 'package:clientapp/pages/record_details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('user_records');
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
          'Past Records',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ValueListenableBuilder(
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
                        color: record['prediction'] == 1
                            ? Colors.red
                            : Colors.green,
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
                          builder: (context) =>
                              RecordDetailPage(record: record),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
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
