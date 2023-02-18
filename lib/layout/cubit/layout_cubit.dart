import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simpleui/layout/cubit/layout_states.dart';
import 'package:simpleui/models/comment_model.dart';
import 'package:simpleui/models/community_model.dart';
import 'package:simpleui/models/like_model.dart';
import 'package:simpleui/models/post_model.dart';
import 'package:simpleui/modules/screens/certificates/certificates_screen.dart';
import 'package:simpleui/modules/screens/profile/profile_screen.dart';
import 'dart:io';
import '../../models/user_model.dart';
import '../../modules/screens/home/home_screen.dart';
import '../../shared/constants.dart';
import '../../shared/network/local_network.dart';
import 'package:http/http.dart' as http;

class LayoutCubit extends Cubit<LayoutStates>{
  LayoutCubit() : super(InitialAppState());

  // Todo: get instance from this cubit
  static LayoutCubit getInstance(BuildContext context) => BlocProvider.of<LayoutCubit>(context);

  // Todo: Method for changeBottomNavIndex
  int bottomNavIndex = 0;
  void changeBottomNavIndex(int index){
    bottomNavIndex = index;
    emit(ChangeBottomNavIndexState());
  }

  List<Widget> layoutScreens = [ const HomeScreen() , const ProfileScreen() , const CertificatesScreen()];

  // Todo: get My Data to show in Profile screen and use it in other screens
  UserModel? userData;
  Future<void> getMyData() async {
    await FirebaseFirestore.instance.collection("users").doc(CacheHelper.getCacheData(key: 'uid')??userID).get().then((value){
      userData = UserModel.fromJson(value.data()!);
      emit(GetUserDataSuccessState());
    });
  }

  // Todo : log out
  dynamic logOut() async {
    emit(LogOutLoadingState());
    bool clearCache = await CacheHelper.clearCache();
    if( clearCache )
      {
        userData = null ;
        postsData.clear();
        postsID.clear();
        myCommunitiesData.clear();
        myCommunitiesID.clear();
        joinedCommunitiesID.clear();
      }
    return clearCache? true : false;
  }

  File? userImageFile;
  Future<void> getUserImage() async{
    emit(GetProfileImageLoadingState());
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if(pickedImage != null)
    {
      userImageFile = File(pickedImage.path);
      emit(ChosenImageSuccessfullyState());
    }
    else
    {
      emit(ChosenImageErrorState());
    }
  }

  void updateUserDataWithoutImage({required String email,required String phoneNumber,required String userName,String? image}){
    emit(UpdateUserDataWithoutImageLoadingState());
    final model = UserModel(image: image?? userData!.image,email: email,phoneNumber: phoneNumber,userName: userName,userID: userData!.userID,firebase_messaging_token: firebase_messaging_token);
    FirebaseFirestore.instance.collection('users').doc(userData!.userID)
        .update(model.toJson())
        .then((value){
      getMyData();  // هنا مش عارف المشكله بتاعه اما ارفع الداتا اللي كان مكتوب داخل textFormField بيتغير وبيأخد الحاجه القديمه عما يخرج من صفحه update
      emit(UpdateUserDataWithoutImageSuccessState());
    }).catchError((e){
      emit(UpdateUserDataWithoutImageErrorState());
    });
  }

  void updateUserDataWithImage({required String email,required String phoneNumber,required String userName}){
    emit(UpdateUserDataWithImageLoadingState());
    FirebaseStorage.instance.ref()
        .child("users/${Uri.file(userImageFile!.path).pathSegments.last}")
        .putFile(userImageFile!)
        .then((val){
      val.ref.getDownloadURL().then((imageUrl){
        // upload Update for userData to FireStore
        updateUserDataWithoutImage(email: email, phoneNumber: phoneNumber, userName: userName,image: imageUrl);
      }).catchError((onError){
        emit(UploadUserImageErrorState());
      });
    }).catchError((error){emit(UpdateUserDataWithImageErrorState());});
  }

