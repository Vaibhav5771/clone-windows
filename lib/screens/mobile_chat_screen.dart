import 'package:flutter/material.dart';
import 'package:chats_windows/colors.dart';
import 'package:chats_windows/widgets/chat_list.dart';

import '../info.dart';

class MobileChatScreen extends StatelessWidget {

  final String receiverEmail;
  final String receiverID;
  final String chatRoomID;

  const MobileChatScreen({Key? key, required this.receiverEmail, required this.receiverID, required this.chatRoomID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          info[0]['name'].toString(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        children: [Expanded(child: ChatList(
          receiverEmail: receiverEmail,
          receiverID: receiverID,
          chatRoomID: chatRoomID,
        )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white, // Container background color
              borderRadius: BorderRadius.circular(0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.camera_alt_sharp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10), // Spacing between icons
                        Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.attach_money,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
          ),
        ],
        //ChatList
        //TextInput
      ),
    );
  }
}
