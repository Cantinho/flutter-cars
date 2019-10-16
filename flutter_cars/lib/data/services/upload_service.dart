import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter_cars/data/services/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;

class UploadApi {
  static Future<ApiResponse<String>> upload(File file) async {
    try {
      final String url = "https://carros-springboot.herokuapp.com/api/v2/upload";
      final List<int> imageBytes = file.readAsBytesSync();
      final String base64Image = convert.base64Encode(imageBytes);
      final String fileName = path.basename(file.path);

      final params = {
        "fileName": fileName,
        "mimeType": "image/jpeg",
        "base64": base64Image
      };

      final String json = convert.jsonEncode(params);

      print("http.upload: " + url);
      print("params: " + json);

      final response = await http
          .post(
          url,
          body: json
      )
          .timeout(
        Duration(seconds: 120),
        onTimeout: _onTimeOut,
      );

      print("http.upload << " + response.body);

      final Map<String, dynamic> map = convert.json.decode(response.body);
      final String urlPhoto = map["url"];

      return ApiResponse.success(urlPhoto);
    } catch (error, exception) {
      print("Uploading errror: $error - $exception");
      return ApiResponse.error("Unable to upload photo.");
    }
  }

  static FutureOr<Response> _onTimeOut() {
    print("timeout!");
    throw SocketException("Unable to communicate with server.");
  }
}