import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/comment_model.dart';
import 'package:social_media/models/app_data.dart';
import 'package:social_media/screens/user_profile_screen.dart';

class PostScreen extends StatelessWidget {
  final int postId;
  final int index;

  PostScreen({required this.postId, required this.index});

  @override
  Widget build(BuildContext context) {
    final AppData appDataController = Get.find<AppData>();

    // Load comments for the post when the widget is built
    appDataController.loadComments(postId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        // Show loading indicator if posts are loading
        if (appDataController.isLoading.value || appDataController.isCommentLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Get the specific post by index
        PostModel? post = appDataController.posts.length > index ? appDataController.posts[index] : null;

        if (post == null) {
          return Center(child: Text('Post not found.'));
        }

        // Display the post details and comments
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check screen width
              if (constraints.maxWidth > 600) {
                return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  padding: EdgeInsets.all(20),
                  children: [
                    postCard(post),
                    commentSection(appDataController),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    postCard(post),
                    SizedBox(height: 20),
                    Expanded( 
                      child: commentSection(appDataController),
                    ),
                  ],
                );
              }
            },
          ),
        );
      }),
    );
  }

  Widget postCard(PostModel post) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                Get.to(() => UserProfileScreen(userId: post.userId));
              },
              child: Text(
                'User ID: ${post.userId}',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            Text(
              post.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              post.body,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentSection(AppData appDataController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (appDataController.isCommentLoading.value)
          Center(child: CircularProgressIndicator()),
        Expanded(
          child: ListView.builder(
            itemCount: appDataController.comments.length,
            itemBuilder: (context, commentIndex) {
              CommentModel comment = appDataController.comments[commentIndex];
              return CommentCard(comment: comment);
            },
          ),
        ),
      ],
    );
  }
}

class CommentCard extends StatelessWidget {
  final CommentModel comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              comment.email,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(comment.body),
          ],
        ),
      ),
    );
  }
}
