import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart';
import 'package:flutter/material.dart';


class EditCurrentUserScreen extends StatefulWidget {
  @override
  _EditCurrentUserScreenState createState() => _EditCurrentUserScreenState();
}

class _EditCurrentUserScreenState extends State<EditCurrentUserScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
   final _formkey = GlobalKey<FormState>();

   String username = '';
   String bio = '';
  @override
  Widget build(BuildContext context) {
    double widthofdevice = MediaQuery.of(context).size.width;
    double heightofdevice = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldkey,
        backgroundColor: backgroundcolor,
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
                  child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 100.0),
              height: heightofdevice * 0.7,
              width: widthofdevice * 0.82,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Form(
                        key: _formkey,
                        child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          
                      Container(
                        width: widthofdevice * 0.78,
                        
                        child: Padding(
                          padding:  EdgeInsets.only(top: 12.0),
                          child: TextFormField(
                            autovalidate: true,
                            validator: (val){ 
                              if(val.trim().length < 3 || val.isEmpty){
                                return 'Enter valid 3+ chars';
                              }
                              return null;
                             },
                             onSaved: (val) => username = val,
                            keyboardType: TextInputType.text,
                            decoration: inputdecoration.copyWith(hintText: 'Username',prefixIcon: Icon(Icons.person),labelText: 'Username')
                          ),
                        ),
                      ),
                      
                  
                      Container(
                        width: widthofdevice * 0.78,
                        
                        child: Padding(
                          padding:  EdgeInsets.only(top: 12.0),
                          child: TextFormField(
                            validator: (val){ 
                              if(val.trim().length < 3 || val.isEmpty){
                                return 'Enter valid 3+ chars';
                              }
                              return null;
                             },
                             onSaved: (val) => bio = val,
                            keyboardType: TextInputType.text,
                            decoration: inputdecoration.copyWith(hintText: 'Bio',prefixIcon: Icon(Icons.lock),labelText: 'Bio')
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Container(
                        width: widthofdevice * 0.78,
                        height: 60.0,
                        
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                        child: RaisedButton(
                              onPressed: (){
                                submithandler();
                              },
                              child: Text('Submit',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                              color: Theme.of(context).accentColor,
                              hoverElevation: 2.0,
                              splashColor: Colors.white,
                              ),
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Container(
                        width: widthofdevice * 0.78,
                        height: 60.0,
                        
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                        child: RaisedButton(
                              onPressed: (){ Navigator.pop(context); },
                                                            child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                                                            color: Theme.of(context).primaryColor,
                                                            hoverElevation: 2.0,
                                                            splashColor: Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                      ],
                                                    ),
                                                    
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              
                                dynamic submithandler() {
                                  if(_formkey.currentState.validate()){
                                    _formkey.currentState.save();
                                   return Navigator.pop(context,[username,bio]);
                                  }
                                }
}