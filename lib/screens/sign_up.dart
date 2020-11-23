import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_activity_tracker/screens/loading.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  final Function func;
  SignupPage({this.func});
  @override
  _SignupPagePageState createState() => _SignupPagePageState();
}

class _SignupPagePageState extends State<SignupPage> {
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
            appBar: AppBar(
              backgroundColor: Colors.orange,
              actions: [
                RaisedButton.icon(
                  color: Colors.orange,
                  onPressed: () {
                    widget.func();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Sign In",
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            backgroundColor: Colors.orange[50],
            body: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                  child: Text('Sign Up',
                      style: GoogleFonts.montserrat(
                          fontSize: 70.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                  child: Text('to be fit!!!',
                      style: GoogleFonts.montserrat(
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 0.0),
                  child: Text('exercise exercise exercise, repeat 🤸🏼‍♂️',
                      style: GoogleFonts.montserrat(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.green)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 30.0, 0.0, 0.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          decoration: InputDecoration(
                              labelText: 'email',
                              labelStyle: GoogleFonts.montserrat(
                                  fontSize: 20.0, color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.orangeAccent),
                              )),
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        TextFormField(
                          validator: (val) =>
                              val.length < 6 ? 'Min 6 chars required' : null,
                          decoration: InputDecoration(
                              labelText: 'password',
                              labelStyle: GoogleFonts.montserrat(
                                  fontSize: 20.0, color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.greenAccent))),
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 30.0),
                        RaisedButton(
                            color: Colors.orangeAccent,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                try {
                                  final userCred = await _auth
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  print(userCred.user.email);
                                  setState(() => loading = false);
                                  if (userCred == null) {
                                    setState(() => error = 'Could not Sign Up');
                                  } else {
                                    widget.func();
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            child: Text('Sign Up',
                                style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 10.0),
                        Text(
                          error,
                          style: GoogleFonts.montserrat(
                              fontSize: 20.0, color: Colors.red),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }
}
