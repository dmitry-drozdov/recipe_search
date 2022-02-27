import 'dart:developer';

import 'package:http/http.dart';

const delimiter = '--------------------------------';

void logRequest(String query, Response response) {
  log(delimiter);
  log(query);
  log(response.body);
  log(delimiter);
}