import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/chat.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart' as widgetclass;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

DateTime timestamp = DateTime.now();

class ChatScreen extends StatefulWidget {
  final User chatuser;
  ChatScreen({this.chatuser});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController _chatcontroller = TextEditingController();

String chatid = Uuid().v4();


  
  

  setchats() async{
    if(_chatcontroller.text.isEmpty){
      return null;
    }
    
     chatsRef
        .document(widgetclass.currentuser.id)
        .collection("userChats")
        .document(widget.chatuser.id)
        .collection('Chats')
        .document(chatid)
        .setData({
          "ownerId": widgetclass.currentuser.id,
          "username":widgetclass.currentuser.username,
          "chat": _chatcontroller.text,
          "timestamp": timestamp
        });
        chatsRef
        .document(widget.chatuser.id)
        .collection("userChats")
        .document(widgetclass.currentuser.id)
        .collection('Chats')
        .document(chatid)
        .setData({
          "ownerId": widgetclass.currentuser.id,
          "username": widgetclass.currentuser.username,
          "chat": _chatcontroller.text,
          "timestamp": timestamp
        });
        setState(() {
          chatid = Uuid().v4();
          
        });
        
        _chatcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widgetclass.backgroundcolor,
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget.chatuser.photourl),
                ),
                title: Text(widget.chatuser.username,style: TextStyle(color: widgetclass.accentcolor,fontSize: 20.0,fontWeight: FontWeight.w600),),
                trailing: IconButton(icon: Icon(Icons.more_horiz,color: widgetclass.accentcolor,), onPressed: (){}),
              ),
              SizedBox(height: 15.0,),
    StreamBuilder(
                    stream: chatsRef
        .document(widgetclass.currentuser.id)
        .collection("userChats")
        .document(widget.chatuser.id)
        .collection('Chats')
        .orderBy("timestamp",descending: false)    
        .snapshots(),
                    builder: (context,snapshots){
                      if(!snapshots.hasData){
                        return Text('No chats');
                      }
                     List<Chat> chats = [];
                      snapshots.data.documents.forEach((doc){
                        chats.add(Chat.fromDocument(doc));
                      });
                      
                       return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: chats.length,
                itemBuilder: (BuildContext context,int index){
                 



                  if(chats[index].ownerId == widgetclass.currentuser.id){
                    return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
                          child: Text(chats[index].message,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),bottomLeft: Radius.circular(15.0),bottomRight: Radius.circular(15.0)),
                            color: Colors.red 
                          ),
                        ),
                  );
                  }

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10.0),
                          child: Text(chats[index].message,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),bottomLeft: Radius.circular(15.0),bottomRight: Radius.circular(15.0)),
                            color: Colors.blue 
                          ),
                        ),
                  );
                },
                separatorBuilder: (BuildContext context,int index)
                {
                  return SizedBox(height: 10.0,);
                },
              );
                 

                    },
                  ),


              
              
            ],
          ),
        ),
        bottomSheet: TextFormField(
          controller: _chatcontroller,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: widgetclass.accentcolor),
                        validator: (val) => val.isNotEmpty ? null : 'enter text',
                      decoration: InputDecoration(   
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(1),style: BorderStyle.solid,width: 1.0),
                          gapPadding: 10.0
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(1),style: BorderStyle.solid,width: 1.0),
                          gapPadding: 10.0
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        prefixIcon: CircleAvatar(backgroundImage: CachedNetworkImageProvider(widgetclass.currentuser.photourl),),
                        hintText: 'Message',
                        suffixIcon: IconButton(icon: Icon(Icons.send,color: widgetclass.accentcolor,), onPressed: (){
                          if(_chatcontroller.text.isNotEmpty){
                            setchats();
                          }
                        })
                      ),
                    ),
      ),
    );
  }
}