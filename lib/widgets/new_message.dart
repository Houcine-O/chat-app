import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) return;

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 5,
        bottom: 20,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(label: Text("Send a message...")),
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            autocorrect: true,
          ),
        ),
        IconButton(
            onPressed: _sendMessage,
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(
              size: 26,
              Icons.send,
            ))
      ]),
    );
  }
}
