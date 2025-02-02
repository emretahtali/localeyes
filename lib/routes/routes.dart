import 'package:flutter/material.dart';
import 'package:imaginecup/features/create_tour/create_tour_screen.dart';
import 'package:imaginecup/features/home/home_page.dart';
import 'package:imaginecup/features/tour/tour_page.dart';
import 'package:imaginecup/pages/login_page.dart';
import 'package:imaginecup/pages/register_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String trip = '/trip';
  static const String createTrip = '/createTrip';
}

Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.home: (context) => const HomePage(),
  AppRoutes.login: (context) => const LoginPage(),
  AppRoutes.signUp: (context) => const RegisterPage(),
  AppRoutes.trip: (context) => const TourPage(),
  AppRoutes.createTrip: (context) => const CreateTripScreen(),
};
