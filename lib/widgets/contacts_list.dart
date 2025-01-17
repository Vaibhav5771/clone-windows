import 'package:chats_windows/auth/auth_service.dart';
import 'package:chats_windows/services/chat_services.dart';
import 'package:flutter/material.dart';
import '../widgets/user_tile.dart';
import 'chat_list.dart';

class ContactsList extends StatefulWidget {
  final Function(String receiverEmail, String receiverID, String chatRoomID) onContactSelected;

  ContactsList({super.key, required this.onContactSelected});

  // Chat & Auth Service Instances
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  State<ContactsList> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Column( // Column used to hold multiple children
      children: [
        Expanded(
          child: _buildUserList(), // Expands to fill available space
        ),
      ],
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: widget._chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        }
        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Ensure data is properly handled
        final usersData = snapshot.data as List<Map<String, dynamic>>;

        return ListView.builder(
          itemCount: usersData.length,
          itemBuilder: (context, index) {
            final userData = usersData[index];
            return _buildUserListItem(userData, context);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != widget._authService.getCurrentUser()!.email) {
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/user_placeholder.png'), // Add your image here
          radius: 20,
          backgroundColor: Colors.white,
        ),
        title: Text(userData["email"]),
        textColor: Colors.black,
        onTap: () {
          String currentUserID = widget._authService.getCurrentUser()!.uid;
          String receiverID = userData["uid"];

          // Generate chatRoomID
          List<String> ids = [currentUserID, receiverID]..sort();
          String chatRoomID = ids.join('_');

          // Pass data back to the parent widget to update the chat view
          widget.onContactSelected(userData["email"], receiverID, chatRoomID);
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
