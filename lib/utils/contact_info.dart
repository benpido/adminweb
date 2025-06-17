import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Loads contact information for the current admin.
Future<Map<String, String>> loadContactInfo() async {
  final user = FirebaseAuth.instance.currentUser;

  String? name;
  String? phone;
  String? email;

  if (user != null) {
    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get();
    if (adminDoc.exists) {
      name = adminDoc.data()?['name'] as String?;
      phone = adminDoc.data()?['phone'] as String?;
      email = adminDoc.data()?['email'] as String?;
    }
  }

  return {
    'name': name ?? '',
    'phone': phone ?? '',
    'email': email ?? '',
  };
}
