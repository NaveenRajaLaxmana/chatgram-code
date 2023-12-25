
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/post.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;


class StoryScreen extends StatefulWidget {
  final List<Post> storypost;
  final User currentuser;
  StoryScreen({this.storypost,this.currentuser});
  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {

  int storycount = 0;
  User postowner;

  @override
  void initState() { 
    super.initState();
    waitforsecond();
    getphotourl(widget.storypost[0]);
    
  }
    waitforsecond()async{
    await Future.delayed(Duration(milliseconds: 1000));
  }


  getphotourl(Post post)async{
  DocumentSnapshot doc = await userref.document(post.ownerId).get();
   User user = User.fromDocument(doc);
   setState(() {
     postowner = user;
   });
  }

  getnextstory(){
    if(widget.storypost.length >= storycount){
      setState(() {
        storycount++;
      });
    }
    else{
    Navigator.pop(context);

    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: accentcolor,
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
            children: [
              ListTile(
                leading: Container(
              margin: EdgeInsets.all(8.0),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(postowner.photourl),
                )
              ),
            ),
            title: Text('${widget.storypost[storycount].username}',style: TextStyle(color: backgroundcolor,fontSize: 19.0,fontWeight: FontWeight.w600),),
            subtitle: Text('${timeago.format(widget.storypost[storycount].timestamp.toDate())}',style: TextStyle(color: backgroundcolor,fontSize: 15.0,fontWeight: FontWeight.w200),),
            trailing: IconButton(icon: Icon(Icons.close_outlined,color: Colors.grey,), onPressed: (){
              Navigator.pop(context);
            })
            ),
            SizedBox(height: 10.0,),
              
              SizedBox(height: 10.0,),
              Container(
                height: MediaQuery.of(context).size.height * 0.84,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                 overflow: Overflow.clip,
                  children: [
                    Positioned(
                      height: MediaQuery.of(context).size.height * 0.84,
                width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () => getnextstory(),
                                              child: Container(
                height: MediaQuery.of(context).size.height * 0.84,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
                  image: DecorationImage(image: CachedNetworkImageProvider(widget.storypost[storycount].mediaUrl))
                ),
              ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text(widget.storypost[storycount].description,style: TextStyle(color: primarycolor,fontSize: 19.0,fontWeight: FontWeight.w600),),
                        Spacer(),
                        Text(widget.storypost[storycount].location,style: TextStyle(color: Colors.orange,fontSize: 17.0,fontWeight: FontWeight.w500),)
                      ],
                    ),
                   
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}