class CommunityModel{
  String? authorName;
  String? authorID;
  String? authorFirebaseMessagingToken;
  String? authorImage;
  String? communityDate;
  String? communityName;
  String? communityDescription;
  String? communityImage;

  CommunityModel(this.authorFirebaseMessagingToken,this.authorName,this.authorID,this.authorImage,this.communityName,this.communityDate,this.communityImage,this.communityDescription);

  // Named Constructor to get Post Data from FireStore
  CommunityModel.fromJson({required Map<String,dynamic> json}){
    authorImage = json['userImage'];
    authorID = json['userID'];
    authorFirebaseMessagingToken = json['authorFirebaseMessagingToken'];
    authorName = json['authorName'];
    communityImage = json['postImage'];
    communityDate = json['communityDate'];
    communityName = json['communityName'];
    communityDescription = json['communityDescription'];
  }

  // TOJson used it when i will sent data to fireStore
  Map<String,dynamic> toJson(){
    return {
      'authorName' : authorName,
      'userID' : authorID,
      'authorFirebaseMessagingToken' : authorFirebaseMessagingToken,
      'userImage' : authorImage,
      'communityName' : communityName,
      'communityDescription' : communityDescription,
      'communityDate' : communityDate,
      'postImage' : communityImage,
    };
  }
}