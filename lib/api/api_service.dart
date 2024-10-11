import 'package:dio/dio.dart';
import 'package:social_media/exceptions/app_exceptions.dart';
import 'package:social_media/exceptions/app_exceptions.dart';
import 'package:social_media/models/comment_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/user_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<PostModel>> fetchPost() async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      return (response.data as List).map((post) => PostModel.fromMap(post)).toList();
    } on DioException catch (dioException) {
      handleError(dioException);
      throw Exception('Failed to load posts'); 
    }
  }

  Future<List<CommentModel>> fetchComments(int postId) async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/comments?postId=$postId');
      return (response.data as List).map((comment) => CommentModel.fromMap(comment)).toList();
    } on DioException catch (dioException) {
      handleError(dioException);
      throw Exception('Failed to load comments'); 
    }
  }

  Future<UserModel> fetchUserById(int userId) async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/users');
      final users = (response.data as List).map((user) => UserModel.fromMap(user)).toList();
      return users.firstWhere((user) => user.id == userId);
    } on DioException catch (dioException) {
      handleError(dioException);
      throw Exception('Failed to load user'); 
    }
  }

  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await _dio.post('https://jsonplaceholder.typicode.com/posts', data: post.toMap());
      return PostModel.fromMap(response.data);
    } on DioException catch (dioException) {
      handleError(dioException);
      throw Exception('Failed to create post'); 
    }
  }

  void handleError(DioException dioException) {
    if (dioException.type == DioExceptionType.connectionTimeout) {
      throw NetworkException('Connection timed out. Please try again.');
    } else if (dioException.type == DioExceptionType.receiveTimeout) {
      throw NetworkException('Server took too long to respond. Please try again.');
    } else if (dioException.type == DioExceptionType.badResponse) {
      switch (dioException.response?.statusCode) {
        case 400:
          throw InvalidFormatException('Invalid request sent to the server.');
        case 404:
          throw ResourceNotFoundException('Resource not found.');
        case 500:
          throw ServerException('Server error. Please try again later.');
        default:
          throw UnknownException('An unknown error occurred.');
      }
    } else {
      throw UnknownException('An error occurred. Please try again.');
    }
  }
}
