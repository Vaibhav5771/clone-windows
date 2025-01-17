import 'package:chats_windows/widgets/preferences_preview.dart';
import 'package:flutter/material.dart';
import 'package:chats_windows/colors.dart';
import 'package:chats_windows/widgets/chat_list.dart';
import 'package:chats_windows/widgets/contacts_list.dart';
import 'package:chats_windows/widgets/web_chat_appbar.dart';
import 'package:chats_windows/widgets/web_profile_bar.dart';
import 'package:chats_windows/widgets/web_search_bar.dart';

import '../auth/auth_service.dart';
import '../services/chat_services.dart';

class WebScreenLayout extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String chatRoomID;
  final Map<String, dynamic> preferenceData;
  final String fileUrl;

  const WebScreenLayout({
    Key? key,
    required this.receiverEmail,
    required this.receiverID,
    required this.chatRoomID,
    required this.preferenceData,
    required this.fileUrl,
  }) : super(key: key);

  @override
  _WebScreenLayoutState createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  bool isContactSelected = false;
  String receiverEmail = '';
  String receiverID = '';
  String chatRoomID = '';

  @override
  Widget build(BuildContext context) {
    final ChatService _chatService = ChatService();
    final AuthService _authService = AuthService();
    final currentUser = _authService.getCurrentUser();  // Fetch current user

    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    final String currentUserEmail = currentUser.email ?? 'Unknown';

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Panel
          Expanded(
            flex: 1, // 25% of the screen
            child: Column(
              children: [
                const WebProfileBar(),
                Expanded(
                  child: ContactsList(
                    onContactSelected: (
                        newReceiverEmail, newReceiverID, newChatRoomID
                        ) {
                      setState(() {
                        isContactSelected = true;
                        // Update local state variables instead of widget properties
                        receiverEmail = newReceiverEmail;
                        receiverID = newReceiverID;
                        chatRoomID = newChatRoomID;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.black,
          ),

          // Middle Panel (Web Screen)
          Container(
            width: isContactSelected
                ? MediaQuery.of(context).size.width * 0.75 // 50% of the screen if contact is selected
                : MediaQuery.of(context).size.width * 0.75, // 75% otherwise
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: isContactSelected
                      ? ChatList(
                    receiverEmail: receiverEmail,  // Use local state variables
                    receiverID: receiverID,
                    chatRoomID: chatRoomID,
                  )
                      : Center(
                    child: Text('Select a user to view messages'),
                  ),
                ),
              ],
            ),
          ),

          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.black,
          ),
          // Right Panel (only appear if contact is selected
        ],
      ),
    );
  }
}