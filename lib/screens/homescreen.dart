import 'package:fitness_activity_tracker/screens/add_activity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_activity_tracker/database/dbase.dart';
import 'package:fitness_activity_tracker/screens/completed_activities.dart';
import 'package:fitness_activity_tracker/screens/sign_in.dart';
import 'package:audioplayers/audio_cache.dart';

class Activity {
  String name;
  int duration;
  Activity({this.name, this.duration});
}

class HomeScreen extends StatefulWidget {
  final String uid;
  HomeScreen({this.uid});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  List<Activity> activities = [];

  // timer variables
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
    });
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

  void playSound() {
    // final p = AudioCache();
    // p.play();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Expanded(
              child: Image(
                image: AssetImage('images/drawer-image.jpg'),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 2.0, color: Colors.grey[200]),
              )),
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: Colors.grey[900],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FlatButton(
                    child: Text(
                      'View My Activity',
                      style: GoogleFonts.montserrat(
                          fontSize: 17.0, color: Colors.grey[700]),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Completed()),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 2.0, color: Colors.grey[200]),
              )),
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.grey[900],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FlatButton(
                    child: Text(
                      'Sign Out',
                      style: GoogleFonts.montserrat(
                          fontSize: 17.0, color: Colors.grey[700]),
                    ),
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SigninPage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50.0),
          Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width - 50,
            height: 180.0,
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
          SizedBox(height: 18.0),
          Text('Your Activity',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, fontSize: 25.0)),
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            height: 360.0,
            child: activities.length < 1
                ? Center(
                    child: Text("You have not added any activities yet",
                        style: GoogleFonts.montserrat(
                            fontSize: 20.0, color: Colors.grey[400])))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage: AssetImage(
                                'images/${activities[index].name}.jpg')),
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
                            await DatabaseService().deleteActivity(
                                widget.uid,
                                activities[index].name,
                                activities[index].duration);
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
                      setState(() {
                        index = 0;
                        activity = null;
                        timerActive = false;
                      });
                    } else {
                      setState(() {
                        timerActive = true;
                      });
                      startTimer();
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
