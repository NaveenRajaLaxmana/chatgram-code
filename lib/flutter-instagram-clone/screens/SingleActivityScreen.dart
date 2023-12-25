import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/activityfeeditem.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/post.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SinglePostScreen.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/UserProfileScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart' as widgetclass;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;


class SingleActivityScreen extends StatefulWidget {
  final ActivityFeedItem feeditem;

  SingleActivityScreen({this.feeditem});

  @override
  _SingleActivityScreenState createState() => _SingleActivityScreenState();
}

class _SingleActivityScreenState extends State<SingleActivityScreen> {
  Post post;
  User user;
  @override
  void initState() { 
    super.initState();
    getpostofpostid();
    getuserid();
  }

getpostofpostid() async{
DocumentSnapshot doc = await postsref.document(widgetclass.currentuser.id).collection("userPosts").document(widget.feeditem.postId).get();
  if(doc.exists){
    post = Post.fromDocument(doc);
  }
}
getuserid() async{
DocumentSnapshot doc = await userref.document(widget.feeditem.userId).get();
  if(doc.exists){
    user = User.fromDocument(doc);
  }
}

  @override
  Widget build(BuildContext context) {
     String textforlikecomment;
     if(widget.feeditem.type == "like"){
    textforlikecomment = "${widget.feeditem.username} Liked your Post";

  }else if(widget.feeditem.type == "comment"){
    textforlikecomment = "${widget.feeditem.username} commented ${widget.feeditem.commentData}";
  }else if(widget.feeditem.type == "Follow"){
    textforlikecomment = "${widget.feeditem.username} started Folowing You";

  }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: widgetclass.accentcolor,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: widgetclass.backgroundcolor,
      ),
      body: ListTile(
              leading: Stack(children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.red,width: 2.0,style: BorderStyle.solid)
                  ),
                ),
                Positioned(
                  height: 52,
                  width: 62,
                  top: 3.0,
                  left: 4.0,
                  
                            child: InkWell(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(user: user,))),
                                                          child: Container(
                    height: 52,
                    width: 62,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: CachedNetworkImageProvider(widget.feeditem.userProfileImg),fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20.0),
                    )
                  ),
                            ),
                ),
              ],),
              title: Text('${widget.feeditem.username}',style: TextStyle(color: widgetclass.accentcolor,fontSize: 19.0,fontWeight: FontWeight.w600),),
              subtitle: Column(
                children: [
                  Text(textforlikecomment,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: widgetclass.accentcolor,),overflow: TextOverflow.visible,),
                  Text(timeago.format(widget.feeditem.timestamp.toDate()),style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w300,color: widgetclass.accentcolor,),overflow: TextOverflow.visible,),
                ],
              ),
              trailing: widget.feeditem.mediaUrl != null ?InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePostScreen(userpost: post,))),
                              child: Hero(
                                tag: widget.feeditem.postId,
                                                              child: Container(
                  height: 80,
                  width: 80,
                  child: Image(image: CachedNetworkImageProvider(widget.feeditem.mediaUrl),fit: BoxFit.cover,height: 90,),
                ),
                              ),
              ): Text(''),
              ),
      )
    );
  }
}