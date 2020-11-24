import 'package:fitness_activity_tracker/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_activity_tracker/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_activity_tracker/screens/homescreen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool showSignInPage = true;
  void togglePage() {
    setState(() => showSignInPage = !showSignInPage);
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return showSignInPage
          ? SigninPage(func: togglePage)
          : SignupPage(func: togglePage);
    } else {
      return HomeScreen(uid: FirebaseAuth.instance.currentUser.uid);
    }
  }
}
