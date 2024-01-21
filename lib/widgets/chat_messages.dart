import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (context, chatSnap) {
          if (chatSnap.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!chatSnap.hasData || chatSnap.data!.docs.isEmpty) {
            return const Center(
              child: Text("No messages for now..."),
            );
          }

          if (chatSnap.hasError) {
            return const Center(
              child: Text(
                "Something went wrong...",
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          final loadedMsgs = chatSnap.data!.docs;
          return ListView.builder(
              itemCount: loadedMsgs.length,
              itemBuilder: (context, index) {
                return Text(
                  loadedMsgs[index].data()['text'],
                );
              });
        });
  }
}