  //Todo : made this function as if i change profile photo but canceled update imageProfileUrl will show on EditProfileScreen as i canceled update and i use profileImageUrl to be shown not userData!.image
  void canceledUpdateUserData(){
    emit(CanceledUpdateUserDataState());
  }

  // Todo: get Image for Community on Create Community Screen
  File? communityImageFile;
  void getCommunityImage() async{
    final pickedPostImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if( pickedPostImage != null )
    {
      communityImageFile = File(pickedPostImage.path);
      emit(SelectCommunityImageSuccessState());
    }
    else
    {
      emit(SelectCommunityImageSuccessState());
    }
  }

  // Todo: create Community Method
  void createMyCommunity({required String communityName,required String communityDescription}){
    emit(CreateMyCommunityLoadingState());
    FirebaseStorage.instance.ref()
        .child("communities/${Uri.file(communityImageFile!.path).pathSegments.last}")
        .putFile(communityImageFile!)
        .then((value){
      value.ref.getDownloadURL().then((imageUrl) async {
        final model = CommunityModel(userData!.firebase_messaging_token,userData!.userName, userData!.userID, userData!.image,communityName,timeNow,imageUrl,communityDescription);
        debugPrint("Community's image added successfully $imageUrl");
        // Todo: my own communities mean which I have created not joined
        await FirebaseFirestore.instance.collection('users').doc(userID ?? userData!.userID).collection('own_communities').add(model.toJson());
        await FirebaseMessaging.instance.subscribeToTopic("${communityName}${userData!.userID??userID}");   // Todo: to get notifications when anyone else add a new post on this community
        await getMyAllCommunitiesData();
        emit(CreateMyCommunitySuccessfullyState());
      });
    }).catchError((onError) {emit(FailedToCreateMyCommunityState());}
    );
  }

  // Todo: delete my community using its ID
  Future<void> deleteCommunity({required String communityID,required String communityName}) async {
    emit(DeleteCommunityLoadingState());
    try {
      await FirebaseFirestore.instance.collection('users').doc(userID ?? userData!.userID).collection('own_communities').doc(communityID).delete();
      await FirebaseMessaging.instance.unsubscribeFromTopic("${communityName}${userData!.userID??userID}");
      await getMyAllCommunitiesData();
      emit(DeleteCommunitySuccessfullyState());
    }
    catch(e){
      emit(FailedToDeleteCommunityState(error: e.toString()));
    }
  }

