import 'package:flutter/material.dart';
import '../utils/contact_info.dart';

class ActivationsPage extends StatefulWidget {
  const ActivationsPage({super.key});

  @override
  State<ActivationsPage> createState() => _ActivationsPageState();
}

class _ActivationsPageState extends State<ActivationsPage> {
  final List<Map<String, String>> activations = [
    {
      'date': '2024-01-01 10:00',
      'user': 'admin@example.com',
      'status': 'éxito'
    },
    {
      'date': '2024-01-02 12:30',
      'user': 'user@example.com',
      'status': 'fallo'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(child: Text('Filtros aquí')),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: activations.length,
            itemBuilder: (context, index) {
              final act = activations[index];
              return ListTile(
                title: Text(act['date']!),
                subtitle: Text('${act['user']} - Estado: ${act['status']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () async {
                    final info = await loadContactInfo();
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Detalle de activación'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Nombre: ${info['name']}'),
                              Text('Teléfono: ${info['phone']}'),
                              Text('Email: ${info['email']}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
