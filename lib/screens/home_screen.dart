import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/exceptions/app_exceptions.dart';
import 'package:social_media/models/app_data.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/screens/post_screen.dart';
import 'package:social_media/screens/user_profile_screen.dart';

class HomeScreen extends StatelessWidget {

  final appDataController = Get.put(AppData());//dependency injection
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  int? selectedUserId;
  final _formKey = GlobalKey<FormState>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Media'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Check the width of the screen
            bool isWide = constraints.maxWidth > 600;

            return Column(
              children: [
                Expanded(
                  child: Obx(
                    () {
                      if (appDataController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (appDataController.errorMessage.isNotEmpty) {
      
                        return Center(
                          child: Text(
                            appDataController.errorMessage.value,
                            style: const TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        );
                      } else {
                        //display posts if no error
                        return isWide
                            ? GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 0.7, 
                                ),
                                itemCount: appDataController.posts.length,
                                itemBuilder: (context, index) {
                                  final post = appDataController.posts[index];
                                  return Card(
                                    margin: const EdgeInsets.all(10),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Get.to(() => UserProfileScreen(userId: post.userId));
                                          },
                                          child: Text(
                                            'UserId: ${post.userId}',
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            post.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Text(
                                            post.body,
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.arrow_forward),
                                            onPressed: () {
                                              appDataController.comments.clear();
                                              Get.to(() => PostScreen(postId: post.id, index: index));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: appDataController.posts.length,
                                itemBuilder: (context, index) {
                                  final post = appDataController.posts[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Get.to(() => UserProfileScreen(userId: post.userId));
                                          },
                                          child: Text(
                                            'UserId: ${post.userId}',
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            post.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Text(
                                            post.body,
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.arrow_forward),
                                            onPressed: () {
                                              appDataController.comments.clear();
                                              Get.to(() => PostScreen(postId: post.id, index: index));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                      }
                    },
                  ),
                ),
                // Display loading indicator if post creation is in progress
                Obx(() {
                  if (appDataController.isPostCreationLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const SizedBox.shrink(); // No space when not loading
                  }
                }),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isDismissible: true,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Create New Post',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'User ID',
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(
                            10,
                            (index) => DropdownMenuItem(
                              value: index + 1,
                              child: Text('User ${index + 1}'),
                            ),
                          ),
                          onChanged: (value) {
                            selectedUserId = value;
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select user-id';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Title cannot be empty';
                            }
                            return null;
                          },
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Body cannot be empty';
                            }
                            return null;
                          },
                          controller: bodyController,
                          decoration: const InputDecoration(
                            labelText: 'Body',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                               
                                appDataController.isPostCreationLoading.value = true;

                                // Generate new ID
                                int newId = 1;
                                while (appDataController.posts.any((post) => post.id == newId)) {
                                  newId++;
                                }

                                // Create the PostModel
                                PostModel pm = PostModel(
                                  userId: selectedUserId!,
                                  id: newId,
                                  title: titleController.text,
                                  body: bodyController.text,
                                );

                                
                                await appDataController.createPost(pm);
                                Get.back();
                                Get.snackbar(
                                  'post',
                                  'Post created successfully',
                                );
                                // Clear controllers
                                titleController.clear();
                                bodyController.clear();
                                selectedUserId = null;
                              } on AppException catch (e) {
                            
                                Get.snackbar(
                                  "Error",
                                  e.message,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                // Handle any unexpected errors
                                Get.snackbar(
                                  "Error",
                                  "Something went wrong!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                              } finally {
                                // loading state reset to false
                                appDataController.isPostCreationLoading.value = false;
                              }
                            }
                          },
                          child: const Text('Create Post'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
