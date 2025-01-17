import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chats_windows/colors.dart';
import 'package:chats_windows/widgets/contacts_list.dart';
import '../widgets/chat_list.dart';


class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  _MobileScreenLayoutState createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String? receiverEmail;
  String? receiverID;
  String? chatRoomID;

  // This function will be called when a contact is selected
  void handleContactSelected(String email, String id, String roomID) {
    setState(() {
      receiverEmail = email;
      receiverID = id;
      chatRoomID = roomID;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          title: SvgPicture.asset(
            'assets/Logo.svg', // Path to your SVG file
            height: 36, // Adjust height as needed
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ],
          bottom: const TabBar(
            indicator: BoxDecoration(
              color: Colors.black, // Black rectangle background
            ),
            indicatorSize: TabBarIndicatorSize.tab, // Ensures the indicator covers the full tab
            labelColor: Colors.white, // Text color for the selected tab
            unselectedLabelColor: Colors.black, // Text color for unselected tabs
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: ContactsList(
                onContactSelected: handleContactSelected, // Pass the callback
              ),
            ),
            if (receiverEmail != null && receiverID != null && chatRoomID != null)
              Expanded(
                flex: 3,
                child: ChatList(
                  receiverEmail: receiverEmail!,
                  receiverID: receiverID!,
                  chatRoomID: chatRoomID!,
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: tabColor,
          child: const Icon(Icons.comment, color: Colors.blue),
        ),
      ),
    );
  }
}
