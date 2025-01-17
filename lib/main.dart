import 'package:chats_windows/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chats_windows/colors.dart';
import 'package:chats_windows/responsive/responsive_layout.dart';
import 'package:chats_windows/screens/mobile_screen_layout.dart';
import 'package:chats_windows/screens/web_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA7nZviOP94RskqTYabMiU00eOujYRhlzE",
      authDomain: "chats-4d7a9.firebaseapp.com",
      projectId: "chats-4d7a9",
      storageBucket: "chats-4d7a9.appspot.com", // ✅ Corrected storage bucket URL
      messagingSenderId: "279757687099",
      appId: "1:279757687099:web:c629dbc796382bf8044f1e",
      measurementId: "G-DYK5N6RVW7",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const AuthGate(),
    );
  }
}
