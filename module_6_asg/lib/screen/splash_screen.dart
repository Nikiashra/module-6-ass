/*import 'package:app_task/screen/login_screen.dart';
import 'package:app_task/screen/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          "Let's Chat",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
              top: _mediaQuery.size.height * 0.10,
              width: _mediaQuery.size.width * 0.5,
              left: _mediaQuery.size.width * 0.25,
              child: Image.asset('assets/images/wechat.png')),
          Positioned(
              bottom: _mediaQuery.size.height * 0.15,
              width: _mediaQuery.size.width,
              child: const Text(" MADE WITH LOVE !!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)))
        ],
      ),
    );
  }
}*/
