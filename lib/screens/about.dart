import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './instruction.dart' as instructionPage;
import './creator.dart' as creatorPage;

class Tabs extends StatefulWidget {
  @override
  TabsState createState() => new TabsState();
}

class TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(
            "About",
            style: GoogleFonts.montserrat(),
          ),
          backgroundColor: Color(0xFF039BE3),
          bottom: new TabBar(controller: controller, tabs: <Tab>[
            new Tab(icon: new Icon(Icons.live_help)),
            new Tab(icon: new Icon(Icons.person)),
          ])),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new instructionPage.InstructionPage(),
          new creatorPage.CreatorPage()
        ],
      ),
    );
  }
}
