import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController editController = TextEditingController();

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      FirebaseFirestore.instance.collection('users');

  Future<void> _addUser() async {
    final text = userController.text;
    final password = passwordController.text;
    if (text.isNotEmpty && password.isNotEmpty) {
      await usersCollection.add({
        'name': text,
        'role': 'subadmin',
        'password': password,
      });
      userController.clear();
      passwordController.clear();
    }
  }

  void _editUser(DocumentSnapshot<Map<String, dynamic>> doc) {
    editController.text = doc['name'] ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar usuario'),
          content: TextField(controller: editController),
          actions: [
            TextButton(
              onPressed: () async {
                await usersCollection
                    .doc(doc.id)
                    .update({'name': editController.text});
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: userController,
                decoration:
                    const InputDecoration(labelText: 'Nuevo usuario'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: passwordController,
                decoration:
                    const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _addUser, child: const Text('Crear')),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Buscar'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: usersCollection.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var docs = snapshot.data!.docs;
              final query = searchController.text.toLowerCase();
              if (query.isNotEmpty) {
                docs = docs
                    .where((d) =>
                        (d['name'] ?? '').toLowerCase().contains(query))
                    .toList();
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final user = doc.data();
                  return ListTile(
                    title: Text(user['name'] ?? ''),
                    subtitle: Text('Rol: ${user['role']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editUser(doc),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteUser(doc.id),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
