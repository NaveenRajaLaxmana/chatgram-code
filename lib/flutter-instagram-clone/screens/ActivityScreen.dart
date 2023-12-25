

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/activityfeeditem.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/users.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SingleActivityScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UploadScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UserProfileScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart' as widgetclass;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  List<String> followinglist = [];

  @override
  void initState() { 
    super.initState();
    getfollowinglist();
  }

  getfollowinglist() async{
    QuerySnapshot snapshot = await followingRef.document(widgetclass.currentuser.id).collection('userFollowing').getDocuments();
    setState(() {
      followinglist = snapshot.documents.map((doc) => doc.documentID).toList();
    });
    
  }

  getActivityFeed()async{
    QuerySnapshot snapshot = await activityFeedRef.document(widgetclass.currentuser.id).collection('feedItems').orderBy('timestamp',descending: true).limit(50).getDocuments();
    List<ActivityFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
     });
    return feedItems;
  }
  
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widgetclass.backgroundcolor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: widgetclass.backgroundcolor,
          title: Text('Actvity',style: TextStyle(color: widgetclass.accentcolor,fontSize: 21.0,fontWeight: FontWeight.w600),),
          actions: [
            IconButton(icon: Icon(Icons.more_horiz), onPressed: (){}),
          ],
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.0,horizontal: 5.0),
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: userref.orderBy('timestamp',descending: true).limit(15).snapshots(),
                  builder: (context,snapshots){
                    if(!snapshots.hasData){
                      return CircularProgressIndicator();
                    }
                    List<User> suggestedusers = [];
                    snapshots.data.documents.forEach((doc){
                      
                        User user = User.fromDocument(doc);
                        
                        final bool isauthuser = widgetclass.currentuser.id == user.id;
                        final bool isfollowingUser = followinglist.contains(user.id);
                        if(isauthuser){
                          return;
                        }else if(isfollowingUser){
                          return;
                        }
                        suggestedusers.add(user);
                    });
                    
                   return suggestionbuilder(context,suggestedusers);
                  },
                ),
              ),
              SizedBox(height: 30.0,),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child: Text('Notifications',style: TextStyle(color: widgetclass.accentcolor,fontSize: 22.0,fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 15.0,),
              FutureBuilder(
                future: getActivityFeed(),
              
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  List<ActivityFeedItem> feeditems = snapshot.data;
                  return activities(context,feeditems);
                },
              ),
             
              SizedBox(height: 10.0,)
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
        bottomNavigationBar: widgetclass.customnavigation(context),
      ),
    );
  }

activities(context,List<ActivityFeedItem> feeditems){
  return ListView.separated(
    itemCount: feeditems.length,
    scrollDirection: Axis.vertical,
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (context,index){
   
  String textforlikecomment;
  if(feeditems[index].type == "like"){
    textforlikecomment = "${feeditems[index].username} Liked your Post";

  }else if(feeditems[index].type == "comment"){
    textforlikecomment = "${feeditems[index].username} commented ${feeditems[index].commentData}";
  }else if(feeditems[index].type == "Follow"){
    textforlikecomment = "${feeditems[index].username} started Folowing You";

  }

      return Padding(
        padding:  EdgeInsets.only(left: 15.0,right: 15.0),
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleActivityScreen(feeditem: feeditems[index],))),
                  child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
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
            child: ListTile(
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
                  
                            child: Container(
                    height: 52,
                    width: 62,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: CachedNetworkImageProvider(feeditems[index].userProfileImg),fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20.0),
                    )
                  ),
                ),
              ],),
              title: Text('${feeditems[index].username}',style: TextStyle(color: widgetclass.accentcolor,fontSize: 19.0,fontWeight: FontWeight.w600),),
              subtitle: Text(textforlikecomment,style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: widgetclass.accentcolor,),overflow: TextOverflow.ellipsis,),
              trailing: feeditems[index].mediaUrl != null ? Container(
                height: 80,
                width: 80,
                child: Image(image: CachedNetworkImageProvider(feeditems[index].mediaUrl),fit: BoxFit.cover,height: 90,),
              ) : Text(''),
              ),
          ),
        ),
      );
    },
    separatorBuilder: (context,index){
      return SizedBox(height: 20.0,);
    },
  );
}


  suggestionbuilder(context,List<User> suggesteduser){
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: suggesteduser.length,
      itemBuilder: (BuildContext context,int index){
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(user: suggesteduser[index],)));
          },
                  child: Card(
              margin: EdgeInsets.only(left: 5.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              elevation: 6.0,
              shadowColor: Colors.black.withOpacity(0.4),
              child: Container(
                  width: 90,
                  
                  child: Column(
                    
                    children: [
          SizedBox(height: 15.0,),
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(suggesteduser[index].photourl),
          ),
          SizedBox(height: 5.0,),
          Text('${suggesteduser[index].username}',style: TextStyle(color: widgetclass.accentcolor,fontWeight: FontWeight.w500,fontSize: 18.0),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
          SizedBox(height: 5.0,),
          Text('${suggesteduser[index].bio}',style: TextStyle(color: widgetclass.accentcolor,fontWeight: FontWeight.w300,fontSize: 13.0),textAlign: TextAlign.center,)
                    ],
                  ),
                ),
            ),
        );
      },
      separatorBuilder: (BuildContext context,int index){
        return SizedBox(width: 18.0,height: 10.0,);
      },
    );
  }
}