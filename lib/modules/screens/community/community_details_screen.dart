import 'package:flutter/material.dart';
import 'package:simpleui/models/community_model.dart';
import 'package:simpleui/modules/screens/posts/create_post.dart';
import 'package:simpleui/shared/style/colors.dart';

class CommunityDetails extends StatelessWidget {
  final CommunityModel communityModel;
  final String communityID;
  const CommunityDetails({Key? key, required this.communityModel,required this.communityID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CreatePostScreen(communityAuthorID:communityModel.authorID!,communityID: communityID, communityName: communityModel.communityName!, communityImage: communityModel.communityImage!,)));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(communityModel.communityImage!)
                )
              ),
            )
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    communityModel.communityName!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.amber,
                        backgroundImage: NetworkImage(communityModel.authorImage!),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(child: Text('${communityModel.authorName!} |   ${communityModel.communityDate!}',overflow: TextOverflow.ellipsis,))
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(communityModel.communityDescription!)
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
