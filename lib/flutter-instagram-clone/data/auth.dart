import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';




class AuthService{
 final FirebaseAuth _auth = FirebaseAuth.instance;
 DateTime timestamp = DateTime.now();

 Future registerWithEmailAndPassword(String email,String password,String username,String bio)async{
   try{
     print('email : $email, password : $password,username : $username, bio : $bio');
     final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result;
      print('user is registered : $result');
      
            return adduserincollection(user,username,bio);
         }catch(e){
           print('cant register user :'+e.toString());
           return null;
         }
       }

  Future signInWithEmailAndPassword(String email,String password)async{
   try{
     print('email : $email, password : $password');
     final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result;
      print('user is loged in: $result');
            return user;
         }catch(e){
           print('cant login user :'+e.toString());
           return null;
         }
       }
      
        void adduserincollection(FirebaseUser user,String username,String bio)async {
          DocumentSnapshot doc = await userref.document(user.uid).get();
          if(!doc.exists){
            userref.document(user.uid).setData({
              "uid": user.uid,
              "bio": bio,
              "username": username,
              "photourl": "https://icon-library.com/images/android-user-icon/android-user-icon-29.jpg",
              "email": user.email,
              "timestamp": timestamp
            });
          }else{
            print('user is already registered');
          }
        }

        logout()async{
        await _auth.signOut();
        }

         getuserdetailsfromuid(FirebaseUser user)async{
          DocumentSnapshot doc = await userref.document(user.uid).get();
          if(doc.exists){
           User currentuser= User.fromDocument(doc);
           return currentuser;
          }
        }

}