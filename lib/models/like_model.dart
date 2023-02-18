class LikeModel{
  String? likeMakerID;
  String? likeMakerName;
  String? likeMakerImage;
  String? dateTime;
  bool? isLike;
  // Constructor
  LikeModel(this.likeMakerImage,this.likeMakerID,this.likeMakerName,this.dateTime,this.isLike);

  LikeModel.fromJson({required Map<String,dynamic> json}){
    likeMakerID = json['likeMakerID'];
    likeMakerName = json['likeMakerName'];
    likeMakerImage = json['likeMakerImage'];
    dateTime = json['dateTime'];
    isLike = json['isLike'];
  }

  Map<String,dynamic> toJson(){
    return {
      'likeMakerID' : likeMakerID,
      'likeMakerName' : likeMakerName,
      'likeMakerImage' : likeMakerImage,
      'dateTime' : dateTime,
      'isLike' : isLike,
    };
  }
}