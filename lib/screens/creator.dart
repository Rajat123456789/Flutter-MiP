import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Text("Hello fitness made by the YRS Team ",
                style: GoogleFonts.montserrat(
                    fontSize: 18.0, color: Colors.grey[600])),
          ],
        ));
  }
}
