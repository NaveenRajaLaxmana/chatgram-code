import 'package:chatgram_app/flutter-instagram-clone/control-pages/Home.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/users.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/EditCurrentuserScreen.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/SigninScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SignupScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/auth.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googlesignin = GoogleSignIn();
CollectionReference userref = Firestore.instance.collection('users');
CollectionReference postsref = Firestore.instance.collection('posts');
final StorageReference storageRef = FirebaseStorage.instance.ref();
final commentsRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final followersRef = Firestore.instance.collection('followers');
final followingRef = Firestore.instance.collection('following');
final timelineRef = Firestore.instance.collection('timeline');
final storyRef = Firestore.instance.collection('story');
final chatsRef = Firestore.instance.collection('chats');
User currentuser;
AuthService authservice = AuthService();


class FrontScreen extends StatefulWidget {
  @override
  _FrontScreenState createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  bool isauth = false;
 DateTime timestamp = DateTime.now();
 final FirebaseAuth _auth = FirebaseAuth.instance;
  final _frontscreenimages = [Frontdetails(url: 'assets/frontscreen.jpg',text: 'Welcome to Chatgram'),Frontdetails(url: 'assets/frontscreen2.jpg',text: 'We Bring the People \n Together'),Frontdetails(url: 'assets/frontscreen3.jpg',text: 'Share your Joy With \n Loved Ones'),Frontdetails(url: 'assets/frontscreen4.jpg',text: 'Lets Start'),];

  @override
  void initState() { 
    super.initState();
    googlesignin.onCurrentUserChanged.listen((GoogleSignInAccount account) async{ 
      
       final GoogleSignInAuthentication googleAuth = await account.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential));
  await handleLogin(user);
 
    },onError: (err){
      print('Error in Signing in : $err');
    });


    googlesignin.signInSilently(suppressErrors: false).then((account)async{
      final GoogleSignInAuthentication googleAuth = await account.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
       final FirebaseUser user = (await _auth.signInWithCredential(credential));
      await handleLogin(user);
    }).catchError((err){
      print('Error in Signing in : $err');
    });


  }

 adduserincollection(FirebaseUser user,String username,String bio)async {
   
          DocumentSnapshot doc = await userref.document(user.uid).get();
          if(!doc.exists){
            userref.document(user.uid).setData({
              "uid": user.uid,
              "bio": bio,
              "username": username,
              "photourl": user.photoUrl,
              "email": user.email,
              "timestamp": timestamp
            });
           doc = await userref.document(user.uid).get();
          }
          
         User currentuser = await authservice.getuserdetailsfromuid(user);
    getcurrentuserfromwidget(currentuser);
        }

  handleLogin(FirebaseUser account)async{
    if(account != null){
      
      DocumentSnapshot doc = await userref.document(account.uid).get();
      if(!doc.exists){
        dynamic usernamebio = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditCurrentUserScreen()));
        String username = usernamebio[0];
        String bio = usernamebio[1];
        

       
        adduserincollection(account,username,bio);
      }
     
     
      
       User currentuser = await authservice.getuserdetailsfromuid(account);
    getcurrentuserfromwidget(currentuser);
      setState(() {
        isauth = true;
      });

    }else{
      setState(() {
        
        isauth = false;
      });
    }
  }


login()async{
   try {
    await googlesignin.signIn();
  } catch (error) {
    print(error);
  }
}

frontscreen(){
  return SafeArea(
      child: Scaffold(
        backgroundColor: accentcolor,
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.968,
                    width: MediaQuery.of(context).size.width,
              child: Swiper(
                  itemCount: _frontscreenimages.length,
                  scrollDirection: Axis.horizontal,
                  layout: SwiperLayout.DEFAULT,
                  itemWidth: MediaQuery.of(context).size.width,
                  itemHeight: MediaQuery.of(context).size.height * 0.968,
                  pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(),
                  ),
                  itemBuilder: (context,index){ 
                    if(index == _frontscreenimages.length -1){
                      return Stack(
                  children: [
                                            Positioned(
                top: 0.0,
                left: 0.0,
                height: MediaQuery.of(context).size.height * 0.968,
                width: MediaQuery.of(context).size.width,
                child: Container(
                            height: MediaQuery.of(context).size.height * 0.968,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(_frontscreenimages[index].url),
                              ),
                              color: Colors.black.withOpacity(0.3)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 165.0,left: 15.0),
                              child: Text(_frontscreenimages[index].text,style: TextStyle(color: primarycolor,fontSize: 25.0,fontWeight: FontWeight.w800),textAlign: TextAlign.left,),
                            ),
                          ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            height: MediaQuery.of(context).size.height * 0.465,
              width: MediaQuery.of(context).size.width,
                                                      child: Container(
              height: MediaQuery.of(context).size.height * 0.465,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
                gradient: LinearGradient(colors: [Colors.orange,Colors.red],begin: Alignment.bottomLeft,end: Alignment.topRight,stops: [0.3,0.6])
              ),
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    elevation: 0.0,
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: backgroundcolor,
                    onPressed: (){
                      login();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message,size: 23.0,color: primarycolor,),
                        SizedBox(width: 15.0,),
                        Text('Sign in with Google',style: TextStyle(color: accentcolor,fontSize: 21.0,fontWeight: FontWeight.w400),)
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                    elevation: 0.0,
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: accentcolor,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email,size: 23.0,color: primarycolor,),
                        SizedBox(width: 15.0,),
                        Text('Sign in with Email',style: TextStyle(color: backgroundcolor,fontSize: 21.0,fontWeight: FontWeight.w400),)
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  TextButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())); }, child: Text('Not a member ? Signup now'))
                ],
              ),
            ),
                          )
                                          ]);
                    }
                    return Stack(
                  children: [
                                            Positioned(
                top: 0.0,
                left: 0.0,
                height: MediaQuery.of(context).size.height * 0.968,
                width: MediaQuery.of(context).size.width,
                child: Container(
                            height: MediaQuery.of(context).size.height * 0.968,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(_frontscreenimages[index].url),
                              ),
                              color: Colors.black.withOpacity(0.3)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 165.0,left: 15.0),
                              child: Text(_frontscreenimages[index].text,style: TextStyle(color: primarycolor,fontSize: 25.0,fontWeight: FontWeight.w800),textAlign: TextAlign.left,),
                            ),
                          ),
                          ),
                                          ]);
                  }
              ),
            ),
           
          ]
        ),
      ),
    );
}

  @override
  Widget build(BuildContext context) {
    return isauth ? Home(currentuser: currentuser,) : frontscreen();
  }
}