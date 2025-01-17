import 'package:chats_windows/auth/login_or_register.dart';
import 'package:chats_windows/screens/web_screen_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Assume you have the necessary information (e.g., receiverEmail, receiverID, chatRoomID)
            String receiverEmail = "example@example.com"; // Replace with actual logic to fetch receiver email
            String receiverID = "receiver123"; // Replace with actual logic to fetch receiver ID
            String chatRoomID = "chatRoom123"; // Replace with actual logic to fetch chat room ID

            return WebScreenLayout(
              receiverEmail: receiverEmail,
              receiverID: receiverID,
              chatRoomID: chatRoomID,
              preferenceData: {
                'startPage': 1,
                'endPage': 10,
                'copies': 1,
                'isColor': true,
                'paperSize': 1,
                'sides': 1,
              },
              fileUrl: 'https://example.com/sample.pdf',
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
