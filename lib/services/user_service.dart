import 'dart:convert' as convert;
import 'dart:developer' as developer;

import 'package:laravel_smapp/consts/global_variables.dart';
import 'package:laravel_smapp/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_smapp/models/user_model.dart';
import 'package:laravel_smapp/services/shared_preference.dart';

class UserService {
  // login

  Future<ApiResponse> login(String email, String password) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      final dynamic body = convert.jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          apiResponse.data = UserModel.fromJson(body);
          break;
        case 422:
          final errors = body['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          developer.log(apiResponse.error.toString());
        case 403:
          apiResponse.error = body['message'];
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

  // register
  Future<ApiResponse> register(
    String email,
    String username,
    String password,
    String image,
  ) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'username': username,
          'password': password,
          'password_confirmation': password,
          'image': image,
        },
      );

      developer.log('Status code : ${response.statusCode}');
      developer.log('Response body : ${response.body}');

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = UserModel.fromJson(body);
          break;
        case 422:
          final errors = convert.jsonDecode(response.body)['errors'];
          apiResponse.error = errors[errors.keys.elementAt(0)][0];
          developer.log(apiResponse.error.toString());
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

  // get current user details
  Future<ApiResponse> getUserDetails() async {
    ApiResponse apiResponse = ApiResponse();

    try {
      String token = await SharedPreference().getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = UserModel.fromJson(body['user']);
          break;
        case 404:
          apiResponse.error = body['message'];
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

  // update user
  Future<ApiResponse> updateUser(String image) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      String token = await SharedPreference().getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'image': image,
        },
      );

      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = body['message'];
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

  // get following users
  Future<ApiResponse> getFollowingUsers(int userId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      String token = await SharedPreference().getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/followings'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer.log("body: ${response.body}");
      final dynamic body = convert.jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          List<dynamic> userList = List.from(body['users']);
          developer.log("body['user'] : ${List.from(body['users'])}");
          apiResponse.data =
              userList.map((e) => UserModel.fromJson(e)).toList();
          break;
        case 405:
          apiResponse.error = body['message'];
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

  // get follower users
  Future<ApiResponse> getFollowerUsers(int userId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      String token = await SharedPreference().getToken();
      final response = await http
          .get(Uri.parse('$baseUrl/users/$userId/followers'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      final dynamic body = convert.jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          List<dynamic> followerUsers = List.from(body['users']);
          apiResponse.data =
              followerUsers.map((e) => UserModel.fromJson(e)).toList();
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

  // get user by id
  Future<ApiResponse> getUserById(int userId) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final dynamic body = convert.jsonDecode(response.body);
      switch (response.statusCode) {
        case 200:
          apiResponse.data = UserModel.fromJson(body['user']);
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

  // get user's followers ids
  Future<ApiResponse> getFollowerIdsByUserId(int userId) async {
    ApiResponse apiResponse = ApiResponse();
    String? token;
    token = await SharedPreference().getToken();

    if (token == '') {
      developer.log(nullToken);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId/followerIds'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final dynamic body = convert.jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
          List<dynamic> followerIdsJson = List.from(body['follower_ids']);
          apiResponse.data = followerIdsJson.map((e) => e as int).toList();
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
