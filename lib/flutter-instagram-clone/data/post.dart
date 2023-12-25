import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String postid;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final Map likes;
  final Timestamp timestamp;

  Post({
    this.postid,
    this.ownerId,
    this.username,
    this.location,
    this.description,
    this.mediaUrl,
    this.likes,
    this.timestamp
  });

  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(
      postid: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
      timestamp: doc['timestamp']
    );
  }

  int getLikesCount(likes){
    if(likes == null){
      return 0;
    }
    int count = 0;
    likes.values.forEach((val){
      if(val == true){
        count+=1;
      }
    });
    return count;
  }
}