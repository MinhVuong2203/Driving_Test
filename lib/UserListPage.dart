import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  void addUser() {
    FirebaseFirestore.instance.collection('users').add({
      'name': 'New User',
      'email': 'new@gmail.com',
      'createdAt': Timestamp.now(),
    });
  }

  void updateUser(String id) {
    FirebaseFirestore.instance.collection('users').doc(id).update({
      'name': 'Updated Name',
    });
  }

  void deleteUser(String id) {
    FirebaseFirestore.instance.collection('users').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            onPressed: addUser,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(child: Text("No data"));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var doc = users[index];
              var data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['name'] ?? ''),
                subtitle: Text(data['email'] ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => updateUser(doc.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteUser(doc.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}