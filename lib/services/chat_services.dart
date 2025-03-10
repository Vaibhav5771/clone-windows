import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

class ChatService {
  // get instance of firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  /*
  List<Map<String,dynamic>=
  {
  'email': test@gmail.com
  'id': ...
  }
   */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }


  // send message
  Future<void> sendMessage(String receiverId, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverId,
      message: message,
      timestamp: timestamp,
    );

    //construct a chat room Id for 2 users (stored to ensure uniqueness)
    List<String> ids = [currentUserID, receiverId];
    ids.sort(); // sort the ids (this ensures that any 2 have same chatroom ID
    String chatRoomID = ids.join('_');

    // add message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

// get messsages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct chat room ID for 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRooomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRooomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
