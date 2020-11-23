import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_activity_tracker/screens/tempscreen.dart';
import 'package:fitness_activity_tracker/screens/loading.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninPage extends StatefulWidget {
  final Function func; // function to switch between signin and signup
  SigninPage({this.func});
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            // resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                RaisedButton.icon(
                  color: Colors.white,
                  onPressed: () {
                    widget.func();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Sign Up",
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            body: ListView(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 0.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello',
                              style: GoogleFonts.montserrat(
                                  fontSize: 70.0, fontWeight: FontWeight.bold)),
                          Text('Fitness',
                              style: GoogleFonts.montserrat(
                                  fontSize: 70.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange)),
                          SizedBox(height: 10.0),
                          Text('One stop solution for a fitter you 🤸🏼‍♂️',
                              style: GoogleFonts.montserrat(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ])),
                Container(
                    padding:
                        EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            decoration: InputDecoration(
                                labelText: 'email',
                                labelStyle:
                                    GoogleFonts.montserrat(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.orangeAccent))),
                            onChanged: (val) => email = val,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            validator: (val) =>
                                val.length < 6 ? 'Min 6 chars required' : null,
                            decoration: InputDecoration(
                                labelText: 'password',
                                labelStyle:
                                    GoogleFonts.montserrat(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.greenAccent))),
                            obscureText: true,
                            onChanged: (val) => password = val,
                          ),
                          SizedBox(height: 10.0),
                          Text(error,
                              style: GoogleFonts.montserrat(
                                  fontSize: 15, color: Colors.red)),
                          SizedBox(height: 30),
                          RaisedButton(
                            color: Colors.orangeAccent,
                            child: Text('Login',
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                try {
                                  final userCred =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  setState(() => loading = false);
                                  if (userCred == null) {
                                    setState(() => error =
                                        'Could not sign in with those credentials');
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TempScreen(
                                              uid: userCred.user.uid)),
                                    );
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    )),
              ],
            ));
  }
}
