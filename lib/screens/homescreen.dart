import 'package:fitness_activity_tracker/screens/add_activity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class Activity {
  String name;
  int duration;
  Activity({this.name, this.duration});
}

class TempScreen extends StatefulWidget {
  @override
  _TempScreenState createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  List activities = [
    Activity(name: 'Cycling', duration: 1),
    Activity(name: 'Skipping', duration: 2),
    Activity(name: 'Plank', duration: 1),
    Activity(name: 'Push-up', duration: 5),
    Activity(name: 'Yoga', duration: 3),
    Activity(name: 'Running', duration: 5),
  ];

  var min;
  var sec;
  var activity;
  var index = 0;
  var startStopButton = 'START';
  var d = Duration(seconds: 1);
  bool timerActive = false;
  Timer _timer;
  // var totalTime;

  void startTimer() {
    min = activities[index].duration;
    sec = 0;
    activity = activities[index].name;
    _timer = new Timer.periodic(d, (timer) {
      setState(() {
        sec = (sec == 0) ? 59 : sec - 1;
        min = (sec == 59) ? min - 1 : min;
        if (min == 0 && sec == 0) {
          index++;
          if (index == activities.length) {
            _timer.cancel();
          }
          min = activities[index].duration;
          sec = 0;
          activity = activities[index].name;
        }
      });
      // if (index == activities.length - 1 && min == 0 && sec == 0) {
      //   timerActive = false;
      //   _timer.cancel();
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
                Text('Activity',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 25.0)),
                RaisedButton(
                  onPressed: () {},
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
                      onPressed: () {},
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
                        timerActive = false;
                        index = 0;
                        activities = null;
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddActivity()),
            );
          },
        ),
      ),
    );
  }
}
