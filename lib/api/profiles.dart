import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/profile.dart' as profile;

class ProfilesAPI {
  Future<profile.Profile> getProfile(String id) async {
    final queryParameters = {
      'expand': 'skills,interests',
    };

    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/profiles/records/$id", queryParameters);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var profileData = profile.Profile.fromJson(jsonResponse);
      return profileData;
      // var itemCount = jsonResponse['totalItems'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    throw Exception('Failed to load profile');
  }

  Future<List<dynamic>> getProfiles() async {
    final queryParameters = {
      'expand': 'skills,interests',
    };

    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/profiles/records", queryParameters);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      List<dynamic> profiles = jsonResponse["items"]
          .map((e) => profile.Profile.fromJson(e))
          .toList();

      return profiles;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    throw Exception('Failed to load profiles');
  }
}
