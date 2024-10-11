import 'package:get/get.dart';
import 'package:social_media/api/api_service.dart';
import 'package:social_media/exceptions/app_exceptions.dart';
import 'package:social_media/models/comment_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/user_model.dart';

class AppData extends GetxController {
  var posts = <PostModel>[].obs;
  var isLoading = false.obs;
  var comments = <CommentModel>[].obs;
  var isCommentLoading = false.obs;
  var isPostCreationLoading = false.obs;
  var user = UserModel(
    id: 0,
    name: '',
    username: '',
    email: '',
    address: null,
    phone: '',
    website: '',
    company: null,
  ).obs;
  var isUserLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  // Load posts
  Future<void> loadPosts() async {
    try {
      isLoading(true);
      var postsList = await ApiService().fetchPost();
      posts.assignAll(postsList);
    } on NetworkException {
      errorMessage.value = 'Failed to load posts. Check your internet connection.';
      Get.snackbar('Network Error', errorMessage.value);
    } catch (e) {
      errorMessage.value = 'Error loading posts: $e';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // Load comments for a post
  Future<void> loadComments(int postId) async {
    try {
      isCommentLoading(true);
      var commentsList = await ApiService().fetchComments(postId);
      comments.assignAll(commentsList);
    } on NetworkException {
      Get.snackbar('Network Error', 'Failed to load comments. Check your internet connection.');
    } on ResourceNotFoundException {
      Get.snackbar('Not Found', 'The comments for the post are unavailable.');
    } catch (e) {
      Get.snackbar('Error', 'Error loading comments: $e');
    } finally {
      isCommentLoading(false);
    }
  }

  // Load user data by ID
  Future<void> loadUserById(int userId) async {
    isUserLoading(true);
    try {
      var fetchedUser = await ApiService().fetchUserById(userId);
      user.value = fetchedUser;
    } on NetworkException {
      Get.snackbar('Network Error', 'Failed to load user. Check your internet connection.');
    } on ResourceNotFoundException {
      Get.snackbar('User Not Found', 'No user found with the given ID.');
    } catch (e) {
      Get.snackbar('Error', 'Error loading user: $e');
    } finally {
      isUserLoading(false);
    }
  }

  // Create a new post
  Future<void> createPost(PostModel post) async {
    isPostCreationLoading(true);
    try {
      var newPost = await ApiService().createPost(post);
      posts.add(newPost);
     
    } on NetworkException {
      Get.snackbar('Network Error', 'Failed to create post. Check your internet connection.');
    } catch (e) {
      Get.snackbar('Error', 'Error creating post: $e');
    } finally {
      isPostCreationLoading(false);
    }
  }
}
