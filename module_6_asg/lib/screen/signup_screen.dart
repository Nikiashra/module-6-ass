import 'package:app_task/screen/complete_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/uihelper_model.dart';
import '../model/user_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmpassword.isEmpty) {
      print("Please fill all the fields!!");
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else if (password != confirmpassword) {
      print("Passwords do not match!");
      UIHelper.showAlertDialog(context, "Password Mismatch",
          "The passwords you entered do not match!");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;

    UIHelper.showLoadingDialog(context, "Creating new account...");

    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error occurred", e.message.toString());
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      UserModel newUser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print("New User Created!");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompleteProfile(
                    userModel: newUser, firebaseUser: credential!.user!)));
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CompleteProfile(
                    userModel: newUser, firebaseUser: credential!.user!)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          "Let's Chat",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned image at the top
            Positioned(
              top: mediaQuery.size.height * 0.05,
              left: mediaQuery.size.width * 0.25,
              width: mediaQuery.size.width * 0.5,
              child: Image.asset('assets/images/wechat.png'),
            ),
            const SizedBox(height: 20),
            // The main content of the signup page
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: confirmpasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                        ),
                      ),
                      const SizedBox(height: 20),
                      CupertinoButton(
                        onPressed: () {
                          checkValues();
                        },
                        color: Colors.green,
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an account?",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Log In",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
