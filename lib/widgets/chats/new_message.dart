import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  var _enteredMessage = "";

  void _sendMessage() async {
    if (_enteredMessage == "") {
      return;
    }
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add(
      {
        "text": _enteredMessage,
        "createdAt": Timestamp.now(),
        "userId": user.uid,
        "userName": userData.data()!["username"],
        "userImage": userData.data()!["userimage"]
      },
    );
    _messageController.clear();
    _enteredMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: "Send a message..."),
              onChanged: (value) {
                setState(
                  () {
                    _enteredMessage = value;
                  },
                );
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty
                ? null
                : () {
                    _sendMessage();
                  },
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
