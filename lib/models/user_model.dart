class UserModel{
  String? userName;
  String? phoneNumber;
  String? image;
  String? email;
  String? userID;
  String? firebase_messaging_token;
  UserModel({this.email,this.userID,this.userName,this.image,this.phoneNumber,required this.firebase_messaging_token});

  // NamedConstructor => I will used it when i get Data from fireStore and save it on this model
  UserModel.fromJson(Map<String,dynamic> json){
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    image = json['image'];
    email = json['email'];
    userID = json['uid'];
    firebase_messaging_token = json['firebase_messaging_token'];
  }

  // TOJson  => I will used it when i want to  send data to cloud fireStore ( Fields )
  Map<String,dynamic> toJson(){
    return {
      'userName' : userName,
      'phoneNumber' : phoneNumber,
      'image' : image,
      'email' : email,
      'uid' : userID,
      'firebase_messaging_token' : firebase_messaging_token,
    };
  }
}