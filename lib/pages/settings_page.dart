import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/contact_info.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double recordingDuration = 30;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String loadedName = '';
  String loadedPhone = '';

  @override
  void initState() {
    super.initState();
    _loadContactInfo();
  }

  Future<void> _loadContactInfo() async {
    final info = await loadContactInfo();
    if (!mounted) return;
    setState(() {
      loadedName = info['name'] ?? '';
      loadedPhone = info['phone'] ?? '';
      nameController.text = loadedName;
      phoneController.text = loadedPhone;
    });
  }

  Future<void> _saveContactInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('admins').doc(user.uid).set({
      'name': nameController.text,
      'phone': phoneController.text,
      'email': user.email,
    });

    await FirebaseFirestore.instance.collection('config').doc('contact_info').set({
      'name': nameController.text,
      'phone': phoneController.text,
      'email': user.email,
    });
    await _loadContactInfo();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Información guardada')));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Duración de grabación', style: TextStyle(fontSize: 18)),
        Slider(
          min: 30,
          max: 60,
          divisions: 3,
          value: recordingDuration,
          label: recordingDuration.round().toString(),
          onChanged: (v) => setState(() => recordingDuration = v),
        ),
        Text('Seleccionada: ${recordingDuration.round()}s'),
        const SizedBox(height: 20),
        const Text('Clasificación de alertas', style: TextStyle(fontSize: 18)),
        const Text('Personalización pendiente'),
        const SizedBox(height: 20),
        const Text('Parámetros de detección', style: TextStyle(fontSize: 18)),
        const Text('Ajustes de umbrales y sensibilidad pendiente'),
        const SizedBox(height: 20),
        const Text('Contacto del administrador', style: TextStyle(fontSize: 18)),
        Text('Cuenta: ${FirebaseAuth.instance.currentUser?.email ?? ''}'),
        Text('Nombre guardado: $loadedName'),
        Text('Teléfono guardado: $loadedPhone'),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: 'Teléfono'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _saveContactInfo,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