  // Todo: add community to joined communities (( I will get The ID for Community throw communitiesID variable when i click on it ))
  void addToJoinedCommunity({required CommunityModel communityModel,required String communityID}) async {
    joinedCommunitiesID.add(communityID);
    sendNotificationAfterJoinCommunity(
        receiverFirebaseMessagingToken: communityModel.authorFirebaseMessagingToken!,
        communityID: communityID,
        communityModel: communityModel
    );
    emit(AddToJoinedCommunityLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(userID??userData!.userID).collection('joined_communities').doc(communityID).set(communityModel.toJson()).catchError((error) {emit(FailedToAddToJoinedCommunityState());});
    await FirebaseMessaging.instance.subscribeToTopic("${communityModel.communityName!}${communityModel.authorID}");     // Todo: use it to get notifications after anyone create post on this community
    await getMyAllCommunitiesData();
    emit(AddToJoinedCommunitySuccessfullyState());
  }

  // Todo: add community to joined communities (( I will get The ID for Community throw communitiesID variable when I click on it))
  Future<void> leaveCommunity({required String communityID,required String communityName,required String communityAuthorID}) async {
    emit(LeaveCommunityLoadingState());
    try{
      await FirebaseFirestore.instance.collection('users').doc(userID??userData!.userID)
          .collection('joined_communities').doc(communityID).delete();
      joinedCommunitiesID.remove(communityID);  // Todo: to delete Community ID from Set(joinedCommunitiesID)
      await FirebaseMessaging.instance.unsubscribeFromTopic("${communityName}${communityAuthorID}");
      await getMyAllCommunitiesData();
      emit(LeaveCommunitySuccessfullyState());
    }
    catch(e){
      emit(LeaveCommunityWithErrorState(error: e.toString()));
    }
  }

  void updateCommunity({required CommunityModel model,required String communityID}) async {
    emit(UpdateCommunityLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(userID ?? userData!.userID).
    collection('own_communities').doc(communityID).update(model.toJson());
    await getMyAllCommunitiesData();
    emit(UpdateCommunitySuccessfullyState());
  }

  void canceledCommunityImage(){
    communityImageFile = null;
    emit(CanceledCommunityImageState());
  }

  // Todo: get Joined communities to use it under when I get MyAllCommunities
  List<CommunityModel> myCommunitiesData = [];
  List<String> myCommunitiesID = [];
  Future<void> getMyJoinedCommunitiesData () async {
    myCommunitiesData.clear();
    myCommunitiesID.clear();
    await getJoinedCommunitiesID();
    await FirebaseFirestore.instance.collection('users').get().then((usersDocs){
      for (var userDoc in usersDocs.docs) {
        if( userDoc.id != userID )
        {
          userDoc.reference.collection('own_communities').get().then((items){
            for (var communityItem in items.docs)
            {
              if( joinedCommunitiesID.contains(communityItem.id) )     // Todo: this mean that this community on my joined_communities
              {
                myCommunitiesData.add(CommunityModel.fromJson(json: communityItem.data()));
                myCommunitiesID.add(communityItem.id);
              }
            }
            emit(GetJoinedCommunitiesSuccessState());
          });
        }
      }
    }).catchError((error){
      emit(GetJoinedCommunitiesErrorState());
    });
  }

  // Todo: This contain own communities with communities that I have joined to display on Home Screen
  Future<void> getMyAllCommunitiesData() async {
    await getMyJoinedCommunitiesData();    // Todo : to display my own communities beside the communities that i have joined
    emit(GetMyCommunitiesLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(userID??userData!.userID).collection('own_communities').get().then((value) async {
      for (var communityItem in value.docs)
      {
        myCommunitiesData.add(CommunityModel.fromJson(json: communityItem.data()));
        myCommunitiesID.add(communityItem.id);
      }
      postsData.clear();
      postsID.clear();
      await getMyAllPostsData();
      emit(GetMyCommunitiesSuccessState());
    }).catchError((error){
      debugPrint("Error reason : $error");
      emit(GetMyCommunitiesErrorState());
    });
  }


  // Todo : related t add like || remove || get it
  void addLike({required String communityID,required String postMakerID,required String postID,required String communityAuthorID}) async {
    final model = LikeModel(userData!.image,userData!.userID,userData!.userName,timeNow,true);
    await FirebaseFirestore.instance.collection('users').doc(communityAuthorID)
        .collection('own_communities').doc(communityID).collection('posts').doc(postID).collection('likes')
        .doc(userID??userData!.userID).set(model.toJson());
  }

  void removeLike({required String communityID,required String postMakerID,required String postID,required String communityAuthorID}) async {
    await FirebaseFirestore.instance.collection('users').doc(communityAuthorID)
        .collection('own_communities').doc(communityID).collection('posts').doc(postID).collection('likes')
        .doc(userID??userData!.userID).delete();
  }

  // Todo: Add a comment to specific post on specific community
  void addComment({required String comment,required PostModel postModel,required String postID}) async {
    try{
      final commentModel = CommentModel(comment, userID ?? userData!.userID, userData!.image, userData!.userName, timeNow, postID);
      await FirebaseFirestore.instance.collection('users').doc(postModel.communityAuthorID)
          .collection('own_communities').doc(postModel.communityID).collection('posts').doc(postID).collection('comments').add(commentModel.toJson());
      await getAllComments(communityAuthorID: postModel.communityAuthorID!,communityID: postModel.communityID!,postID: postID);
      emit(AddCommentSuccessState());
    }
    catch(error){
      emit(FailedToAddCommentState());
    }
  }

  List<CommentModel> comments = [];
  List<String> commentsID = [];
  Future<void> getAllComments({required String communityID,required String communityAuthorID,required String postID}) async {
    comments.clear();
    commentsID.clear();
    emit(GetCommentsLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(communityAuthorID)
        .collection('own_communities').doc(communityID).collection('posts').doc(postID).collection('comments').get().then((value){
          for( var commentItem in value.docs )
            {
              commentsID.add(commentItem.id);
              comments.add(CommentModel.fromJson(json: commentItem.data()));
            }
    }).catchError((e){
      debugPrint("Error during get comments, reason : ${e.toString()}");
      emit(GetCommentsErrorState());
    });
    emit(GetCommentsSuccessState());
  }

  Future<void> deleteComment({required PostModel postModel,required String commentID,required String postID}) async {
    await FirebaseFirestore.instance.collection('users').doc(postModel.communityAuthorID)
        .collection('own_communities').doc(postModel.communityID).collection('posts').doc(postID).collection('comments')
        .doc(commentID).delete().then((value){
          emit(DeleteCommentSuccessState());
    }).catchError((e){
      emit(FailedToDeleteCommentState());
    });
    await getAllComments(communityID: postModel.communityID!, communityAuthorID: postModel.communityAuthorID!, postID: postID);
  }

  // Todo: get likes Data to display it on LikesViewScreen
  List<LikeModel> likesData = [];
  void getLikesForSpecificPost({required String communityID,required String postMakerID,required String postID,required String communityAuthorID}) async {
    likesData.clear();
    emit(GetLikesLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(communityAuthorID)
        .collection('own_communities').doc(communityID).collection('posts').doc(postID).collection('likes').get().then((value){
          for (var element in value.docs)
          {
            likesData.add(LikeModel.fromJson(json: element.data()));
          }
      emit(GetLikesSuccessfullyState());
    }).catchError((e) {
      debugPrint("Error during get likes and the reason is : $e");
    });
  }

  Future<void> deletePost({required String communityID,required String postMakerID,required String postID,required String communityAuthorID}) async {
    try{
      emit(DeletePostLoadingState());
      await FirebaseFirestore.instance.collection('users').doc(communityAuthorID)
          .collection('own_communities').doc(communityID)
          .collection('posts').doc(postID).delete();
      await getMyAllPostsData();    // Todo: need to change it ti get posts
      emit(DeletePostSuccessState());
    }
    catch(e){
      emit(DeletePostErrorState());
    }
  }

  Future<void> updatePost({required String communityID,required String postMakerID,required String postID,required String communityAuthorID,required PostModel model}) async {
    emit(UpdatePostLoadingState());
    try{
      await FirebaseFirestore.instance.collection('users').doc(communityAuthorID)
          .collection('own_communities').doc(communityID).collection('posts').doc(postID).update(model.toJson());
      await getMyAllPostsData();
      emit(UpdatePostSuccessState());
    }
    catch(e){
      debugPrint("Error during update Post, reason : $e");
      emit(UpdatePostErrorState());
    }
  }

  // Todo: get other communities to display on search screen
  List<CommunityModel> otherCommunitiesData = [];
  List<String> otherCommunitiesID = [];
  Future<void> getOtherCommunities({required String input}) async {
    otherCommunitiesID.clear();
    otherCommunitiesData.clear();
    emit(GetOtherCommunitiesLoadingState());
    try
    {
      await FirebaseFirestore.instance.collection('users').get().then((usersDocs){
        otherCommunitiesID.clear();
        otherCommunitiesData.clear();
        for (var userDoc in usersDocs.docs) {
          if( userDoc.id != userID )
          {
            userDoc.reference.collection('own_communities').get().then((communityDocs){
              for (var communityDoc in communityDocs.docs) {
                if( communityDoc.data()['communityName'].toString().toLowerCase().startsWith(input) )
                  {
                    otherCommunitiesData.add(CommunityModel.fromJson(json: communityDoc.data()));
                    otherCommunitiesID.add(communityDoc.id);
                    emit(GetOtherCommunitiesSuccessState());
                  }
              }
            });
          }
        }
      });
      debugPrint(otherCommunitiesData.length.toString());
    }
    catch(exception){
      debugPrint("Error during get other communities, reason : $exception");
      emit(GetOtherCommunitiesErrorState());
    }
  }

  // Todo: related to Posts || likes on it
  File? postImageFile;
  void getPostImage() async{
    final pickedPostImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if( pickedPostImage != null )
    {
      postImageFile = File(pickedPostImage.path);
      emit(ChosenPostImageSuccessfullyState());
    }
    else
    {
      emit(ChosenPostImageErrorState());
    }
  }

  Future<void> createPostWithoutImage({required String postCaption,String? postImage,required String communityName,
    required String communityID,required String communityImage,required String communityAuthorID}) async {
    emit(UploadPostWithoutImageLoadingState()); // loading
    final model = PostModel(userData!.userName, userData!.userID, userData!.image,postCaption,timeNow.toString(),postImage?? "",communityName,communityID,communityImage,communityAuthorID);
    if( communityAuthorID == userID )
      {
        await FirebaseFirestore.instance.collection('users').doc(userID?? userData!.userID).collection('own_communities').doc(communityID).collection('posts').add(model.toJson());
      }
    else
      {
        await FirebaseFirestore.instance.collection('users').doc(communityAuthorID).collection('own_communities').doc(communityID).collection('posts').add(model.toJson());
      }
    // Todo: Send a Notification if I am not the Author for This Community
    if( userID != communityAuthorID ) sendNotifyAfterAddPost(communityID,communityAuthorID, communityName, communityImage);
    await getMyAllPostsData();
    emit(UploadPostWithoutImageSuccessState());
  }

  void createPostWithImage({required String postCaption,required String communityName,required String communityID,required String communityImage,required String communityAuthorID}) async {
    emit(UploadPostWithImageLoadingState());   // loading
    await FirebaseStorage.instance.ref()
        .child("posts/${Uri.file(postImageFile!.path).pathSegments.last}")
        .putFile(postImageFile!)
        .then((value){
      value.ref.getDownloadURL().then((imageUrl) async {
        debugPrint("New post image added $imageUrl");
        await createPostWithoutImage(postCaption: postCaption,postImage: imageUrl,communityID: communityID,communityImage: communityImage,communityName: communityName,communityAuthorID: communityAuthorID);
      }).catchError((e){
        debugPrint("Error during upload post Image => ${e.toString()}");
        emit(UploadImageForPostErrorState());  // error during upload postImage not totally Post
      });
    }).catchError((onError) {emit(UploadPostWithImageErrorState());});
  }

  void canceledPostImage(){
    postImageFile = null;
    emit(CanceledImageForPostState());
  }

  // Todo: get joinedCommunities ID to use in get posts that on this community
  Set<String> joinedCommunitiesID = {};
  Future<void> getJoinedCommunitiesID() async {
    await FirebaseFirestore.instance.collection('users').doc(userID??userData!.userID).collection('joined_communities').get().then((value){
      for (var element in value.docs)
      {
        joinedCommunitiesID.add(element.id);
      }
      debugPrint("Joined communities ID is ................ $joinedCommunitiesID");
    });
  }

  // Todo: get All Posts ( include my posts from my communities and other communities which i follow )
  List<PostModel> postsData = [];
  List<String> postsID = [];
  Map<String,bool> likesStatus = {};  // Todo: store postID as a key and status as a value
  // Todo: This contain own communities with communities that I have joined to display on Home Screen
  Future<void> getMyAllPostsData() async {
    postsData.clear();
    postsID.clear();
    likesStatus.clear();
    await getJoinedCommunitiesID();
    emit(GetAllPostsLoadingState());
    await FirebaseFirestore.instance.collection('users').get().then((value) async {
      for (var val in value.docs) {
        if( val.id != userID )
        {
          await val.reference.collection('own_communities').get().then((value){
            for (var val in value.docs)
            {
              if( joinedCommunitiesID.contains(val.id) )
              {
                val.reference.collection('posts').get().then((items){
                  for( var item in items.docs )
                  {
                    debugPrint("... Post added to joined posts success ...");
                    postsData.add(PostModel.fromJson(json: item.data()));
                    postsID.add(item.id);
                    emit(GetJoinedPostsSuccessState());
                    item.reference.collection('likes').get().then((value){
                      for (var val in value.docs)
                      {
                        if( val.id == userID ) likesStatus.addAll({item.id : true});
                      }
                    });
                  }
                });
              }
            }
          }).catchError((error){
            debugPrint("error during get joined posts, reason : $error");
            emit(FailedToGetJoinedPostsState());
          });
        }
        if( val.id == userID )
        {
          await val.reference.collection('own_communities').get().then((value){
            for (var element in value.docs)
            {
              element.reference.collection('posts').get().then((items){
                for (var item in items.docs)
                {
                  item.reference.collection('likes').get().then((value)
                  {
                    if( value.docs.isNotEmpty )
                    {
                      for (var element in value.docs)
                      {
                        if( element.id == userID ) likesStatus.addAll({item.id : true});  // Todo: item.id == postID
                        postsData.add(PostModel.fromJson(json: item.data()));
                        postsID.add(item.id);
                      }
                    }
                    else
                    {
                      postsData.add(PostModel.fromJson(json: item.data()));
                      postsID.add(item.id);
                    }
                  });
                }
              });
            }
          });
        }
      }
      emit(GetAllPostsSuccessfullyState());
    }).catchError((error){
      emit(FailedToGetAllPostsState());
    });
  }

  // Todo: Send Notification to Community's author after anyone join to his community
  Future<void> sendNotificationAfterJoinCommunity({required String receiverFirebaseMessagingToken,required communityID,required CommunityModel communityModel}) async {
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        'Content-Type' : "application/json",
        // Todo: Authorization to know from App will send Notifications
        'Authorization' : "key=AAAAZFCracs:APA91bFst8il3hmARx8In4PTVFBKePI2cM7JSob9wewr5rW-rkYjYlkQuikPJ9KEdUY0BH-t1eHsizKH2oprEbpEY47mYOAMzppjUbJsSyE6vWkMIoeKAUYohz9_L1oe7PR6p6hshsnc"
      },
      body:{
        {
          "to": receiverFirebaseMessagingToken,  // Todo: receiverFirebaseMessagingToken == firebase_messaging_token for community's author
          "notification": {
            "title": "New Follower",
            "body": "${userData!.userName!} start following your %${communityModel.communityName} Community",
            "image": userData!.image!,
            "mutable_content": true,
            "sound": "Tri-tone"
          },
          "data": {
            "type" : "Notification after ${userData!.userName} followed your ${communityModel.communityName} community",
            "senderName": userData!.userName!,
            "senderID": userData!.userID!,
            "communityID": communityID
          }
        }
      }
    );
  }

  // Todo: send a notification for all users who join to a specific community after adding a post on this community
  Future<void> sendNotifyAfterAddPost(String communityID,String communityAuthorID,String communityName,String communityImage) async {
    String topicName = "${communityName}${communityAuthorID}";     // Todo: to avoid create more than one community with the same name
    await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          'Content-Type' : "application/json",
          // Todo: Authorization to know from App will send Notifications
          'Authorization' : "key=AAAAZFCracs:APA91bFst8il3hmARx8In4PTVFBKePI2cM7JSob9wewr5rW-rkYjYlkQuikPJ9KEdUY0BH-t1eHsizKH2oprEbpEY47mYOAMzppjUbJsSyE6vWkMIoeKAUYohz9_L1oe7PR6p6hshsnc"
        },
        body:{
          {
            // Todo: I used communityID as The Topic that users subscribe to it.
            "to": "/topics/$topicName",  // Todo: receiver token == firebase_messaging_token for community's author
            "notification": {
              "title": "New Post",
              "body": "${userData!.userName} add a new Post on %$communityName Community",
              "image": communityImage,
              "mutable_content": true,
              "sound": "Tri-tone"
            },
            "data": {
              "senderName": userData!.userName!,
              "communityID": communityID,
              "communityAuthorID" : communityAuthorID,
              "click_action" : "FLUTTER_NOTIFICATION_CLICK"
            }
          }
        }
    );
  }
}