import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

class SingleCommentScreen extends StatelessWidget {
  final String username;
  final String comment;
  final String url;
  final Timestamp timestamp;

  SingleCommentScreen({
    this.username,
    this.comment,
    this.url,
    this.timestamp
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: accentcolor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: backgroundcolor,
      ),
      body: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(url),
              radius: 36.0,
            ),
            title: Text(username),
            subtitle: Text(comment,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: accentcolor,),overflow: TextOverflow.visible,),
            trailing: Text(timeago.format(timestamp.toDate())),
          ),
      )
    );
  }
}