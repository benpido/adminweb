import 'dart:html' as html;
import 'package:flutter/material.dart';

class RecordingsPage extends StatelessWidget {
  const RecordingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recordings = [
      'audio1.mp3',
      'audio2.mp3',
    ];

    return ListView.builder(
      itemCount: recordings.length,
      itemBuilder: (context, index) {
        final file = recordings[index];
        return ListTile(
          title: Text(file),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  final audio = html.AudioElement(file)..play();
                },
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  html.AnchorElement(href: file)
                    ..download = file
                    ..click();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
