import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  final String message;
  final String ownerId;
  final String username;

  Chat({
    this.ownerId,
    this.username,
    this.message
  });

  factory Chat.fromDocument(DocumentSnapshot doc){
    return Chat(
      ownerId: doc['ownerId'],
      username: doc['username'],
      message: doc['chat']
    );
  }
}