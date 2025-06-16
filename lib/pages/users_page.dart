import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  final List<Map<String, String>> users = [
    {'name': 'admin@example.com', 'role': 'admin'},
    {'name': 'user@example.com', 'role': 'subadmin'},
  ];

  List<Map<String, String>> get filteredUsers {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) return users;
    return users
        .where((u) => u['name']!.toLowerCase().contains(query))
        .toList();
  }

  void _addUser() {
    final text = userController.text;
    if (text.isNotEmpty) {
      setState(() {
        users.add({'name': text, 'role': 'subadmin'});
        userController.clear();
      });
    }
  }

  void _editUser(int index) {
    editController.text = users[index]['name']!;
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
                  users[index]['name'] = editController.text;
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
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return ListTile(
                title: Text(user['name']!),
                subtitle: Text('Rol: ${user['role']}'),
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
            },
          ),
        ),
      ],
    );
  }
}
