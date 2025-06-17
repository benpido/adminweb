import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Loads contact information for the current admin or the global config.
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

  final globalDoc = await FirebaseFirestore.instance
      .collection('config')
      .doc('contact_info')
      .get();

  if ((name == null || name.isEmpty) && globalDoc.exists) {
    name = globalDoc.data()?['name'] as String?;
  }

  if ((phone == null || phone.isEmpty) && globalDoc.exists) {
    phone = globalDoc.data()?['phone'] as String?;
  }

  if ((email == null || email.isEmpty) && globalDoc.exists) {
    email = globalDoc.data()?['email'] as String?;
  }

  return {
    'name': name ?? '',
    'phone': phone ?? '',
    'email': email ?? '',
  };
}
