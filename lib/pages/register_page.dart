import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:imaginecup/core/locator.dart';
import 'package:imaginecup/core/services/authentication_service.dart';
import 'package:imaginecup/core/services/user_db_service.dart';
import 'package:imaginecup/models/user.dart';
import 'package:imaginecup/routes/routes.dart';
import 'package:imaginecup/utils/snackbar.dart';
import 'package:imaginecup/widgets/login_button.dart';
import 'package:imaginecup/widgets/login_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<Widget> textfields = [
    AuthTextField(title: "Name", obscure: false),
    AuthTextField(title: "Email", obscure: false),
    AuthTextField(title: "Password", obscure: true),
    AuthTextField(title: "Confirm Pasword", obscure: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 236, 248, 3),
              const Color.fromARGB(255, 255, 153, 0)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back_ios,
                                  color: Colors.black)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("Sign Up",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium),
                      SizedBox(height: 20),
                      ...textfields,
                      LoginButton(
                        onPressed: () {
                          _register();
                        },
                        text: "Sign Up",
                        foregroundColor: Colors.black,
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    final authService = getIt<AuthenticationService>();
    if ((textfields[2] as AuthTextField).text ==
        (textfields[2] as AuthTextField).text) {
      final result = await authService.signUp(
          (textfields[1] as AuthTextField).text,
          (textfields[2] as AuthTextField).text);
      if (result != null && result.user != null) {
        final id = result.user!.uid;
        await getIt<UserDbService>().addUser(User(
            id: id,
            name: (textfields[0] as AuthTextField).text,
            createdAt: Timestamp.fromDate(DateTime.now()),
            email: (textfields[1] as AuthTextField).text,
            tripIds: []));
        showCustomSnackBar(context, "Account created successfully",
            Colors.white, Colors.blueAccent, Icon(Icons.info));
        Navigator.pop(context);
      } else {
        showCustomSnackBar(context, "Make sure to give valid mail",
            Colors.white, Colors.redAccent, Icon(Icons.error));
      }
    } else {
      showCustomSnackBar(context, "Passwords do not match", Colors.white,
          Colors.redAccent, Icon(Icons.error));
    }
  }
}
