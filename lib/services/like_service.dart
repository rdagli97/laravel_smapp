import 'dart:convert' as convert;
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/services/shared_preference.dart';

class LikeService {
  // like or unlike a post by postId {/posts/$postId/likes}

  Future<ApiResponse> likeOrUnlike({
    required int postId,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts/$postId/likes'),
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
