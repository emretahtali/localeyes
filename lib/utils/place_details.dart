import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imaginecup/core/locator.dart';
import 'package:imaginecup/core/services/azure_service.dart';

// Future<List<Map<String, dynamic>>> getPlaceDetails(
//     List<String> places, String tripId) async {
//   try {
//     //check firestore first , if not found, call azure
//     final placeDetailsFirestore = await getPlaceDetailsFirestore(tripId);

//     if (placeDetailsFirestore == null) {
//       final placeDetailsAzure = List<Map<String, String>>.from(
//           (await getIt<AzureService>().getPlaceDetails(places))["content"]);

//       await addPlaceDetails(placeDetailsAzure, tripId);
//       return placeDetailsAzure;
//     } else {
//       return placeDetailsFirestore;
//     }
//   } catch (e) {
//     print(e);
//     return [];
//   }
// }

Future<void> addPlaceDetails(
    List<Map<String, dynamic>> details, String tripId) async {
  try {
    await FirebaseFirestore.instance
        .collection(
            "users/${FirebaseAuth.instance.currentUser!.uid}/trip/$tripId/places")
        .add({"places": details});
  } catch (e) {
    print(e);
  }
}

Future<List<Map<String, String>>?> getPlaceDetailsFirestore(
    String tripId) async {
  try {
    final placesDoc = (await FirebaseFirestore.instance
            .collection(
                "users/${FirebaseAuth.instance.currentUser!.uid}/trip/$tripId/places")
            .get())
        .docs;
    if (placesDoc.isNotEmpty) {
      return List<Map<String, String>>.from(placesDoc.first["places"]);
    }
  } catch (e) {
    print(e);
  }
  return null;
}
