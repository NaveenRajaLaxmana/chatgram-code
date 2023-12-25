
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/ActivityScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/ChatScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/CurrentUserProfileScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/EditCurrentuserScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/HomeScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SearchScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SinglePostScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/StoryScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UploadScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UserProfileScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
 final User currentuser;
  Home({this.currentuser});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() { 
    super.initState();
    pageController = PageController(initialPage: 0);
    initcontoller(pageController);
    getcurrentuserfromwidget(currentuser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: PageView(
children: <Widget>[
  HomeScreen(),
  SearchScreen(),
  ActivityScreen(),
  CurrentUserProfileScreen(),
  SinglePostScreen(),
  
  StoryScreen(),
  UserProfileScreen(),
  EditCurrentUserScreen(),
  UploadScreen(currentuser: widget.currentuser,),
  ChatScreen(),
  
],
controller: pageController,
physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
      ),
      
    );
  }



}