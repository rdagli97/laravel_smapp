import 'dart:convert' as convert;
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/models/comment_model.dart';
import 'package:laravel_smapp/services/shared_preference.dart';

class CommentService {
  // get comments of a post by postId {/posts/$postId/comments}
  Future<ApiResponse> getComments({
    required int postId,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          List<dynamic> commentJson = List.from(body['comments']);
          apiResponse.data =
              commentJson.map((e) => CommentModel.fromJson(e)).toList();
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

  // create a comment by postId {/posts/$postId/comments}
  Future<ApiResponse> createComment({
    required int postId,
    required String comment,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts/$postId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'comment': comment,
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = body['comment'];
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

  // delete a comment by commentId {/comments/$commentId}
  Future<ApiResponse> deleteComment({
    required int commentId,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/comments/$commentId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = body['message'];
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
}
