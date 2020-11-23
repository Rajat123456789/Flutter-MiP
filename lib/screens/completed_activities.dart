import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_activity_tracker/database/dbase.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompletedActivity {
  String uid;
  List activities;
  List time;
  String date;
  CompletedActivity({this.uid, this.activities, this.time, this.date});
}

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  List<CompletedActivity> completedActivities;

  fetchData() async {
    var data = await DatabaseService()
        .getCompletedActivities(FirebaseAuth.instance.currentUser.uid);
    List<CompletedActivity> temp = [];
    data.docs.forEach((doc) {
      temp.add(new CompletedActivity(
          uid: doc.data()['uid'],
          activities: doc.data()['activities'],
          time: doc.data()['time'],
          date: doc.data()['date']));
    });
    setState(() {
      completedActivities = temp;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return completedActivities == null
        ? Scaffold(
            body: Container(
              child: Center(
                child: Text(
                  "You have not completed any activities yet",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.grey[700]),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Completed activities",
                style: GoogleFonts.montserrat(fontSize: 20.0),
              ),
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: completedActivities.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${completedActivities[index].date}',
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Activity List",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: completedActivities[index]
                                    .activities
                                    .length,
                                itemBuilder: (context, index1) {
                                  return Text(
                                    '${completedActivities[index].activities[index1]} for ${completedActivities[index].time[index1]} minutes',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16, color: Colors.grey[800]),
                                  );
                                })
                          ],
                        ),
                      ),
                    );
                  }),
            ));
  }
}
