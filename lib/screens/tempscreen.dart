import 'package:fitness_activity_tracker/screens/add_activity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_activity_tracker/database/dbase.dart';
import 'package:fitness_activity_tracker/screens/completed_activities.dart';
import 'package:audioplayers/audio_cache.dart';

class Activity {
  String name;
  int duration;
  Activity({this.name, this.duration});
}

class TempScreen extends StatefulWidget {
  final String uid;
  TempScreen({this.uid});
  @override
  _TempScreenState createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  final _auth = FirebaseAuth.instance;
  List<Activity> activities = [];

  void playSound() {
    final p = AudioCache();
    // TODO: p.play();
  }

  fetchData() async {
    var data = await DatabaseService().getActivities(widget.uid);
    List<Activity> temp = [];
    data.docs.forEach((doc) {
      temp.add(new Activity(
          name: doc.data()['activity'], duration: doc.data()['duration']));
    });
    setState(() {
      activities = temp;
    });
  }

  insertCompletedActivity() async {
    List<String> act = [];
    List<int> time = [];
    activities.forEach((element) {
      act.add(element.name);
      time.add(element.duration);
    });
    await DatabaseService()
        .addCompletedActivity(act, time, FirebaseAuth.instance.currentUser.uid);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  var min;
  var sec;
  var activity;
  var index = 0;
  var startStopButton = 'START';
  var d = Duration(seconds: 1);
  bool timerActive = false;
  Timer _timer;
  var totalTime;

  void startTimer() {
    // play sound
    min = activities[index].duration;
    sec = 0;
    activity = activities[index].name;
    _timer = new Timer.periodic(d, (timer) {
      setState(() {
        sec = (sec == 0) ? 59 : sec - 1;
        min = (sec == 59) ? min - 1 : min;
        if (min == 0 && sec == 0) {
          // new activity
          // play sound
          index++;
          if (index == activities.length) {
            _timer.cancel();

            index = 0;
            activity = null;
            timerActive = false;
            insertCompletedActivity();
          }
          min = activities[index].duration;
          sec = 0;
          activity = activities[index].name;
        }
      });
      // if (index == activities.length && min == 0 && sec == 0) {
      //   _timer.cancel();
      //   setState(() {
      //     timerActive = false;
      //     index = 0;
      //     activity = null;
      //   });
      //   insertCompletedActivity();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  child: Text(
                    'View Activity',
                    style: GoogleFonts.montserrat(
                        fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Completed()),
                    );
                  },
                ),
                RaisedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pop(context);
                  },
                  color: Colors.deepOrange,
                  child: Text(
                    'Sign Out',
                    style: GoogleFonts.montserrat(
                        fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width - 50,
            height: 170.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.blue[200]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // timer here
                Text(activity == null ? '' : 'Start $activity',
                    style: GoogleFonts.montserrat(
                        fontSize: 30.0, fontWeight: FontWeight.w700)),
                SizedBox(height: 10.0),
                Text(timerActive ? 'Time remaining' : '',
                    style: GoogleFonts.montserrat(fontSize: 20.0)),
                SizedBox(height: 10.0),
                Text(!timerActive ? '' : '$min min : $sec sec',
                    style: GoogleFonts.montserrat(
                        fontSize: 25.0, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Text('Your Activity',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, fontSize: 20.0)),
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            height: 330.0,
            child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            AssetImage('images/${activities[index].name}.jpg')),
                    title: Text(activities[index].name,
                        style: GoogleFonts.montserrat(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    subtitle: Text(
                      '${activities[index].duration} min',
                      style: GoogleFonts.montserrat(
                          fontSize: 15.0,
                          color: Colors.grey[850],
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 25.0,
                      onPressed: () async {
                        await DatabaseService().deleteActivity(widget.uid,
                            activities[index].name, activities[index].duration);
                        fetchData();
                      },
                      color: Colors.red[700],
                    ),
                  ));
                }),
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            onPressed: activities.length == 0
                ? null
                : () {
                    setState(() {
                      startStopButton =
                          startStopButton == 'START' ? 'STOP' : 'START';
                    });
                    if (timerActive) {
                      _timer.cancel();
                      timerActive = false;
                    } else {
                      startTimer();
                      timerActive = true;
                    }
                  },
            color: Colors.blue,
            child: Text('$startStopButton',
                style: GoogleFonts.montserrat(
                    fontSize: 20.0, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
        child: IconButton(
          icon: Icon(Icons.fitness_center),
          color: Colors.black,
          iconSize: 40.0,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddActivity(uid: widget.uid)),
            );
            fetchData();
          },
        ),
      ),
    );
  }
}
