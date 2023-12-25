import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/post.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/ChatScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SinglePostScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UploadScreen.dart';

import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart' as widgetclass;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DateTime timestamp = DateTime.now();

class UserProfileScreen extends StatefulWidget {
  final User user;
  UserProfileScreen({this.user});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  List<Post> userposts;
  int postCount;
  bool isFollowing = false;
  int followersCount = 0;
  int followingCount = 0;

  @override
  void initState() { 
    super.initState();
    getprofileposts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
    waitforsecond();
  }
  waitforsecond()async{
    await Future.delayed(Duration(milliseconds: 1000));
  }

  checkIfFollowing() async{
    DocumentSnapshot doc = await followersRef.document(widget.user.id).collection('userFollowers').document(widgetclass.currentuser.id).get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async{
    QuerySnapshot snapshot = await followersRef.document(widget.user.id).collection('userFollowers').getDocuments();
    setState(() {
      followersCount = snapshot.documents.length;
    });
  }

  getFollowing() async{
    QuerySnapshot snapshot = await followingRef.document(widget.user.id).collection('userFollowing').getDocuments();
     setState(() {
      followingCount = snapshot.documents.length;
    });
  }

  getprofileposts() async{
    QuerySnapshot postssnapshot = await postsref.document(widget.user.id).collection("userPosts").orderBy("timestamp",descending: true).getDocuments();
    setState(() {
      postCount = postssnapshot.documents.length;
      userposts =  postssnapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }
  
handleUnFollowers(){
 setState(() {
   isFollowing = false;
 });
 //remove follower
  followersRef.document(widget.user.id).collection('userFollowers').document(widgetclass.currentuser.id).get().then((doc) =>{
    if(doc.exists){
      doc.reference.delete()
    }
  } );

  //remove following
  followingRef.document(widgetclass.currentuser.id).collection('userFollowing').document(widget.user.id).get().then((doc) => {
     if(doc.exists){
      doc.reference.delete()
    }
  });
  //delete activity feed item for that user
  activityFeedRef.document(widget.user.id).collection('feedItems').document(widgetclass.currentuser.id).get().then((doc) => {
     if(doc.exists){
      doc.reference.delete()
    }
  });

  timelineRef.document(widgetclass.currentuser.id).collection('userFollowing').document(widget.user.id).get().then((doc) =>{
    if(doc.exists){
      doc.reference.delete()
    }
  } );
}

handleFollowers() async{
 setState(() {
   isFollowing = true;
 });
 //make auth user follower of other user and update their profile
  followersRef.document(widget.user.id).collection('userFollowers').document(widgetclass.currentuser.id).setData({

  });

  //put that user in your following list
  followingRef.document(widgetclass.currentuser.id).collection('userFollowing').document(widget.user.id).setData({

  });
  //add activity feed item for that user to notify about follower
  activityFeedRef.document(widget.user.id).collection('feedItems').document(widgetclass.currentuser.id).setData({
    "type": "Follow",
    "ownerId": widget.user.id,
    "username": widgetclass.currentuser.username,
    "userId": widgetclass.currentuser.id,
    "userProfileImg": widgetclass.currentuser.photourl,
    "timestamp": timestamp,
  });
  // List<Post> timelinepost;
 QuerySnapshot postssnapshot = await postsref.document(widget.user.id).collection("userPosts").orderBy("timestamp",descending: true).getDocuments();
  postssnapshot.documents.forEach((doc) {
    if(doc.exists){
      timelineRef.document(widgetclass.currentuser.id).collection('userFollowing').document(widget.user.id).collection('userPosts').document(doc.documentID).setData({
        "postId": doc['postId'],
      "ownerId": doc['ownerId'],
      "username": doc['username'],
      "location": doc['location'],
      "description": doc['description'],
      "mediaUrl": doc['mediaUrl'],
      "likes": doc['likes'],
      "timestamp": doc['timestamp']
      });
    }
   });

  timelineRef.document(widgetclass.currentuser.id).collection('userFollowing').document(widget.user.id).setData({});
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('UserProfile',style: TextStyle(color: widgetclass.accentcolor,),),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.more_horiz,color: widgetclass.accentcolor), onPressed: (){})
          ],
          leading: IconButton(icon: Icon(Icons.keyboard_arrow_left,color: widgetclass.accentcolor,), onPressed: (){
            Navigator.pop(context);
          }),
          backgroundColor: widgetclass.backgroundcolor,
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
                  color: widgetclass.backgroundcolor,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1.0),
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 25.0,
                      spreadRadius: 5.0
                    )
                  ]
                ),
                child: Column(
                  
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        height: 90,
                        width: 90,
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              height: 90,
                              width: 90,
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2.8,style: BorderStyle.solid,color: Colors.red),
                                  borderRadius: BorderRadius.circular(45.0)
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6.0,
                              left: 6.0,
                              height: 78,
                              width: 78,
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(widget.user.photourl),
                                radius: 30.0,
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                    Text('${widget.user.username}',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w800,color: widgetclass.accentcolor),),
                    SizedBox(height: 5.0,),
                    Text('${widget.user.bio}',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w600,color: widgetclass.accentcolor),textAlign: TextAlign.center,),
                    SizedBox(height: 15.0,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('$postCount',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700,color: widgetclass.accentcolor),),
                              Text('Posts',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400,color: widgetclass.accentcolor.withOpacity(0.5)),textAlign: TextAlign.center,),
                            ],
                          ),
                          SizedBox(height: 30.0,width: 2.0,child: Container(color: Colors.grey,),),
                          Column(
                            children: [
                              Text('$followersCount',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700,color: widgetclass.accentcolor),),
                              Text('Followers',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400,color: widgetclass.accentcolor.withOpacity(0.5))),
                            ],
                          ),
                          SizedBox(height: 30.0,width: 2.0,child: Container(color: Colors.grey,),),
                          Column(
                            children: [
                              Text('$followingCount',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w700,color: widgetclass.accentcolor),),
                              Text('Following',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w400,color: widgetclass.accentcolor.withOpacity(0.5))),
                            ],
                          ),
                          
                        ],
                      ),
                    
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                            child: Text(isFollowing ? 'Unfollow': 'Follow',style: TextStyle(color: Colors.white),),
                          ),
                          onPressed: (){
                            if(isFollowing){
                              handleUnFollowers();
                            }
                            else if(!isFollowing){
                              handleFollowers();
                            }
                          },
                          color: Colors.deepOrange.withOpacity(0.6),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                         elevation: 5.0,
                        ),
                        SizedBox(width: 15.0,),
                        InkWell(
                          onTap: (){ 
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatuser: widget.user,)));
                           },
                                                  child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.withOpacity(0.7)
                            ),
                            padding: EdgeInsets.only(left:5.0),
                            child: Icon(Icons.send,color: widgetclass.accentcolor,),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0,right: 15.0,left: 15.0),
                child: buildGridView()
                ),
              
              SizedBox(height: 15.0,)
            ],
          ),
        ),
         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: widgetclass.accentcolor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen(currentuser: currentuser,)));
              },
              tooltip: 'Post',
              child: Icon(Icons.add),
            ),
        bottomNavigationBar: widgetclass.customnavigation(context)
      ),
    );
  }

  GridView buildGridView() {
    return GridView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.0,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0
              ),
              itemCount: userposts.length,
              itemBuilder: (BuildContext context,int index){ 
                return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePostScreen(userpost: userposts[index],))),  
                                  child: Hero(
                                    tag: userposts[index].postid,
                                                                      child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(image: CachedNetworkImageProvider(userposts[index].mediaUrl),fit: BoxFit.cover)
                    ),
                   
                  ),
                                  ),
                );
              },
          );
  }
}