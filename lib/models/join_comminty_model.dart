class JoinCommunityModel{
  String? authorName;
  String? authorID;
  String? authorImage;
  String? communityDate;
  String? communityName;
  String? communityDescription;
  String? communityImage;
  String? communityID;

  JoinCommunityModel(this.authorName,this.authorID,this.authorImage,this.communityName,this.communityDate,this.communityImage,this.communityDescription,this.communityID);

  // Named Constructor to get Post Data from FireStore
  JoinCommunityModel.fromJson({required Map<String,dynamic> json}){
    authorImage = json['userImage'];
    authorID = json['userID'];
    authorName = json['userName'];
    communityImage = json['postImage'];
    communityDate = json['communityDate'];
    communityName = json['communityName'];
    communityDescription = json['communityDescription'];
    communityID = json['communityID'];
  }

  // TOJson used it when i will sent data to fireStore
  Map<String,dynamic> toJson(){
    return {
      'userName' : authorName,
      'userID' : authorID,
      'userImage' : authorImage,
      'communityName' : communityName,
      'communityDescription' : communityDescription,
      'communityDate' : communityDate,
      'postImage' : communityImage,
      'communityID' : communityID,
    };
  }
}