import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:fitness_activity_tracker/database/dbase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddActivity extends StatefulWidget {
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  String activitySelected = 'Cycling';
  int timeSelected = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/add-activity.png'),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Select Activity',
                    style: GoogleFonts.montserrat(
                        color: Colors.grey[700], fontSize: 20.0))
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            DropdownButton<String>(
              value: activitySelected,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              style: GoogleFonts.montserrat(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                setState(() {
                  activitySelected = newValue;
                });
              },
              items: <String>[
                'Cycling',
                'Dumbbell',
                'Plank',
                'Push-up',
                'Running',
                'Sit-up',
                'Skipping',
                'Yoga',
                'Superman',
                'Bridge',
                'Squat'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/$value.jpg'),
                      ),
                      SizedBox(width: 20.0),
                      Text(value)
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Select Duration',
                    style: GoogleFonts.montserrat(
                        color: Colors.grey[700], fontSize: 20.0))
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            NumberPicker.integer(
                initialValue: timeSelected,
                minValue: 1,
                maxValue: 10,
                onChanged: (newValue) =>
                    setState(() => timeSelected = newValue)),
            SizedBox(height: 20.0),
            RaisedButton.icon(
                onPressed: () async {
                  await DatabaseService().addActivity(
                      FirebaseAuth.instance.currentUser.uid,
                      activitySelected,
                      timeSelected);
                  Navigator.pop(context);
                },
                color: Colors.amber,
                icon: Icon(Icons.add),
                label: Text('Add',
                    style: GoogleFonts.montserrat(
                        fontSize: 20.0, fontWeight: FontWeight.w500)))
          ],
        ),
      ),
    );
  }
}
