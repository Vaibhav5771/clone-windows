import 'package:chats_windows/colors.dart';
import 'package:chats_windows/widgets/preferences_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../services/chat_services.dart';
import 'chat_bubble.dart';
import 'login_field.dart';


class ChatList extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  final String chatRoomID;

  ChatList({Key? key, required this.receiverEmail, required this.receiverID, required this.chatRoomID}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  bool _isPreferencesVisible = false;
  Map<String, dynamic> _preferencesData = {};
  String _fileUrl = '';

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverID,
        _messageController.text,
      );
      _messageController.clear();
    }
  }


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: webAppBarColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/user_placeholder.png'),
              radius: 20,
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 10),
            Text(widget.receiverEmail),
          ],
        ),
      ),
      body: Row(
        children: [
          // Left side: Message List
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: _buildMessageList(),
                ),
                _buildUserInput(),
              ],
            ),
          ),
          // Right side: Editable Preferences Screen (conditionally rendered)
          Expanded(
            flex: 1,
            child: _isPreferencesVisible
                ? EditablePreferencesScreen(
              preferencesData: _preferencesData,
              fileUrl: _fileUrl,
            )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, widget.receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet. Start the conversation!"));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    bool isPreference = data['messageType'] == 'preferences';

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    if (isPreference) {
      // If the message is a preference, update the state to show preferences screen
      return Container(
        alignment: alignment,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: GestureDetector(
          onTap: () {
            Map<String, dynamic> preferencesData = data['preferences'] ?? {};
            String fileUrl = data['fileUrl'] ?? 'No file URL available';

            // Update the state to show the preferences screen
            setState(() {
              _preferencesData = Map.from(preferencesData); // Ensures a new map is created
              _fileUrl = fileUrl;
              _isPreferencesVisible = true;
            });

          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              width: 80,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  Positioned(
                    bottom: 5,
                    child: Text(
                      "Preference",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Regular message bubble
      return Container(
        alignment: alignment,
        child: ChatBubble(
          message: data["message"],
          isCurrentUser: isCurrentUser,
        ),
      );
    }
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
      child: Row(
        children: [
          Expanded(
            child: LoginField(
              hintText: "Type a Message",
              obscureText: false,
              controller: _messageController,
            ),
          ),
          SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.send_sharp),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                // Handle file button press
              },
              icon: Icon(Icons.file_present_sharp),
            ),
          ),
        ],
      ),
    );
  }
}
