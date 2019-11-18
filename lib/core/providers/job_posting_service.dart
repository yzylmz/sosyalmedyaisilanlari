import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sosyalmedyaisilanlari/core/model/DummyJobPosting.dart';

class JobPostingService {
  String _baseUrl;

  static JobPostingService _instance = JobPostingService._privateConstructor();

  JobPostingService._privateConstructor() {
    _baseUrl = "https://jsonplaceholder.typicode.com";
  }

  static JobPostingService getInstance() {
    if (_instance == null) {
      return JobPostingService._privateConstructor();
    } else {
      return _instance;
    }
  }

  List<DummyJobPosting> parseDummyJobPostings(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<DummyJobPosting>((json) => DummyJobPosting.fromJson(json))
        .toList();
  }

  Future<List<DummyJobPosting>> getJobPostings() async {
    final response = await http.get("$_baseUrl/comments.json");

    final jsonResponse = json.decode(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        final DummyJobPostingList = parseDummyJobPostings(jsonResponse);
        return DummyJobPostingList;
        break;
      default:
    }
  }
}
