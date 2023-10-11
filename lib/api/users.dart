import 'package:gitmatch/models/project.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/user.dart' as user;

class UsersAPI {
  Future<user.User> getUser(String id) async {
    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/users/records/$id");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var userData = user.User.fromJson(jsonResponse);
      return userData;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    throw Exception('Failed to load user');
  }

  Future<user.User> getUserFromProfileId(String id) async {
    final queryParams = {
      'expand': 'users(profile)',
    };

    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/profiles/records/$id", queryParams);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var userData =
          user.User.fromJson(jsonResponse["expand"]["users(profile)"][0]);
      return userData;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    throw Exception('Failed to load user');
  }

  Future<bool> patchUserWithInterestedUser(
      String userId, String interestedId) async {
    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/users/records/$userId");

    var user = await getUser(userId);

    user.usersID.add(interestedId);

    var body = convert.jsonEncode({
      "interestedUsers": user.usersID,
    });

    var response = await http.patch(url, body: body, headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<bool> patchUserWithInterestedProjects(
      String userId, String interestedId) async {
    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/users/records/$userId");

    var user = await getUser(userId);

    user.usersID.add(interestedId);

    var body = convert.jsonEncode({
      "interestedProjects": user.usersID,
    });

    var response = await http.patch(url, body: body, headers: {
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future<List<dynamic>> getUserInterestedUsersProfile(String userId) async {
    final queryParams = {
      'expand': 'interestedUsers',
    };

    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/users/records/$userId", queryParams);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var interestedUsers = jsonResponse["expand"]["interestedUsers"];

      for (var i = 0; i < interestedUsers.length; i++) {
        interestedUsers[i] = interestedUsers[i]["profile"];
      }

      return interestedUsers;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    throw Exception('Failed to load user interested users');
  }

  Future<List<dynamic>> getUserInterestedProjectsDetails(String userId) async {
    final queryParams = {
      'expand': 'interestedProjects.tech',
    };

    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/users/records/$userId", queryParams);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var interestedProjects = jsonResponse["expand"]["interestedProjects"];

      for (var i = 0; i < interestedProjects.length; i++) {
        interestedProjects[i] = Project.fromJson(interestedProjects[i]);
      }

      return interestedProjects;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    throw Exception('Failed to load user interested users');
  }
}
