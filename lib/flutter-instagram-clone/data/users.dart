

class Userstories{
  String url;
  String name;
  String location;
  Userstories(this.url,this.name,this.location);
  bool isLiked = false;

void setLiked(bool isliked){
  isLiked = isliked;
}
}


List<Userstories> stories = [
  Userstories('assets/img1.jpg','Radha','Delhi'),
  Userstories('assets/img2.jpg','Parvathi','Bangalore'),
  Userstories('assets/img3.jpg','Girl','Bangalore'),
  Userstories('assets/img4.jpg','Women','Chennai'),
  Userstories('assets/img5.jpg','Woman','Switzerland'),
  Userstories('assets/img6.jpg','Yasmin','Mumbai'),
  Userstories('assets/img7.jpg','Krishna','Goa'),
  Userstories('assets/img8.jpg','Shiva','Delhi'),
  Userstories('assets/img9.jpg','Balram','Mumbai'),
  Userstories('assets/img1.jpg','Radha','Delhi'),
  Userstories('assets/img2.jpg','Parvathi','Bangalore'),
  Userstories('assets/img3.jpg','Girl','Bangalore'),
  Userstories('assets/img4.jpg','Women','Chennai'),
  Userstories('assets/img5.jpg','Woman','Switzerland'),
  Userstories('assets/img6.jpg','Yasmin','Mumbai'),
  Userstories('assets/img7.jpg','Krishna','Goa'),
  Userstories('assets/img8.jpg','Shiva','Delhi'),
  Userstories('assets/img9.jpg','Balram','Mumbai'),
  Userstories('assets/img1.jpg','Radha','Delhi'),
  Userstories('assets/img2.jpg','Parvathi','Bangalore'),
  Userstories('assets/img3.jpg','Girl','Bangalore'),
  Userstories('assets/img4.jpg','Women','Chennai'),
  Userstories('assets/img5.jpg','Woman','Switzerland'),
  Userstories('assets/img6.jpg','Yasmin','Mumbai'),
  Userstories('assets/img7.jpg','Krishna','Goa'),
  Userstories('assets/img8.jpg','Shiva','Delhi'),
  Userstories('assets/img9.jpg','Balram','Mumbai'),
  Userstories('assets/img1.jpg','Radha','Delhi'),
  Userstories('assets/img2.jpg','Parvathi','Bangalore'),
  Userstories('assets/img3.jpg','Girl','Bangalore'),
  Userstories('assets/img4.jpg','Women','Chennai'),
  Userstories('assets/img5.jpg','Woman','Switzerland'),
  Userstories('assets/img6.jpg','Yasmin','Mumbai'),
  Userstories('assets/img7.jpg','Krishna','Goa'),
  Userstories('assets/img8.jpg','Shiva','Delhi'),
  Userstories('assets/img9.jpg','Balram','Mumbai'),
  Userstories('assets/img1.jpg','Radha','Delhi'),
  Userstories('assets/img2.jpg','Parvathi','Bangalore'),
  Userstories('assets/img3.jpg','Girl','Bangalore'),
  Userstories('assets/img4.jpg','Women','Chennai'),
  Userstories('assets/img5.jpg','Woman','Switzerland'),
  Userstories('assets/img6.jpg','Yasmin','Mumbai'),
  Userstories('assets/img7.jpg','Krishna','Goa'),
  Userstories('assets/img8.jpg','Shiva','Delhi'),
  Userstories('assets/img9.jpg','Balram','Mumbai'),
  Userstories('assets/img1.jpg','Radha','Delhi'),
  Userstories('assets/img2.jpg','Parvathi','Bangalore'),
  Userstories('assets/img3.jpg','Girl','Bangalore'),
  Userstories('assets/img4.jpg','Women','Chennai'),
  Userstories('assets/img5.jpg','Woman','Switzerland'),
  Userstories('assets/img6.jpg','Yasmin','Mumbai'),
  Userstories('assets/img7.jpg','Krishna','Goa'),
  Userstories('assets/img8.jpg','Shiva','Delhi'),
  Userstories('assets/img9.jpg','Balram','Mumbai'),
  Userstories('assets/img1.jpg','Radha','Delhi'),
  Userstories('assets/img2.jpg','Parvathi','Bangalore'),
  Userstories('assets/img3.jpg','Girl','Bangalore'),
  Userstories('assets/img4.jpg','Women','Chennai'),
  Userstories('assets/img5.jpg','Woman','Switzerland'),
  Userstories('assets/img6.jpg','Yasmin','Mumbai'),
  Userstories('assets/img7.jpg','Krishna','Goa'),
  Userstories('assets/img8.jpg','Shiva','Delhi'),
  Userstories('assets/img9.jpg','Balram','Mumbai'),
  Userstories('assets/img1.jpg','Radha','Delhi'),
  Userstories('assets/img2.jpg','Parvathi','Bangalore'),
  Userstories('assets/img3.jpg','Girl','Bangalore'),
  Userstories('assets/img4.jpg','Women','Chennai'),
  Userstories('assets/img5.jpg','Woman','Switzerland'),
  Userstories('assets/img6.jpg','Yasmin','Mumbai'),
  Userstories('assets/img7.jpg','Krishna','Goa'),
  Userstories('assets/img8.jpg','Shiva','Delhi'),
  Userstories('assets/img9.jpg','Balram','Mumbai'),
];

class Frontdetails{
  String url;
  String text;
  Frontdetails({this.url,this.text});
}

class Chatdata{
  String data;
  String user;
  Chatdata({this.user,this.data});
}

List<Chatdata> chatdatas = [Chatdata(user: 'Krishna',data: 'Hello Welcome'),Chatdata(user: 'me',data: 'hello Thanks'),Chatdata(user: 'Krishna',data: 'How are You'),Chatdata(user: 'me',data: 'Fine'),Chatdata(user: 'Krishna',data: 'Mmm Thats Good...')];