import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imaginecup/core/locator.dart';
import 'package:imaginecup/firebase_options.dart';
import 'package:imaginecup/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String getInitialRoute() {
    if (FirebaseAuth.instance.currentUser != null) {
      return AppRoutes.home;
    } else {
      return AppRoutes.login;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LocalEyes',
      theme: ThemeData(
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.nunitoSans(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 40),
          headlineMedium: GoogleFonts.nunitoSans(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 35),
          titleMedium: GoogleFonts.nunitoSans(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 25),
          bodyMedium: GoogleFonts.inter(
              color: Colors.grey[850],
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
        useMaterial3: true,
      ),
      initialRoute: getInitialRoute(),
      routes: appRoutes,
      //home: const LoginPage(),
    );
  }
}
