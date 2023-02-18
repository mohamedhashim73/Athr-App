class PostModel{
  String? postMakerName;
  String? postMakerID;
  String? postMakerImage;
  String? postDate;
  String? postCaption;
  String? postImage;
  String? communityImage;
  String? communityName;
  String? communityID;
  String? communityAuthorID;
  // i will put postLink

  PostModel(this.postMakerName,this.postMakerID,this.postMakerImage,this.postCaption,this.postDate,this.postImage,this.communityName,this.communityID,this.communityImage,this.communityAuthorID);

  // Named Constructor to get Post Data from FireStore
  PostModel.fromJson({required Map<String,dynamic> json}){
    postMakerImage = json['postMakerImage'];
    postMakerID = json['postMakerID'];
    postMakerName = json['postMakerName'];
    postImage = json['postImage'];
    postDate = json['postDate'];
    postCaption = json['postCaption'];
    communityImage = json['communityImage'];
    communityName = json['communityName'];
    communityID = json['communityID'];
    communityAuthorID = json['communityAuthorID'];
  }

  // TOJson used it when i will sent data to fireStore
  Map<String,dynamic> toJson(){
    return {
      'postMakerName' : postMakerName,
      'postMakerID' : postMakerID,
      'postMakerImage' : postMakerImage,
      'postCaption' : postCaption,
      'postDate' : postDate,
      'postImage' : postImage,
      'communityImage' : communityImage,
      'communityID' : communityID,
      'communityName' : communityName,
      'communityAuthorID' : communityAuthorID,
    };
  }
}