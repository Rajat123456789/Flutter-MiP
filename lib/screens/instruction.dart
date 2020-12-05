import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class InstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text("Hello fit people ",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600])),
            SizedBox(height: 30),
            Text(
                "Now that you've downloaded the app, we promise you that this app is all you'd need to keep yourself in the best shape!! ",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600])),
            SizedBox(height: 20),
            Text("Select your workout of choice by clicking on the dumbbell.",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600])),
            Text("Select how long you want to do that workout.",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600])),
            SizedBox(height: 30),
            Text("Hit the start button.",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600])),
            Text(
                "It'd automatically get saved in your Activity once you finish all the activities in your list.",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600])),
            SizedBox(height: 30),
            Text(
                "You can check your completed activities in the View Activity Tab",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600])),
            SizedBox(height: 40),
            Text("All the best for a fitter you.",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600]))
          ],
        ));
  }
}
