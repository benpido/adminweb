import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  runApp(const AdminWebApp());
}

class AdminWebApp extends StatelessWidget {
  const AdminWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const AdminPanel();
          }
          return const LoginPage();
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? error;

  Future<void> _login() async {
    setState(() => error = null);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => error = 'Cuenta no encontrada');
      } else if (e.code == 'wrong-password') {
        setState(() => error = 'Contraseña incorrecta');
      } else {
        setState(() => error = 'Error al iniciar sesión');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _login, child: const Text('Entrar')),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  final List<String> users = [];
  double recordingDuration = 30;

  final List<String> activations = [
    'Activación 1 - 2024-01-01',
    'Activación 2 - 2024-01-02',
  ];

  void _addUser() {
    final text = userController.text;
    if (text.isNotEmpty) {
      setState(() {
        users.add(text);
        userController.clear();
      });
    }
  }

  void _editUser(int index) {
    editController.text = users[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar usuario'),
          content: TextField(controller: editController),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  users[index] = editController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Usuarios', style: TextStyle(fontSize: 20)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: userController,
                    decoration: const InputDecoration(labelText: 'Nuevo usuario'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addUser, child: const Text('Crear')),
              ],
            ),
            const SizedBox(height: 10),
            ...List.generate(users.length, (index) {
              return ListTile(
                title: Text(users[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editUser(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteUser(index),
                    ),
                  ],
                ),
              );
            }),
            const Divider(),
            const Text('Duración de grabación (segundos)', style: TextStyle(fontSize: 20)),
            Slider(
              min: 30,
              max: 60,
              divisions: 3,
              value: recordingDuration,
              label: recordingDuration.round().toString(),
              onChanged: (value) {
                setState(() {
                  recordingDuration = value;
                });
              },
            ),
            Text('Duración seleccionada: ${recordingDuration.round()}s'),
            const Divider(),
            const Text('Historial de activaciones', style: TextStyle(fontSize: 20)),
            ...activations.map(
              (a) => ListTile(
                title: Text(a),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
