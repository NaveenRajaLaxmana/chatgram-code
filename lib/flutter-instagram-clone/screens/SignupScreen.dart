import 'package:chatgram_app/flutter-instagram-clone/control-pages/Home.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/auth.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/EditCurrentuserScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SigninScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart';
import 'package:flutter/material.dart';

User currentuser;
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
   final _formkey = new GlobalKey<FormState>();
   final _scaffoldkey = new GlobalKey<ScaffoldState>();

   AuthService _auth = AuthService();

    final signin = 'SignUp in to\n Chatgram';

    final detail = 'Enter your detail below';

   String email = '';

     String password = '';

  @override
  Widget build(BuildContext context) {
    
    double widthofdevice = MediaQuery.of(context).size.width;

  submitHandler(context)async{
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
    dynamic usernamebio = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditCurrentUserScreen()));
   String username = usernamebio[0];
   String bio = usernamebio[1];
    print('username : $username, bio : $bio');
     dynamic result = await _auth.registerWithEmailAndPassword(email, password,username,bio);
    
      if(result == null){
      print('result returned null');
      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text('please enter valid email...'),));
      return null;
      }
      User currentuser = await _auth.getuserdetailsfromuid(result);
      getcurrentuserfromwidget(currentuser);
      _formkey.currentState.reset();
    return Navigator.push(context, MaterialPageRoute(builder: (context) => Home(currentuser: currentuser,)));
    
    }
  }

    return SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
                  child: Container(
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
                    validator: (val) => val.isEmpty ? 'Enter an Email' : null,
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
                    validator: (val) => val.length < 6 ? 'Enter a Password 6+ chars' : null,
                    onChanged: (val) => password = val,
                    onSaved: (val) => password = val,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: inputdecoration.copyWith(hintText: 'Password',prefixIcon: Icon(Icons.lock))
                  ),
                ),
              )
                ],
              ),
              SizedBox(height: 12.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Confirm Password',textAlign: TextAlign.left,),
              Container(
                width: widthofdevice * 0.78,
                
                child: Padding(
                  padding:  EdgeInsets.only(top: 12.0),
                  child: TextFormField(
                    validator: (val) => password != val? 'Password doesn\'t match' : null,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: inputdecoration.copyWith(hintText: 'Confirm Password',prefixIcon: Icon(Icons.lock))
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
                      onPressed: () => submitHandler(context),
                      child: Text('Sign Up',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                      color: Theme.of(context).accentColor,
                      hoverElevation: 2.0,
                      splashColor: Colors.white,
                      ),
                ),
              ),
              SizedBox(height: 20.0,),
              TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));}, child: Text('Already a member? Signin now'))
            ],
          ),
                  )
                ],
              ),
            ),
        ),
      ),
    );
  }
}