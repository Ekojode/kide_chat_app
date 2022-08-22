import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const collectionPath = "chats/FoyOKzh3SXyWreStUCVm/messages";
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kide Chat"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(collectionPath).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("No data from cloud"),
              );
            } else {
              final documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(documents[i]["text"]),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection(collectionPath)
                .add({"text": "This was added by clicking the button"});
          },
          child: const Icon(Icons.add)),
    );
  }
}
//"chats/FoyOKzh3SXyWreStUCVm/messages"