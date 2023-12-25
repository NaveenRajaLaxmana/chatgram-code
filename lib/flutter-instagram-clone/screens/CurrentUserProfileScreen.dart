import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/auth.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/post.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/EditCurrentuserScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SinglePostScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UploadScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart'
    as widgetclass;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';

AuthService auth = AuthService();

class CurrentUserProfileScreen extends StatefulWidget {
  

  @override
  _CurrentUserProfileScreenState createState() =>
      _CurrentUserProfileScreenState();
}

class _CurrentUserProfileScreenState extends State<CurrentUserProfileScreen> {
 
  bool isloading = false;
  File file;
  bool isuploading = false;
   GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
   User user;
   int postCount;
   List<Post> userposts = [];
  CollectionReference postsref = Firestore.instance.collection('posts');
  int followersCount = 0;
  int followingCount = 0;

  @override
  void initState() { 
    super.initState();
    getprofileposts();
    getFollowers();
    getFollowing();
  }

  mylogout() async {
    if (googlesignin.currentUser != null) {
      googlesignin.signOut().then((value) => {
            print('the googlesignout is done :$value'),
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FrontScreen()))
          });
    }
    auth.logout();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FrontScreen()));
  }

  showdeletedialog(context,String postid){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Delete Dialog',style: TextStyle(color: Colors.black,fontSize: 19.0,fontWeight: FontWeight.w600),),
          content: Text('Are Yout sure to Delete the Post',style: TextStyle(color: Colors.black,fontSize: 17.0,fontWeight: FontWeight.w400),),
          actions: [
            FlatButton(onPressed: ()async{
              await deletepost(context,postid);
            }, child: Text('Yes',style: TextStyle(fontWeight: FontWeight.w700),)),
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('No',style: TextStyle(fontWeight: FontWeight.w700),)),
          ],
        );
      }
      );
  }

  deletepost(context,String postid)async{
    DocumentSnapshot doc = await postsref.document(widgetclass.currentuser.id).collection("userPosts").document(postid).get();
    doc.reference.delete();
    Navigator.pop(context);
  }

