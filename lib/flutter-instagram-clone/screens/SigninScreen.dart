import 'package:chatgram_app/flutter-instagram-clone/control-pages/Home.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/auth.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SignupScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart';
import 'package:flutter/material.dart';



User currentuser;
class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
   final _formkey = new GlobalKey<FormState>();

   AuthService _auth = AuthService();

   final _scaffoldkey = GlobalKey<ScaffoldState>();

    final signin = 'Sign in to\n Chatgram';

    final detail = 'Enter your detail below';

    String email = '';
    String password = '';


    submitHandler(context)async{
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
     dynamic result = await _auth.signInWithEmailAndPassword(email, password);
    if(result == null){
      print('result returned null');
      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('Enter correct credentials'),));
      return null;
    }
    User currentuser = await _auth.getuserdetailsfromuid(result);
    getcurrentuserfromwidget(currentuser);
   return Navigator.push(context, MaterialPageRoute(builder: (context) => Home(currentuser: currentuser,)));
    }
  }

  @override
  Widget build(BuildContext context) {
   
    double widthofdevice = MediaQuery.of(context).size.width;

    return SafeArea(
          child: Scaffold(
            key: _scaffoldkey,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(signin,textAlign: TextAlign.center,style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w900,fontSize: 34.0),),
                SizedBox(height: 15.0,),
                Text(detail,textAlign: TextAlign.center,style: TextStyle(color: Theme.of(context).accentColor,fontWeight: FontWeight.w300,fontSize: 14.0),),
                SizedBox(height: 20.0,),
                Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Username or Email',textAlign: TextAlign.left,),
            Container(
              width: widthofdevice * 0.78,
              
              child: Padding(
                padding:  EdgeInsets.only(top: 12.0),
                child: TextFormField(
                  validator: (val) => val.isEmpty ? 'Enter a valid Email address' : null,
                  onSaved: (val) => email = val,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputdecoration.copyWith(hintText: 'Email Address',prefixIcon: Icon(Icons.email))
                ),
              ),
            )
              ],
            ),
            SizedBox(height: 12.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Password',textAlign: TextAlign.left,),
            Container(
              width: widthofdevice * 0.78,
              
              child: Padding(
                padding:  EdgeInsets.only(top: 12.0),
                child: TextFormField(
                  validator: (val) => val.length < 6 ? 'Please enter  6+ chars' : null,
                  onSaved: (val) => password = val,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: inputdecoration.copyWith(hintText: 'Password',prefixIcon: Icon(Icons.lock))
                ),
              ),
            )
              ],
            ),
            SizedBox(height: 30.0,),
            Container(
              width: widthofdevice * 0.78,
              height: 60.0,
              
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                              child: RaisedButton(
                    onPressed: (){ submitHandler(context); },
                    child: Text('Sign in',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    color: Theme.of(context).accentColor,
                    hoverElevation: 2.0,
                    splashColor: Colors.white,
                    ),
              ),
            ),
            SizedBox(height: 20.0,),
            TextButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())); }, child: Text('Not a member? Signup now'))
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