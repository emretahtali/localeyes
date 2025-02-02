import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imaginecup/core/locator.dart';
import 'package:imaginecup/core/services/authentication_service.dart';
import 'package:imaginecup/core/services/trip_db_service.dart';
import 'package:imaginecup/features/create_tour/create_tour_screen.dart';
import 'package:imaginecup/models/trip.dart';
import 'package:imaginecup/widgets/tour_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LocalEyes", style: TextTheme.of(context).bodyMedium),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => const CreateTripScreen(),
                );
              },
              icon: Icon(Icons.add)),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              getIt<AuthenticationService>().signOut();
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: getIt<TripDbService>().getTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            final List<Trip> tripsDoc = snapshot.data!.docs
                .map((doc) => Trip.fromJson(doc.data() as Map<String, dynamic>))
                .toList();

            if (tripsDoc.isEmpty) {
              return const Center(child: Text("No trips available!"));
            }
            return ListView.builder(
              itemCount: tripsDoc.length,
              itemBuilder: (context, index) {
                return TourCard(trip: tripsDoc[index]);
              },
            );
          } else {
            return const Center(child: Text("No trips available!"));
          }
        },
      ),
    );
  }
}