getFollowers() async{
    QuerySnapshot snapshot = await followersRef.document(widgetclass.currentuser.id).collection('userFollowers').getDocuments();
    setState(() {
      followersCount = snapshot.documents.length;
    });
  }

  getFollowing() async{
    QuerySnapshot snapshot = await followingRef.document(widgetclass.currentuser.id).collection('userFollowing').getDocuments();
     setState(() {
      followingCount = snapshot.documents.length;
    });
  }


  getprofileposts() async{
    QuerySnapshot postssnapshot = await postsref.document(widgetclass.currentuser.id).collection("userPosts").orderBy("timestamp",descending: true).getDocuments();
    setState(() {
      postCount = postssnapshot.documents.length;
      userposts =  postssnapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  Future<DocumentSnapshot> returndata() async {
    DocumentSnapshot data = await userref.document(widgetclass.currentuser.id).get();
    if (data != null) {
      User updateduser= User.fromDocument(data);
      return widgetclass.getcurrentuserfromwidget(updateduser);
    } else {
      
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context,widgetclass.currentuser);
  }

  Scaffold buildScaffold(BuildContext context,User user) {
    return Scaffold(
       key: scaffoldkey,
   backgroundColor: widgetclass.backgroundcolor,
   appBar: AppBar(
     automaticallyImplyLeading: false,
     backgroundColor: widgetclass.backgroundcolor,
     title: Text(
       '${user.username}',
       style: TextStyle(
           color: widgetclass.accentcolor,
           fontSize: 22.0,
           fontWeight: FontWeight.w700),
     ),
     actions: [
       IconButton(
           icon: Icon(
             Icons.settings,
             color: widgetclass.accentcolor,
           ),
           onPressed: () {
             setState(() {
               scaffoldkey.currentState.openEndDrawer();
             });
           })
     ],
     elevation: 0.0,
   ),
   body: SingleChildScrollView(
     physics: AlwaysScrollableScrollPhysics(),
     scrollDirection: Axis.vertical,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
         Container(
           height: MediaQuery.of(context).size.height * 0.35,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius:
                   BorderRadius.vertical(bottom: Radius.circular(40.0)),
               color: widgetclass.backgroundcolor,
               boxShadow: [
                 BoxShadow(
                     offset: Offset(0, 1.0),
                     color: Colors.black.withOpacity(0.1),
                     blurRadius: 25.0,
                     spreadRadius: 5.0)
               ]),
           child: Column(
             children: [
               Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Row(
                   children: <Widget>[
                     Container(
                       height: 100,
                       width: 100,
                       child: Stack(
                         overflow: Overflow.visible,
                         children: [
                           Positioned(
                             height: 100,
                             width: 100,
                             child: Container(
                               height: 90,
                               width: 90,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25.0),
                                   border: Border.all(
                                       color: Colors.red,
                                       width: 3.5,
                                       style: BorderStyle.solid)),
                             ),
                           ),
                           Positioned(
                             height: 90,
                             width: 90,
                             top: 6.0,
                             left: 5.0,
                             child: Container(
                               height: 90,
                               width: 90,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(22.0),
                                   image: DecorationImage(
                                       image: CachedNetworkImageProvider(user.photourl),
                                       fit: BoxFit.cover)),
                             ),
                           ),
                           Positioned(
                             height: 25,
                             width: 25,
                             bottom: -3.0,
                             right: 0.0,
                             child: GestureDetector(
                               onTap: () {
                                 updateprofileimage(context);
                               },
                               child: Container(
                                 height: 25,
                                 width: 25,
                                 decoration: BoxDecoration(
                                     borderRadius:
                                         BorderRadius.circular(10.0),
                                     color: widgetclass.accentcolor),
                                 child: Icon(
                                   Icons.add_a_photo,
                                   color: widgetclass.backgroundcolor,
                                   size: 14.0,
                                 ),
                               ),
                             ),
                           )
                         ],
                       ),
                     ),
                     Spacer(),
                     Padding(
                       padding:
                           const EdgeInsets.only(left: 10.0, right: 10.0),
                       child: Row(
                         children: <Widget>[
                           Column(
                             children: <Widget>[
                               Text(
                                 '$postCount',
                                 style: TextStyle(
                                     color: widgetclass.accentcolor,
                                     fontSize: 22.0,
                                     fontWeight: FontWeight.w700),
                               ),
                               Text(
                                 'Posts',
                                 style: TextStyle(
                                     color: widgetclass.accentcolor
                                         .withOpacity(0.6),
                                     fontSize: 16.0,
                                     fontWeight: FontWeight.w400),
                               ),
                             ],
                           ),
                           SizedBox(
                             width: 15.0,
                           ),
                           Column(
                             children: <Widget>[
                               Text(
                                 '$followersCount',
                                 style: TextStyle(
                                     color: widgetclass.accentcolor,
                                     fontSize: 22.0,
                                     fontWeight: FontWeight.w700),
                               ),
                               Text(
                                 'Followers',
                                 style: TextStyle(
                                     color: widgetclass.accentcolor
                                         .withOpacity(0.6),
                                     fontSize: 16.0,
                                     fontWeight: FontWeight.w400),
                               ),
                             ],
                           ),
                           SizedBox(
                             width: 15.0,
                           ),
                           Column(
                             children: <Widget>[
                               Text(
                                 '$followingCount',
                                 style: TextStyle(
                                     color: widgetclass.accentcolor,
                                     fontSize: 22.0,
                                     fontWeight: FontWeight.w700),
                               ),
                               Text(
                                 'Following',
                                 style: TextStyle(
                                     color: widgetclass.accentcolor
                                         .withOpacity(0.6),
                                     fontSize: 16.0,
                                     fontWeight: FontWeight.w400),
                               ),
                             ],
                           ),
                           SizedBox(
                             width: 15.0,
                           ),
                         ],
                       ),
                     )
                   ],
                 ),
               ),
               Padding(
                 padding: EdgeInsets.all(10.0),
                 child: Row(
                   children: <Widget>[
                     Text(
                       '${user.username}',
                       style: TextStyle(
                           color: widgetclass.accentcolor,
                           fontSize: 22.0,
                           fontWeight: FontWeight.w700),
                     ),
                     SizedBox(
                       width: 10.0,
                     ),
                     SizedBox(
                       height: 30.0,
                       width: 2.0,
                       child: Container(
                         color: Colors.grey,
                       ),
                     ),
                     SizedBox(
                       width: 10.0,
                     ),
                     Text(
                       '${user.bio}',
                       style: TextStyle(
                           color: widgetclass.accentcolor,
                           fontSize: 22.0,
                           fontWeight: FontWeight.w700),
                     ),
                   ],
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Text(
                   '${user.bio}',
                   style: TextStyle(
                       fontSize: 15.0,
                       color: widgetclass.accentcolor.withOpacity(0.6)),
                   textAlign: TextAlign.left,
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(right: 18.0),
                 child: Align(
                   alignment: Alignment.bottomRight,
                   child: GestureDetector(
                       onTap: () {
                         edituserdetails();
                       },
                       child: Container(
                           height: 50,
                           width: 50,
                           child: Icon(
                             Icons.edit,
                             color: widgetclass.accentcolor,
                           ),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(15.0),
                               color: Colors.grey))),
                 ),
               )
             ],
           ),
         ),
         Padding(
           padding:
               const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
           child: GridView.builder(
             scrollDirection: Axis.vertical,
             physics: NeverScrollableScrollPhysics(),
             shrinkWrap: true,
             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                 maxCrossAxisExtent: 250.0,
                 childAspectRatio: 1.0,
                 crossAxisSpacing: 10.0,
                 mainAxisSpacing: 10.0),
             itemCount: userposts.length,
             itemBuilder: (BuildContext context, int index) {
               return GestureDetector(
                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePostScreen(userpost: userposts[index],))),
                 onLongPress: () => showdeletedialog(context,userposts[index].postid),
                                child: Hero(
                                          tag: userposts[index].postid,                        
                                                                  child: Container(
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15.0),
                       image: DecorationImage(
                           image: CachedNetworkImageProvider(userposts[index].mediaUrl),
                           fit: BoxFit.cover)),
                   
                 ),
                                ),
               );
             },
           ) ,
         ),
         SizedBox(
           height: 15.0,
         ),
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
   endDrawer: Drawer(
       child: ListView(
     children: [
       SizedBox(),
       FlatButton(
         onPressed: () {
           mylogout();
         },
         child: Text('Logout'),
       ),
     ],
   )),
  );
  }



  updatephotourlInFirestore({String mediaUrl}) {
    userref.document(widgetclass.currentuser.id).updateData({"photourl": mediaUrl});
  }

  Future<String> uploadImage(imagefile) async {
    StorageUploadTask uploadtask =
        storageRef.child("img_${widgetclass.currentuser.id}.jpg").putFile(imagefile);
    StorageTaskSnapshot storagesnap = await uploadtask.onComplete;
    String downloadUrl = await storagesnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSubmit() async {
    setState(() {
      isuploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    updatephotourlInFirestore(mediaUrl: mediaUrl);
    await returndata();
    setState(() {
      file = null;
      isuploading = false;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile =  Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_${widgetclass.currentuser.id}.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Update ProfileImage'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Photo with Camera'),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text('Image from Gallery'),
                onPressed: handlechoosePhotoGallery,
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    setState(() {
      this.file = file;
    });
  }

  void handlechoosePhotoGallery() async {
    Navigator.pop(context);

    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = file;
    });
    handleSubmit();
  }

  updateprofileimage(context) {
    selectImage(context);
  }
  
  Scaffold loadingmethod() {
    return Scaffold(
      body: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  edituserdetails() async {
    dynamic usernamebio = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditCurrentUserScreen()));
    setState(() {
      isloading = true;
    });
    String username = usernamebio[0];
    String bio = usernamebio[1];
    if (username != null && bio != null) {
      userref
          .document(widgetclass.currentuser.id)
          .updateData({"username": username, "bio": bio});
         await returndata();
      SnackBar snackbar = SnackBar(
        content: Text("Profile Updated"),
      );
      scaffoldkey.currentState.showSnackBar(snackbar);
      setState(() {
        isloading = false;
      });
    }
  }

 
}
