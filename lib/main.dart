import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solveathon/login/login_method.dart';
import 'package:solveathon/login/login_ui.dart';
import 'package:solveathon/notification/notification_service.dart';
import 'package:solveathon/screens/student_nav.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().init();

  User? user = FirebaseAuth.instance.currentUser;

  Widget homeScreen;
  if (user == null) {
    homeScreen = LoginPageUI(
      logic: LoginPageLogic(),
    );
  } else {
    homeScreen = const StudentNav();
  }

  runApp(MyApp(homeScreen: homeScreen));
}

class MyApp extends StatelessWidget {
  final Widget homeScreen;

  const MyApp({super.key, required this.homeScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: homeScreen,
    );
  }
}
