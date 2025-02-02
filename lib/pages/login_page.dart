import 'package:flutter/material.dart';
import 'package:imaginecup/core/locator.dart';
import 'package:imaginecup/core/services/authentication_service.dart';
import 'package:imaginecup/routes/routes.dart';
import 'package:imaginecup/utils/snackbar.dart';
import 'package:imaginecup/widgets/login_button.dart';
import 'package:imaginecup/widgets/login_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final List<Widget> textfields = [
    AuthTextField(title: "Email", obscure: false),
    AuthTextField(title: "Password", obscure: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              spacing: 40,
              children: [
                Text(
                  "LocalEyes",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      SizedBox(width: 20),
                      Text("Login",
                          style: Theme.of(context).textTheme.headlineMedium),
                      SizedBox(height: 50),
                      ...textfields,
                      SizedBox(height: 30),
                      LoginButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.signUp);
                        },
                        text: "Create Account",
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      LoginButton(
                        onPressed: () {
                          _login();
                        },
                        text: "Sign In",
                        foregroundColor: Colors.black,
                      ),
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

  void _login() async {
    final authService = getIt<AuthenticationService>();
    if ((textfields[0] as AuthTextField).text.isNotEmpty &&
        (textfields[1] as AuthTextField).text.isNotEmpty) {
      final result = await authService.signIn(
          (textfields[0] as AuthTextField).text,
          (textfields[1] as AuthTextField).text);
      if (result) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        showCustomSnackBar(context, "Invalid email or password", Colors.white,
            Colors.red, null);
      }
    } else {
      showCustomSnackBar(
          context, "Please fill in all fields", Colors.white, Colors.red, null);
    }
  }
}
