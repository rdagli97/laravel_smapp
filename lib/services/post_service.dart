import 'dart:convert' as convert;
import 'dart:developer' as developer;

import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/models/post_model.dart';
import 'package:laravel_smapp/services/shared_preference.dart';
import 'package:http/http.dart' as http;

class PostService {
  // get all post {/posts}
  Future<ApiResponse> getAllPosts() async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          List<dynamic> postJson = List.from(body['posts']);
          apiResponse.data =
              postJson.map((e) => PostModel.fromJson(e)).toList();
          developer.log(apiResponse.data.toString());
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // store a post {/posts}
  Future<ApiResponse> createPost(String body) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'body': body,
        },
      );

      final dynamic responseBody = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = responseBody['post'];
          developer.log(apiResponse.data.toString());
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }

    return apiResponse;
  }

  // delete a post {/posts/$postId}
  Future<ApiResponse> deletePost({
    required int postId,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = body['message'];
          developer.log(apiResponse.data.toString());
          break;
        case 404:
          apiResponse.error = body['message'];
          break;
        case 403:
          apiResponse.error = body['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // update a post {/posts/$postId}
  Future<ApiResponse> updatePost({
    required int postId,
    required String postBody,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'body': postBody,
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = body['post'];
          developer.log(apiResponse.data.toString());
          break;
        case 404:
          apiResponse.error = body['message'];
          break;
        case 403:
          apiResponse.error = body['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // get followings user's posts {/followings/posts}
  Future<ApiResponse> getFollowingUsersPosts() async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/followings/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          List<dynamic> postJson = List.from(body['posts']);
          apiResponse.data =
              postJson.map((e) => PostModel.fromJson(e)).toList();
          developer.log(apiResponse.data.toString());
          break;
        case 404:
          apiResponse.error = body['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // get current user's posts
  Future<ApiResponse> getCurrentUserPosts() async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/currentUser/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic body = convert.jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          List<dynamic> currentUserPostList = List.from(body['posts']);
          apiResponse.data =
              currentUserPostList.map((e) => PostModel.fromJson(e)).toList();
          break;
        case 404:
          apiResponse.error = body['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // get 1 users posts
  Future<ApiResponse> getOneUsersPosts({
    required int userId,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();
    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic body = convert.jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          List<dynamic> postList = List.from(body['posts']);
          apiResponse.data =
              postList.map((e) => PostModel.fromJson(e)).toList();
          break;
        case 404:
          apiResponse.error = body['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // get liked posts by userId
  Future<ApiResponse> getLikedPostsById({
    required int userId,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/likes/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final dynamic body = convert.jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          List<dynamic> postList = List.from(body['posts']);
          apiResponse.data =
              postList.map((e) => PostModel.fromJson(e)).toList();
          break;
        case 404:
          apiResponse.error = body['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // get liked posts by current user
  Future<ApiResponse> getLikedPostsByCurrentUser() async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/currentUser/likes/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          List<dynamic> postList = List.from(body['posts']);
          apiResponse.data =
              postList.map((e) => PostModel.fromJson(e)).toList();
          break;
        case 404:
          apiResponse.error = body['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
    }
    return apiResponse;
  }

  // get one post
  Future<ApiResponse> getOnePost(
    int postId,
  ) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer.log(response.body);

      final dynamic body = convert.jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          apiResponse.data = PostModel.fromJson(body);
          break;
        case 404:
          apiResponse.error = body['message'];
          break;
        case 401:
          apiResponse.error = unauthorized;
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = serverError;
      developer.log(e.toString());
    }
    return apiResponse;
  }
}
