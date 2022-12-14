import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../chats/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("There are no chats yet, Start chatting now!"),
            );
          } else {
            final documents = snapshot.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: documents.length,
              itemBuilder: (ctx, i) {
                return MessageBubble(
                  key: ValueKey(documents[i].id),
                  message: documents[i]["text"],
                  userName: documents[i]["userName"],
                  isMe: documents[i]["userId"] ==
                      FirebaseAuth.instance.currentUser!.uid,
                  userImage: documents[i]["userImage"],
                );
              },
            );
          }
        }
      },
    );
  }
}
