import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/comment.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/post.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SingleCommentScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UploadScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart' as widgetclass;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';


class SinglePostScreen extends StatefulWidget {
  final Post userpost;
  SinglePostScreen({this.userpost});
  @override
  _SinglePostScreenState createState() => _SinglePostScreenState(userpost: this.userpost,likeCount: this.userpost.getLikesCount(this.userpost.likes),likes: this.userpost.likes);
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  final Post userpost;
   int likeCount;
   Map likes;
  _SinglePostScreenState({this.userpost,this.likeCount,this.likes});
  int totalcommentCount;
 
  bool isLiked; 
  bool showHeart = false;

  getpostcount() async{
    int count = 0;
QuerySnapshot totalsnap = await commentsRef.document(userpost.postid).collection('comments').getDocuments();
    totalsnap.documents.forEach((doc) {
      if(doc.exists){
        count++;
      }
     });
     print('count value is : $count');
     setState(() {
       totalcommentCount = count;
     });
      print('total comment count is : $totalcommentCount');
  }
  @override
  void initState() { 
    super.initState();
    setState((){
      isLiked = userpost.likes[widgetclass.currentuser.id] == true;
       
    });
    getpostcount();
   
  }

 
  TextEditingController _commentcontroller = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  handleLikePost(){
    
    if(widgetclass.currentuser.id == userpost.ownerId){
                              return _scaffoldkey.currentState.showSnackBar(
                                SnackBar(content: Text('Its Your Post'),)
                              );
                            }

    if(isLiked){
      postsref.document(userpost.ownerId).collection("userPosts").document(userpost.postid).updateData({
        'likes.${widgetclass.currentuser.id}':false
      });
      removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[widgetclass.currentuser.id] = false;
      });
      
    }else if(!isLiked){
      postsref.document(userpost.ownerId).collection("userPosts").document(userpost.postid).updateData({
        'likes.${widgetclass.currentuser.id}': true
      });
      addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[widgetclass.currentuser.id] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500),(){
        setState(() {
          showHeart =false;
        });
      });
    }


  }

  addLikeToActivityFeed(){
    activityFeedRef.document(userpost.ownerId).collection("feedItems").document(userpost.postid).setData({
      "type": "like",
      "username": widgetclass.currentuser.username,
      "userId": widgetclass.currentuser.id,
      "userProfileImg":widgetclass.currentuser.photourl,
      "postId": userpost.postid,
      "mediaUrl": userpost.mediaUrl,
      "timestamp":timestamp
    });
  }

  removeLikeFromActivityFeed(){
    activityFeedRef.document(userpost.ownerId).collection("feedItems").document(userpost.postid).get().then((doc) =>{
      if(doc.exists){
        doc.reference.delete()
      }
    });
  }

  addComments(){
    commentsRef.document(userpost.postid).collection('comments').add({
      "username":widgetclass.currentuser.username,
      "comment": _commentcontroller.text,
      "timestamp": timestamp,
      "avatarUrl":widgetclass.currentuser.photourl,
      "userId": widgetclass.currentuser.id
    });
    activityFeedRef.document(userpost.ownerId).collection('feedItems').add({
      "type": "comment",
      "commentData": _commentcontroller.text,
      "username": widgetclass.currentuser.username,
      "userId": widgetclass.currentuser.id,
      "userProfileImg":widgetclass.currentuser.photourl,
      "postId": userpost.postid,
      "mediaUrl": userpost.mediaUrl,
      "timestamp":timestamp
    });
    _commentcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '${userpost.username}',
          style: TextStyle(
            color: widgetclass.accentcolor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.more_horiz, color: widgetclass.accentcolor),
              onPressed: () {})
        ],
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
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: Hero(
                tag: userpost.postid,
                              child: GestureDetector(
                                                     onDoubleTap: () => handleLikePost(),        
                                                              child: Stack(
                                                                                                                              
                                                                                                                              alignment: Alignment.center,children: [Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      
                      image: DecorationImage(
                          fit: BoxFit.cover, image: CachedNetworkImageProvider(userpost.mediaUrl))),
                ),
               showHeart ? Animator(
                  duration: Duration(milliseconds: 300),
                  tween: Tween(begin: 0.8,end: 1.4),
                  curve: Curves.elasticOut,
                  cycles: 0,
                  builder: (context,anim,_) => Transform.scale(
                    scale: anim.value,
                    child: Icon(Icons.favorite,size: 80,color: Colors.red,),
                    ),
                ) : Text("")
                                                                                                                              ]),
                              ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 12.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red ,
                          ),
                          onPressed: () {
                            
                           handleLikePost();
                          
                          
                          }),
                      Text(
                        '${likeCount.isNegative ? 0 : likeCount}',
                        style: TextStyle(
                            color: widgetclass.accentcolor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.chat_bubble_outline_rounded),
                          onPressed: () {}),
                      Text(
                        '$totalcommentCount',
                        style: TextStyle(
                            color: widgetclass.accentcolor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: IconButton(icon: Icon(Icons.share), onPressed: () {}),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 25.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Text(
                    '${userpost.username} : ',
                    style: TextStyle(
                        color: widgetclass.accentcolor,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${userpost.description}',
                    style: TextStyle(
                      color: widgetclass.accentcolor,
                      fontSize: 17.0,
                    ),
                  ),
                  
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text(
                '${timeago.format(userpost.timestamp.toDate())}',
                style: TextStyle(
                    color: Colors.grey.withOpacity(0.8), fontSize: 14.0),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Divider(
              color: Colors.grey,
              height: 1.0,
              indent: 22.0,
              endIndent: 22.0,
            ),
            SizedBox(height: 15.0,),
            StreamBuilder(
              stream: commentsRef.document(userpost.postid).collection('comments').orderBy('timestamp',descending: false).snapshots(),
              builder: (context,snapshots){
                if(!snapshots.hasData){
                  return CircularProgressIndicator();
                }
                List<Comment> comments = [];
                if(snapshots.data.documents == null){
                  return Text('no comment for post');
                }
                snapshots.data.documents.forEach((doc){
                  comments.add(Comment.fromDocument(doc));
                });
               
                return listsofcomments(context,comments.length,comments);
              },
            ),
            
            SizedBox(height: 8.0,),
           widgetclass.currentuser.id == userpost.ownerId ? Text('') :Padding(
              padding:  EdgeInsets.only(left: 18.0,right: 8.0),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: TextFormField(
                      controller: _commentcontroller,
                      keyboardType: TextInputType.text,
style: TextStyle(fontSize: 15.0,),
textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                       
                        fillColor: Colors.black.withOpacity(0.1),
                        filled: true,
                        hintText: '   Enter Your Comment  ',

                        prefixIcon: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(widgetclass.currentuser.photourl),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.transparent,style: BorderStyle.none)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.transparent,style: BorderStyle.none)
                        )
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send,size: 26.0,), onPressed: () {
                    if(_commentcontroller.text.isEmpty){
                      return;
                    }
                    addComments();
                  })
                ],
              ),
            ),
            
            SizedBox(height: 10.0,),
          ],
        ),
      ),
    ));
  }

  listsofcomments(context,commentslength,List<Comment> comments) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: commentslength,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCommentScreen(username: comments[index].username,comment: comments[index].comment,url: comments[index].avatarUrl,timestamp: comments[index].timestamp,))),
                  child: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(comments[index].avatarUrl),
              radius: 36.0,
            ),
            title: Text('@${comments[index].username}'),
            subtitle: Text('${comments[index].comment}',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: widgetclass.accentcolor,),overflow: TextOverflow.ellipsis,),
            trailing: Text(timeago.format(comments[index].timestamp.toDate())),
          ),
        );
      },
      separatorBuilder: (context,index){
        return SizedBox(height: 15.0,);
      },
    );
  }
}
