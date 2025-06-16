import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'pages/dashboard_page.dart';
import 'pages/users_page.dart';
import 'pages/activations_page.dart';
import 'pages/recordings_page.dart';
import 'pages/settings_page.dart';

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
      // 2FA authentication removed
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
  int index = 0;

  static final _pages = [
    const DashboardPage(),
    const UsersPage(),
    const ActivationsPage(),
    const RecordingsPage(),
    const SettingsPage(),
  ];

  static const _titles = [
    'Dashboard',
    'Usuarios',
    'Activaciones',
    'Grabaciones',
    'Configuración',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 700;
        final user = FirebaseAuth.instance.currentUser;
        final content = _pages[index];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Institución XYZ'),
            actions: [
              if (user != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(child: Text(user.email ?? '')),
                ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar sesión',
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
          drawer: useRail
              ? null
              : Drawer(
                  child: ListView(
                    children: [
                      for (var i = 0; i < _pages.length; i++)
                        ListTile(
                          leading: _iconFor(i),
                          selected: index == i,
                          title: Text(_titles[i]),
                          onTap: () {
                            setState(() => index = i);
                            Navigator.pop(context);
                          },
                        ),
                    ],
                  ),
                ),
          body: Row(
            children: [
              if (useRail)
                NavigationRail(
                  selectedIndex: index,
                  onDestinationSelected: (i) => setState(() => index = i),
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (var i = 0; i < _pages.length; i++)
                      NavigationRailDestination(
                        icon: _iconFor(i),
                        label: Text(_titles[i]),
                      ),
                  ],
                ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }

  static Icon _iconFor(int i) {
    switch (i) {
      case 0:
        return const Icon(Icons.dashboard);
      case 1:
        return const Icon(Icons.people);
      case 2:
        return const Icon(Icons.history);
      case 3:
        return const Icon(Icons.library_music);
      default:
        return const Icon(Icons.settings);
    }
  }
}
