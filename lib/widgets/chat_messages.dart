import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
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
              reverse: true,
              padding: const EdgeInsets.only(bottom: 40, left: 15, right: 15),
              itemCount: loadedMsgs.length,
              itemBuilder: (context, index) {
                final chatMessage = loadedMsgs[index].data();
                final nextchatMessage = index + 1 < loadedMsgs.length
                    ? loadedMsgs[index + 1].data()
                    : null;
                final currentMsgUser = chatMessage['userId'];
                final nextMsgUser =
                    nextchatMessage != null ? nextchatMessage['userId'] : null;
                final sameNextUser = currentMsgUser == nextMsgUser;
                if (sameNextUser) {
                  return MessageBubble.next(
                    isMe: authenticatedUser!.uid == currentMsgUser,
                    message: chatMessage['text'],
                  );
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['userImage'],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authenticatedUser!.uid == currentMsgUser);
                }
              });
        });
  }
}
