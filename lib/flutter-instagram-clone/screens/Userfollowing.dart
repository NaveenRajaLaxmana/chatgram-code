import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/ChatScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart' as widgetclass;

class UserFollowing extends StatefulWidget {
  @override
  _UserFollowingState createState() => _UserFollowingState();
}

class _UserFollowingState extends State<UserFollowing> {

   List<User> followinglist = [];


  getfollowinglist() async{
    QuerySnapshot snapshot = await followingRef.document(widgetclass.currentuser.id).collection('userFollowing').getDocuments();
   
    snapshot.documents.forEach((followdoc) async{
    DocumentSnapshot doc = await userref.document(followdoc.documentID).get();
        User user = User.fromDocument(doc);
        print(user.username);
        followinglist.add(user);
     });
    if(followinglist.length < 1){
      await Future.delayed(Duration(milliseconds: 1000));
    }
    return followinglist;
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              FutureBuilder(
                future: getfollowinglist(),
                builder: (context,snapshots){
                    if(!snapshots.hasData){
                      return CircularProgressIndicator();
                    }
                    List<User> users = snapshots.data;
                    print('the users are :$users');
                    print('the firest user is ${users.length}');
                    
                   return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: users.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatuser: followinglist[index],))),
                                  child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(users[index].photourl),
                        ),
                        title: Text(users[index].username,style: TextStyle(color: Colors.black),),
                      ),
                    );
                  },
                  separatorBuilder: (context,index){
                    return Divider(indent: 5.0,endIndent: 5.0,height: 1.0,color: Colors.grey,);
                  },
                );
                },
                               
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}