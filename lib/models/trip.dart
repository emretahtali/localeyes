import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  String id;
  String name;
  String fromWhere;
  String toWhere;
  Timestamp startDate;
  Timestamp endDate;
  int? peopleCount;
  String description;
  List<Map<String, dynamic>> route;
  String ownerId;
  Map<String, dynamic> generatedTour;
  Trip({
    required this.id,
    required this.name,
    required this.description,
    required this.route,
    required this.ownerId,
    required this.fromWhere,
    required this.toWhere,
    required this.startDate,
    required this.endDate,
    required this.peopleCount,
    required this.generatedTour,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      route: (json['route'] as List)
          .map((item) => {
                "name": item["name"],
                "latlng": LatLng(item['latitude'], item['longitude'])
              })
          .toList(),
      ownerId: json['ownerId'],
      fromWhere: json['fromWhere'],
      toWhere: json['toWhere'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      peopleCount: json['peopleCount'],
      generatedTour: json['generatedTour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'route': route
          .map((item) => {
                "name": item["name"],
                'latitude': item["latlng"].latitude,
                'longitude': item["latlng"].longitude
              })
          .toList(),
      'ownerId': ownerId,
      'fromWhere': fromWhere,
      'toWhere': toWhere,
      'startDate': startDate,
      'endDate': endDate,
      'peopleCount': peopleCount,
      'generatedTour': generatedTour,
    };
  }

  List<String> getPlaces() {
    int days = endDate.toDate().difference(startDate.toDate()).inDays;
    List<String> places = [];
    for (int i = 1; i < days + 1; i++) {
      //day1, day2, day3, ...
      Map<String, dynamic>? tripOfDay = generatedTour["day$i"];
      if (tripOfDay == null) {
        break;
      }
      for (Map<String, dynamic> place in tripOfDay["places"]) {
        places.add(place["name"]);
      }
    }
    return places;
  }
}
