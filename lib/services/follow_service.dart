import 'dart:convert' as convert;
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:laravel_smapp/services/shared_preference.dart';

class FollowService {
  // Follow or Unfollow by userId {/users/$userId/follow}
  Future<ApiResponse> followOrUnfollow({
    required int userId,
  }) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/follow'),
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
        case 405:
          apiResponse.error = body['message'];
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
