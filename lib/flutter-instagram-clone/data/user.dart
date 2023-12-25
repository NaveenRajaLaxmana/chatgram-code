import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String id;
  final String username;
  final String email;
  final String photourl;
  final String bio;

  User({this.id,this.username,this.email,this.photourl,this.bio});

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      id: doc['uid'],
      username: doc['username'],
      photourl: doc['photourl'],
      email: doc['email'],
      bio: doc['bio'],
    );
  }
}