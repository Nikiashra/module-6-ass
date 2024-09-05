import 'package:app_task/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'model/firebase_helper.dart';
import 'model/user_model.dart';
import 'screen/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());

  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    //LoggedIn
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      runApp(
          MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    } else {
      runApp(MyApp());
    }
  } else {
    //not Logged In
    runApp(MyApp());
  }
}

//Not Logged In
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Chat app",
        debugShowCheckedModeBanner: false,
        home: LoginPage());
  }
}

//Already Logged In
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Chat App",
        debugShowCheckedModeBanner: false,
        home: HomePage(userModel: userModel, firebaseUser: firebaseUser));
  }
}
