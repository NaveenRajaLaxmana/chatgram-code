
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';

import 'package:chatgram_app/flutter-instagram-clone/screens/UploadScreen.dart';
import 'package:flutter/material.dart';

Color backgroundcolor = Color(0xfff9f9f9);
Color accentcolor = Color(0xff22262f);
Color primarycolor = Color(0xff0c8eff);
User currentuser;
dynamic pagecontollernavigate;
final inputdecoration = InputDecoration(
                            filled: true,
                            fillColor: Color(0xfff9f9f9),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0))
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.transparent,)
                            )
                          );

  CachedNetworkImage cachedimage(String mediaUrl){
    return CachedNetworkImage(
      imageUrl: mediaUrl,
      placeholder: (context,url) => Padding(
        child: CircularProgressIndicator(),
        padding: EdgeInsets.all(20),
      ),
      errorWidget: (context,url,error) => Icon(Icons.error),
    );
  }


  initcontoller(controller){
    pagecontollernavigate = controller;
  }
  getcurrentuserfromwidget(User user){
    print('user is $user');
    currentuser = user;
    print('currentuser is : $currentuser');
  }
  myfunction(int pageno){
    print('working print');
    pagecontollernavigate.animateToPage(pageno,duration: Duration(milliseconds: 300),curve: Curves.easeInOut);
  }


 customnavigation(context){
   return BottomAppBar(
     color: accentcolor,
     shape: CircularNotchedRectangle(),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: [
          IconButton(icon: Icon(Icons.home,color: backgroundcolor,size: 23.0,), onPressed: (){ myfunction(0);}),
          IconButton(icon: Icon(Icons.search,color: backgroundcolor,size: 23.0,), onPressed: (){
            myfunction(1);
          }),
            IconButton(icon: Icon(Icons.favorite_border,color: backgroundcolor,size: 23.0,), onPressed: (){
            myfunction(2);
          }),
          IconButton(icon: Icon(Icons.person,color: backgroundcolor,size: 23.0,), onPressed: (){
            myfunction(3);
      
          })
       ],
     ),
   );
   
  // return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
  //        color: accentcolor,
  //     ),
  //     height: 60.0,
  //     width: double.infinity,
  //     // color: accentcolor,
  //     child: CustomPaint(
  //         painter: CustombottomNavigationpainter(),
  //         child: Stack(
  //           overflow: Overflow.visible,
  //           alignment: Alignment.bottomCenter,
  //           children: [
  //             Positioned(
  //     top: -26.0,
  //     left: 170.0,
  //     height: 50.0,
  //     width: 50.0,
  //     child: FlatButton(
  //       padding: EdgeInsets.only(right: -2.0),
  //       color: accentcolor,
  //       onPressed: (){ print(currentuser); Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen(currentuser: currentuser,))); },
  //        child: Icon(Icons.add,color: backgroundcolor,textDirection: TextDirection.ltr,),
  //        shape: RoundedRectangleBorder(
  //          borderRadius: BorderRadius.circular(25.0),
  //          side: BorderSide(color: Colors.yellow,width: 2.0),
          
  //        ),
  //        ),
  //             ),
  //             Positioned(
  //     bottom: 0,
  //     left: 0,
  //     height: 60.0,
  //     width: MediaQuery.of(context).size.width,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         IconButton(icon: Icon(Icons.home,color: backgroundcolor,size: 23.0,), onPressed: (){ myfunction(0);}),
          
  //         IconButton(icon: Icon(Icons.search,color: backgroundcolor,size: 23.0,), onPressed: (){
  //           myfunction(1);
  //         }),
          
  //         IconButton(icon: Icon(Icons.favorite_border,color: backgroundcolor,size: 23.0,), onPressed: (){
  //           myfunction(2);
  //         }),
        
  //         IconButton(icon: Icon(Icons.person,color: backgroundcolor,size: 23.0,), onPressed: (){
  //           myfunction(3);
  //         //  Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentUserProfileScreen()));
  //         })
  //       ],
  //     ),
  //             )
  //           ],
  //         ),
  //       ),
  //   );

}

class CustomBottomnavigationbar extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
      var path = Path();
      path.moveTo(0, size.height * 0.3);
      path.lineTo(0, size.height);
      path.lineTo(size.width,size.height);
      path.lineTo(size.width,size.height * 0.3);
      path.lineTo(size.width * 0.65, size.height * .3);
      path.quadraticBezierTo(size.width * 0.59, size.height * 0.2 , size.width * 0.57, size.height * 0.1);
      path.quadraticBezierTo(size.width * 0.57, 0 , size.width * 0.48, 0);
      path.quadraticBezierTo(size.width * 0.42, size.height * 0.2, size.width * 0.39, size.height * 0.25);
      path.quadraticBezierTo(size.width * 0.39, size.height * 0.25, size.width * 0.35,size.height * 0.3);
      return path;
    }
  
    @override
    bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper != this;
   
  }
  

}

class CustombottomNavigationpainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
      // Path path = Path();
      var arcpaint = Paint();
      Path newpath = Path();
      var pathpaint = Paint();


      arcpaint.color = Color(0xff22262f);
      pathpaint.color = Colors.transparent;

      newpath.moveTo(0, size.height * 0.2);
      newpath.lineTo(0, size.height);
      newpath.lineTo(size.width, size.width);
      newpath.lineTo(size.width, size.height * 0.2);
      // newpath.lineTo(size.width * 0.39, size.height * 0.2);
      newpath.lineTo(size.width * 0.65, size.height * 0.2);
      // newpath.lineTo(0, size.height * 0.2);
     newpath.quadraticBezierTo(size.width * 0.60, size.height * 0.19, size.width * 0.57, -12.0); //correct angle for right
     newpath.lineTo(size.width * 0.43, -12);
     newpath.quadraticBezierTo(size.width * 0.39,size.height * 0.19, size.width * 0.36, size.height * 0.2);
     
      canvas.drawArc(Rect.fromLTWH(size.width * 0.42, -30.0, 60, 60), pi, pi, false, arcpaint);
      canvas.drawPath(newpath, pathpaint);

     
      
      // paint.color = Colors.blue;
      //  var x = size.width * 0.5;
      // var y = size.height * 0.5;
      // var radius = min(x, y);
      // Offset center = Offset(x,y);
      // var paintcircle = Paint();
      // paintcircle.color = Colors.green;
      // canvas.translate(0, -20.0);
      // canvas.drawCircle(center, radius, paintcircle);
    }
  
    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) {
     return oldDelegate != this;
  }

}