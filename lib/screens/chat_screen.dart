import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats/FoyOKzh3SXyWreStUCVm/messages")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Center(
                child: Text("No data from cloud"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text("This works"),
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
                .collection("chats/FoyOKzh3SXyWreStUCVm/messages")
                .snapshots()
                .listen((event) {
              debugPrint("${event.docs}");
            });
          },
          child: const Icon(Icons.add)),
    );
  }
}
//"chats/FoyOKzh3SXyWreStUCVm/messages"