import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (ctx, i) {
            return Container(
              padding: const EdgeInsets.all(8),
              child: const Text("This works"),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection("chats/FoyOKzh3SXyWreStUCVm/messages")
                .snapshots()
                .listen((event) {
              print("${event.docs[0]["text"]}  omo ope");
            });
          },
          child: const Icon(Icons.add)),
    );
  }
}
