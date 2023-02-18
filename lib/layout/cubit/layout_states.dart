abstract class LayoutStates{}

class InitialAppState extends LayoutStates{}

class ChangeBottomNavIndexState extends LayoutStates{}

class ChangeJoinCommunityShownState extends LayoutStates{}

// for get my data

class GetUserDataLoadingState extends LayoutStates{}

class GetUserDataSuccessState extends LayoutStates{}

class GetUserDataErrorState extends LayoutStates{}

class LogOutLoadingState extends LayoutStates{}

// for get users data to show in chat screen and search for a user using it

class GetUsersDataSuccessState extends LayoutStates{}

// for update my data either profileImage , name , email , bio , website link

class GetProfileImageLoadingState extends LayoutStates{}

class GetProfileImageSuccessState extends LayoutStates{}

class GetProfileImageErrorState extends LayoutStates{}

class UpdateUserDataWithoutImageLoadingState extends LayoutStates{}

class UpdateUserDataWithoutImageSuccessState extends LayoutStates{}

class UpdateUserDataWithoutImageErrorState extends LayoutStates{}

class UpdateUserDataWithImageLoadingState extends LayoutStates{}

class UpdateUserDataWithImageErrorState extends LayoutStates{}

class ErrorDuringOpenWebsiteUrlState extends LayoutStates{}

class UploadUserImageErrorState extends LayoutStates{}

class CanceledUpdateUserDataState extends LayoutStates{}

class ChosenImageSuccessfullyState extends LayoutStates{}

class ChosenImageErrorState extends LayoutStates{}

// for Create new post || update post || delete post

class SelectCommunityImageErrorState extends LayoutStates{}
class SelectCommunityImageSuccessState extends LayoutStates{}

// Todo: create community || delete it
class CreateMyCommunityLoadingState extends LayoutStates{}
class CreateMyCommunitySuccessfullyState extends LayoutStates{}
class FailedToCreateMyCommunityState extends LayoutStates{}

class DeleteCommunityLoadingState extends LayoutStates{}
class DeleteCommunitySuccessfullyState extends LayoutStates{}
class FailedToDeleteCommunityState extends LayoutStates{final String error; FailedToDeleteCommunityState({required this.error});}


class FailedToAddToJoinedCommunityState extends LayoutStates{}
class AddToJoinedCommunitySuccessfullyState extends LayoutStates{}
class AddToJoinedCommunityLoadingState extends LayoutStates{}

class LeaveCommunityLoadingState extends LayoutStates{}
class LeaveCommunitySuccessfullyState extends LayoutStates{}
class LeaveCommunityWithErrorState extends LayoutStates{ final String error; LeaveCommunityWithErrorState({required this.error});}

class GetOtherCommunitiesSuccessState extends LayoutStates{}
class GetOtherCommunitiesErrorState extends LayoutStates{}
class GetOtherCommunitiesLoadingState extends LayoutStates{}

class UpdateCommunityLoadingState extends LayoutStates{}

class UpdateCommunitySuccessfullyState extends LayoutStates{}

class UpdatePostErrorState extends LayoutStates{}

class CanceledCommunityImageState extends LayoutStates{}

// for get All Communities for all users

class GetMyCommunitiesLoadingState extends LayoutStates{}
class GetMyCommunitiesSuccessState extends LayoutStates{}
class GetMyCommunitiesErrorState extends LayoutStates{}
class GetJoinedCommunitiesLoadingState extends LayoutStates{}
class GetJoinedCommunitiesSuccessState extends LayoutStates{}
class GetJoinedCommunitiesErrorState extends LayoutStates{}
class FilteredOtherCommunitiesSuccessState extends LayoutStates{}
class FilteredOtherCommunitiesLoadingState extends LayoutStates{}

// for add a comment and like on post || delete it

class ChosenPostImageSuccessfullyState extends LayoutStates{}
class ChosenPostImageErrorState extends LayoutStates{}
class UploadPostWithoutImageLoadingState extends LayoutStates{}
class UploadPostWithImageLoadingState extends LayoutStates{}
class UploadPostWithoutImageSuccessState extends LayoutStates{}
class UploadPostWithImageErrorState extends LayoutStates{}
class UploadImageForPostErrorState extends LayoutStates{}
class CanceledImageForPostState extends LayoutStates{}



class DeletePostLoadingState extends LayoutStates{}
class DeletePostSuccessState extends LayoutStates{}
class DeletePostErrorState extends LayoutStates{}
class UpdatePostSuccessState extends LayoutStates{}
class UpdatePostLoadingState extends LayoutStates{}
class AddLikeSuccessfullyState extends LayoutStates{}

class AddLikeErrorState extends LayoutStates{}

class RemoveLikeSuccessfullyState extends LayoutStates{}

class RemoveLikeErrorState extends LayoutStates{}

class GetLikeStatusForMeOnSpecificPostLoadingState extends LayoutStates{}

class GetLikeStatusForMeOnSpecificPostSuccessState extends LayoutStates{}
class GetLikesLoadingState extends LayoutStates{}
class GetLikesSuccessfullyState extends LayoutStates{}

class GetCommentsLoadingState extends LayoutStates{}
class GetCommentsSuccessState extends LayoutStates{}
class GetCommentsErrorState extends LayoutStates{}
class DeleteCommentSuccessState extends LayoutStates{}
class AddCommentSuccessState extends LayoutStates{}
class FailedToAddCommentState extends LayoutStates{}
class FailedToDeleteCommentState extends LayoutStates{}

class FailedToGetJoinedPostsState extends LayoutStates{}
class GetJoinedPostsSuccessState extends LayoutStates{}
class GetAllPostsSuccessfullyState extends LayoutStates{}
class GetAllPostsLoadingState extends LayoutStates{}
class FailedToGetAllPostsState extends LayoutStates{}



