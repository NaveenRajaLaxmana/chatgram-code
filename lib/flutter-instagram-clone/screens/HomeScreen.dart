import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/post.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/ChatScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SinglePostScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/StoryScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/StoryUploadScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UploadScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UserProfileScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/Userfollowing.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart' as widgetclass;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:timeago/timeago.dart' as timeago;



class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  

  int currentnavigation = 0;



  gettimelistposts()async{
    List<Post> timelineposts = [];
    
  await timelineRef.document(widgetclass.currentuser.id).collection('userFollowing').getDocuments().then((doc) =>{
     doc.documents.forEach((element) async{ 
      await element.reference.collection('userPosts').getDocuments().then((value) => {
        value.documents.forEach((postdoc) {
           
           timelineposts.add(Post.fromDocument(postdoc));
          
          })
       } );
     })
   } );


  
   if(timelineposts.length < 1){
    await Future.delayed(Duration(milliseconds: 1000));
   }
   
   return timelineposts;
  }

getmystory() async{
  List<Post> storiessnap = [];
 await storyRef
        .document(widgetclass.currentuser.id)
        .collection("userPosts")
        .getDocuments().then((alldocs) =>{
          
            alldocs.documents.forEach((doc) {
      
        storiessnap.add(Post.fromDocument(doc));
    })
        } );

    
  
    return storiessnap;
  
}

getothersstory()async{
    List<Post> otherspost = [];
    print("hello");
  await timelineRef.document(widgetclass.currentuser.id).collection('userFollowing').getDocuments().then((doc) =>{
     doc.documents.forEach((element) async{ 
    
     

      await storyRef
        .document(element.documentID)
        .collection("userPosts")
        .getDocuments().then((alldocs) =>{
          
         
          
            alldocs.documents.forEach((doc) {
              
      
        otherspost.add(Post.fromDocument(doc));
    })
        } );
        
        

     })
   });


  
   if(otherspost.length < 1){
    await Future.delayed(Duration(milliseconds: 2000));
   }
   
    
   return otherspost;

  }

  @override
  Widget build(BuildContext context) {
    final accentcolor = Theme.of(context).accentColor;
    final backgroundcolor = Theme.of(context).backgroundColor;


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chatgram',style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic,color: accentcolor),),
        actions: [
          IconButton(icon: Icon(Icons.camera_alt_outlined,color: accentcolor,), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen(currentuser: widgetclass.currentuser,)));
          }),
          IconButton(icon: Icon(Icons.send,color: accentcolor,), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserFollowing()));

          })
        ],
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
            children: <Widget>[
              story(accentcolor),
              FutureBuilder(
                future: gettimelistposts(),
                builder: (context,snapshots){
                  if(!snapshots.hasData){
                    return CircularProgressIndicator();
                  }
                  
                  
                  return listposts(backgroundcolor,snapshots.data);
                },
              ),
              SizedBox(height: 25.0,)
            ],
        ),
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: accentcolor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen(currentuser: currentuser,)));
              },
              tooltip: 'Post',
              child: Icon(Icons.add),
            ),
      bottomNavigationBar: widgetclass.customnavigation(context)
      );
  }

