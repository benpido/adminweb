import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              _MetricCard(title: 'Usuarios registrados', value: '120'),
              _MetricCard(title: 'Alertas reales', value: '8'),
              _MetricCard(title: 'Alertas falsas', value: '3'),
              _MetricCard(title: 'Alertas accidentales', value: '5'),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Gráficos de alertas', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Container(
            height: 200,
            color: Colors.black12,
            alignment: Alignment.center,
            child: const Text('Gráficos aquí'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _MetricCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 200,
        height: 80,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(fontSize: 24)),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
