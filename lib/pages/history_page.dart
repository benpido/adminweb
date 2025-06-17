import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../utils/contact_info.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {
        'date': '2024-01-01 10:00',
        'user': 'admin@example.com',
        'status': 'éxito',
        'file': 'audio1.mp3',
      },
      {
        'date': '2024-01-02 12:30',
        'user': 'user@example.com',
        'status': 'fallo',
        'file': 'audio2.mp3',
      },
    ];

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
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final file = item['file'];
              return ListTile(
                title: Text(item['date']!),
                subtitle:
                    Text('${item['user']} - Estado: ${item['status']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed:
                          file != null ? () => html.AudioElement(file).play() : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: file != null
                          ? () {
                              html.AnchorElement(href: file)
                                ..download = file
                                ..click();
                            }
                          : null,
                    ),
                    IconButton(
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
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