bottomnavigation(BuildContext context){
  return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),
           color: widgetclass.accentcolor,
        ),
        height: 60.0,
        width: double.infinity,
        
        child: CustomPaint(
          painter: widgetclass.CustombottomNavigationpainter(),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: -26.0,
                left: 170.0,
                height: 50.0,
                width: 50.0,
                child: FlatButton(
                  padding: EdgeInsets.only(right: -2.0),
                  color: widgetclass.accentcolor,
                  onPressed: (){},
                   child: Icon(Icons.add,color: widgetclass.backgroundcolor,textDirection: TextDirection.ltr,),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(25.0),
                     side: BorderSide(color: Colors.yellow,width: 2.0),
                    
                   ),
                   ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                height: 60.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.home,color: currentnavigation == 0 ? widgetclass.primarycolor: widgetclass.backgroundcolor,size: 23.0,), onPressed: (){ 
                      widgetclass.myfunction(0); }),
                    
                    IconButton(icon: Icon(Icons.search,color: currentnavigation == 1 ? widgetclass.primarycolor: widgetclass.backgroundcolor,size: 23.0,), onPressed: (){ widgetclass.myfunction(1);  }),
                    
                    IconButton(icon: Icon(Icons.favorite_border,color: currentnavigation == 2 ? widgetclass.primarycolor: widgetclass.backgroundcolor,size: 23.0,), onPressed: (){ widgetclass.myfunction(2); }),
                  
                    IconButton(icon: Icon(Icons.person,color: currentnavigation == 3 ? widgetclass.primarycolor: widgetclass.backgroundcolor,size: 23.0,), onPressed: (){ widgetclass.myfunction(3); })
                  ],
                ),
              )
            ],
          ),
        ),
      );

}


  ListView listposts(Color textcolor,List<Post> listpost){
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: listpost.length,
        itemBuilder: (BuildContext context,int index){
    return FutureBuilder(
      future: getphotourl(listpost[index]),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
       User user = snapshot.data;
       return homeposts(context,listpost[index],user, textcolor);
      },
    );
   
    
        },
        separatorBuilder: (BuildContext context,int index){
    return SizedBox(height: 20.0,);
        }
      );
  }
  getphotourl(Post post)async{
  DocumentSnapshot doc = await userref.document(post.ownerId).get();
   User user = User.fromDocument(doc);
   print('----------------------$user---------------------------------------------');
   return user;
  }
  homeposts(BuildContext context,Post post,User user,Color color){
    var widthofpostcontainer = MediaQuery.of(context).size.width * 0.92; 
    
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
      height: 290.0,
      width: widthofpostcontainer ,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(1.0, 1.0),
            color: Colors.black.withOpacity(0.4),
            blurRadius: 25.0,
            spreadRadius: 3.0
          ),
          BoxShadow(
            offset: Offset(-1.0, -1.0),
            color: Colors.black87,
            blurRadius: 2.0,
            spreadRadius: 1.0
          )
        ]
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePostScreen(userpost: post,))),
                          child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                            child: Image(
                  height: 290,
                  width: widthofpostcontainer,
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(post.mediaUrl),
                ),
              ),
            ),
          ),
          Positioned(
            height: 70.0,
            width: widthofpostcontainer,
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(user: user,))),
                          child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.photourl) 
                ),
               
                tileColor: Colors.transparent,
                title: Text(post.username,style: TextStyle(fontSize: 22.0,color: color,fontWeight: FontWeight.w500),),
                subtitle: Text(post.location ?? '',style: TextStyle(fontSize: 14.0,color: color,fontWeight: FontWeight.w300),),
                trailing: IconButton(icon: Icon(Icons.more_horiz_rounded),iconSize: 19.0,color: color, onPressed: (){})
              ),
            )
          ),
          Positioned(
            bottom: -25.0,
            left: 18.0,
            height: 50.0,
            width: widthofpostcontainer * 0.9,
            child: Container(
              height: 50.0,
              width: widthofpostcontainer * 0.8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow:  [
          BoxShadow(
            offset: Offset(1.0, 2.0),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            spreadRadius: 5.0
          )
        ],
              ),
              child:FlatButton.icon(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatuser: user,)));
              }, icon: Icon(Icons.message,size: 22.0,), label: Text('')),
              
            ),
          )
        ],
      ),
    );
  }

  Container story(Color accentcolor) {
    return Container(
              height: 90.0,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  FutureBuilder(
                    future: getmystory(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return list(accentcolor,snapshot.data);
                      }
                     return list(accentcolor,snapshot.data);
                    },
                  ),
                 
                  FutureBuilder(
                    future: getothersstory(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData){
                        return LinearProgressIndicator();
                      }
                     
                   
                     
                     
                    //  othersvalidstory.where((post) => post.timestamp.seconds < 86400);
                      return storiesbuilder(accentcolor,snapshot.data);
                     
                    },
                  ),
                  
                ],
                shrinkWrap: false,
              )
            );
  }

  ListView storiesbuilder(Color accentcolor,List<Post> othersstory) {
    return ListView.builder(
      shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: othersstory.length,
                itemBuilder: (BuildContext context,int index){
                   return FutureBuilder(
      future: getphotourl(othersstory[index]),
      builder: (context,snapshot){
        if(!snapshot.hasData){
         return LinearProgressIndicator();
        }
       User user = snapshot.data;
        
        return otherstorybuilder(othersstory, context,user, index, accentcolor);
       
      },
    );

                 
                },
              );
  }

  separatestories(List<List<Post>> othersstory,context,User user,int index,accentcolor){
    othersstory.forEach((story) {
          otherstorybuilder(story, context,user, index, accentcolor);
        });
  }

  Container otherstorybuilder(List<Post> othersstory, BuildContext context,User postowner, int index, Color accentcolor) {
    return Container(
                  height: 64.0,
                  width: 64.0,
                  margin: EdgeInsets.symmetric(vertical: 6.0,horizontal: 8.0),
                  child: GestureDetector(
                    onTap: (){
                      if(othersstory.length >= 1){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(storypost: othersstory,currentuser: widgetclass.currentuser,)));
                        }    
                    },
                    onDoubleTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StoryUploadScreen(currentuser: widgetclass.currentuser,)));

                    },
                                          child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                        overflow: Overflow.clip,
                        children: [
                          Container(
                            height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(width: 2.0,color: Colors.blue,style: BorderStyle.solid)
                        ),
                          ),
                          Positioned(
                 top: 3.0,
                 left: 3.0,
                        child: Container(
                        height: 53.0,
                        width: 53.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(postowner.photourl),
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                        ),
                        
                ),
                          ),
                          
                        ],
                ),
                Text(postowner.username,style: TextStyle(color: accentcolor,fontSize: 12.0,letterSpacing: 1.0),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)
                      ],
                    ),
                  ),
                );
  }

  list(Color color,List<Post> mystory){
      return Container(
                    height: 74.0,
                    width: 74.0,
                    margin: EdgeInsets.symmetric(vertical: 6.0,horizontal: 8.0),
                    child: GestureDetector(
                      onTap: (){
                          if(mystory.length >= 1){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StoryScreen(storypost: mystory,currentuser: widgetclass.currentuser,)));
                          }      
                      },
                      onLongPress: (){ 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StoryUploadScreen(currentuser: widgetclass.currentuser,)));
                       },
                                            child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                          overflow: Overflow.clip,
                          children: [
                            Container(
                              height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(width: 2.0,color: Colors.blue,style: BorderStyle.solid)
                          ),
                            ),
                            Positioned(
                            left: 3.0,
                           bottom: 3.0,
                          child: Container(
                          height: 53.0,
                          width: 53.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                          ),
                  child: Icon(Icons.add_a_photo),        
                  ),
                            ),
                            
                          ],
                  ),
                  Text('Me',style: TextStyle(color: color,fontSize: 12.0,letterSpacing: 1.0),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    ),
                  );
    }
}