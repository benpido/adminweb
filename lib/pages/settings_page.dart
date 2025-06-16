import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double recordingDuration = 30;

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
      ],
    );
  }
}
