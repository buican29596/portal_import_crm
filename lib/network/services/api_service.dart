import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:portal_hotel/data/local_storage/local_storage.dart';
import 'package:portal_hotel/data/response/error_response.dart';
import 'package:portal_hotel/network/services/api_endpoints.dart';

class ApiService {
  ApiService();

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('${BaseUrl.url}$endpoint');
    try {
      final response = await http.get(url,
          headers: headers ??
              {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${loadToken()}",
              });
      return _handleResponse(response);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('${BaseUrl.url}$endpoint');
    try {
      final response = await http.post(
        url,
          headers: headers ??
              {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${loadToken()}",
              },
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('${BaseUrl.url}$endpoint');
    try {
      final response = await http.put(
        url,
        headers: headers ??
            {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${loadToken()}",
            },
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw e;
    }
  }

  Future<void> delete(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('${BaseUrl.url}$endpoint');
    try {
      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> postPrint(String apiUrl, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse(apiUrl);
    try {
      final response = await http
          .post(
            url,
        headers: headers ??
            {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${loadToken()}",
            },
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on TimeoutException catch (_) {
      throw Exception('Server error:');
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> uploadExcel(
      String endpoint, Uint8List fileBytes, String fileName,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('${BaseUrl.url}$endpoint');
    try {
      var request = http.MultipartRequest('POST', url);
      if (loadToken().isNotEmpty) {
        request.headers['Authorization'] = 'Bearer ${loadToken()}';
      }
      if (headers != null) {
        request.headers.addAll(headers);
      }
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ));

      var response = await request.send();
      return await _handleResponse(await http.Response.fromStream(response));
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> postToken(String endpoint, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse(endpoint);
    try {
      final response = await http.post(
        url,
        headers: headers ??
            {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${loadToken()}",
            },
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw e;
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      final errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      throw errorResponse;
    } else if (response.statusCode >= 500) {
      throw Exception('Server error: ${response.statusCode}');
    } else {
      throw Exception('Unknown error: ${response.statusCode}');
    }
  }
}
