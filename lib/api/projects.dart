import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../models/project.dart' as project;

class ProjectsAPI {
  Future<project.Project> getProject(String id) async {
    final queryParameters = {
      'expand': 'tech',
    };

    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/projects/records/$id", queryParameters);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      var projectData = project.Project.fromJson(jsonResponse);
      return projectData;
      // var itemCount = jsonResponse['totalItems'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    throw Exception('Failed to load project');
  }

  Future<List<dynamic>> getProjects() async {
    final queryParameters = {
      'expand': 'tech',
    };

    var url = Uri.https("8xzb3ljg-8090.asse.devtunnels.ms",
        "api/collections/projects/records", queryParameters);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      List<dynamic> projects = jsonResponse["items"]
          .map((e) => project.Project.fromJson(e))
          .toList();

      return projects;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    throw Exception('Failed to load projects');
  }
}
