import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/auth.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/post.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/user.dart';
import 'package:chatgram_app/flutter-instagram-clone/data/users.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/FrontScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/SinglePostScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UploadScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/screens/UserProfileScreen.dart';
import 'package:chatgram_app/flutter-instagram-clone/widgets/widgets.dart' as widgetclass;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatelessWidget {
  final User user;
  SearchResult({this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[350],
        child: Column(
    children: <Widget>[
      GestureDetector(
        onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(user: user,)));
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.photourl)
          ),
          title: Text(user.username,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        ),
      ),
      Divider(
        height: 2.0,
        color: Colors.white54,
      )
    ],
        ),
      );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController _seachcontroller = TextEditingController();
  Future<QuerySnapshot> searchResults;
  List<User> userslist;

 
  handleSearch(String query){
    Future<QuerySnapshot> users = userref.where("username",isGreaterThanOrEqualTo: query).getDocuments();

    users.then((value) => print("search results query : ${value.documents}"));
    setState(() {
      searchResults = users;
    });
  }


  getallpost()async{

    List<Post> allposts = [];
  
   userref.getDocuments().then((users) =>{
     users.documents.forEach((user) {
       postsref.document(user.documentID)
       .collection("userPosts")
       .getDocuments().then((posts) =>{
         posts.documents.forEach((post) {
           allposts.add(Post.fromDocument(post));
          })
       });
      })

   });
 if(allposts.length < 1){
    await Future.delayed(Duration(milliseconds: 2000));
   }


  print('all posts length is : ${allposts.length}');

  return allposts;
  
  
  }

  

  buildSearchResults(){
    return FutureBuilder(
      future: searchResults,
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        List<SearchResult> searchresult = [];
        snapshot.data.documents.forEach((doc){
          User user = User.fromDocument(doc);
          SearchResult searchResultclass = SearchResult(user: user,);
          searchresult.add(searchResultclass);
        });
        return ListView(
          shrinkWrap: true,
          children: searchresult,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentcolor = Theme.of(context).accentColor;
  final primarycolor = Theme.of(context).primaryColor;
final backgroundcolor = Theme.of(context).backgroundColor;
    return SafeArea(
          child: Scaffold(
        backgroundColor: backgroundcolor,
          body: SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50.0,
                child: TextFormField(
                  onFieldSubmitted: handleSearch,
                  textAlign: TextAlign.start,
                  controller: _seachcontroller,
                  keyboardType: TextInputType.text,
                  decoration: widgetclass.inputdecoration.copyWith(fillColor: Colors.grey[200],hintText: 'Search...',prefixIcon: Icon(Icons.search),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)))
                ),
              ),
            ),
          _seachcontroller.text.isNotEmpty ? buildSearchResults() : SizedBox(),
            Container(
              height: 58.0,
              width: double.infinity,
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8.0),
                children: <Widget>[
                  
                  FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(width: 1.0,color: accentcolor)),
          onPressed: (){},
          splashColor: primarycolor,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Icon(Icons.video_collection),
               SizedBox(width: 5.0,),
               Text('IGTV')
             ],
           ),
           ),
           SizedBox(width: 15.0,),
           FlatButton(
             splashColor: primarycolor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(width: 1.0,color: accentcolor)),
          onPressed: (){},
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               Icon(Icons.shopping_bag),
               SizedBox(width: 5.0,),
               Text('SHOP')
             ],
           ),
           ),
           SizedBox(width: 15.0,),
           FlatButton(
             splashColor: primarycolor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(width: 1.0,color: accentcolor)),
          onPressed: (){},
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               Icon(Icons.tv),
               SizedBox(width: 5.0,),
               Text('GAME')
             ],
           ),
           ),
           SizedBox(width: 15.0,),
           FlatButton(
             splashColor: primarycolor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(width: 1.0,color: accentcolor)),
          onPressed: (){},
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               Icon(Icons.near_me),
               Text('NEWS')
             ],
           ),
           ),
           SizedBox(),
                ],
              ),
            ),
           
          FutureBuilder(
            future: getallpost(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              return searchimgGrid(snapshot.data);
            },
          ),
            
        ],
      ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: accentcolor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen(currentuser: currentuser,)));
              },
              tooltip: 'Post',
              child: Icon(Icons.add),
            ),
          bottomNavigationBar: widgetclass.customnavigation(context)
        ),
    );
  }

  GridView searchimgGrid(List<Post> posts) {
    return GridView.builder(
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.0,
              childAspectRatio: 1.0,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0
            ),
            itemCount: posts.length,
            itemBuilder: (BuildContext context,int index){ 
              return InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePostScreen(userpost: posts[index],))),
                              child: Hero(
                                tag: posts[index].postid,
                                                              child: Container(
                  child: Image(image: CachedNetworkImageProvider(posts[index].mediaUrl),fit: BoxFit.cover,),
                ),
                              ),
              );
            },
          );
  }
}