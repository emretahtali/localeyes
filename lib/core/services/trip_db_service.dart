import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imaginecup/core/data/remote/place_detail_card_dto.dart';
import 'package:imaginecup/models/trip.dart';

class TripDbService {
  final firestore = FirebaseFirestore.instance;
  final tripPath = "users/${FirebaseAuth.instance.currentUser!.uid}/trips";
  Future<bool> addTrip(Trip trip) async {
    try {
      await firestore.collection(tripPath).doc(trip.id).set(trip.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateTrip(Trip trip) async {
    try {
      await firestore.collection(tripPath).doc(trip.id).update(trip.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteTrip(String tripId) async {
    try {
      await firestore.collection(tripPath).doc(tripId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Trip?> getTrip(String tripId) async {
    try {
      final trip = await firestore.collection(tripPath).doc(tripId).get();
      return Trip.fromJson(trip.data()!);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> getTrips() {
    try {
      return firestore.collection(tripPath).snapshots();
    } catch (e) {
      print(e);
      return Stream.empty();
    }
  }

  //returns null if not found
  Future<List<PlaceDetailCardDto>?> getPlaceDetailsFirestore(
      String tripId) async {
    List<PlaceDetailCardDto> details = [];
    try {
      final placesDocs = (await firestore
              .collection(
                  "users/${FirebaseAuth.instance.currentUser!.uid}/trips/$tripId/tripDetails")
              .get())
          .docs;
      if (placesDocs.isNotEmpty) {
        for (var placeDoc in placesDocs) {
          final detaildto = PlaceDetailCardDto.fromJson(placeDoc.data());
          details.add(detaildto);
        }
      }

      return details.isEmpty ? null : details;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> addPlaceDetails(
      List<PlaceDetailCardDto> details, String tripId) async {
    try {
      for (var detail in details) {
        await firestore
            .collection(
                "users/${FirebaseAuth.instance.currentUser!.uid}/trips/$tripId/tripDetails")
            .add(detail.toJson());
      }
    } catch (e) {
      print(e);
    }
  }
}
