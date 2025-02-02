import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:imaginecup/models/user.dart';

class UserDbService {
  final _firestore = FirebaseFirestore.instance;
  static final userId = auth.FirebaseAuth.instance.currentUser!.uid;

  Future<bool> addUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> updateUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<User?> getUser(String userId) async {
    try {
      final user = await _firestore.collection('users').doc(userId).get();
      return User.fromJson(user.data()!);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
