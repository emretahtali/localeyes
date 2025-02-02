import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final Timestamp createdAt;
  final List<String> tripIds;

  User(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.email,
      required this.tripIds});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['createdAt'],
      tripIds: json['tripIds'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        "createdAt": createdAt,
        'email': email,
      };

  String get getId => id;
  String get getName => name;
  String get getEmail => email;
  Timestamp get getCreatedAt => createdAt;
}
