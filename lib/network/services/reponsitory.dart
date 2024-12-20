import 'dart:convert';
import 'dart:typed_data';

import 'package:portal_hotel/data/response/import_data.dart';
import 'package:portal_hotel/network/services/api_endpoints.dart';
import 'package:portal_hotel/network/services/api_service.dart';

class Repository {
  final ApiService apiService = ApiService();

  Future<String?> getToken() async {
    try {
      String url ='';
      Map<String, String> body ={};
      if(BaseUrl.url.contains('uat')){
        url = 'https://iamlab.citigym.asia';
        body = {
          'grant_type': 'client_credentials',
          'client_id': 'sfgw-nsg-draft-orders-service-qVsoRgUO',
          'client_secret': 'utm5JItuJPA7VflLbZkVPlNsoKBwKEvN',
        };
      }else{
        url = 'https://iam.citigym.asia';
        body = {
          'grant_type': 'client_credentials',
          'client_id': 'sfgw-nsg-draft-orders-service-qVsoRgUO',
          'client_secret': 'trZsNM5gBesDQJBzlZ7j0zaqjkiVCoJ3',
        };
      }
      const headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final response =
      await apiService.postToken('$url/realms/services/protocol/openid-connect/token', body, headers: headers, );
      return response['access_token'];
    } catch (e) {
      throw e;
    }
  }

  Future<bool?> importExcel(String token,ImportData importData) async {
    try {
      final jsonString = jsonEncode(importData.toJson());
      final decodedJson = jsonDecode(jsonString);

      print(decodedJson);
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
        'x-client-id' : 'sfgw-nsg-draft-orders-service-qVsoRgUO',
        'x-timezone' : 'Asia/Ho_Chi_Minh',
      };
      final response =
      await apiService.post(PortalApi.upload, importData.toJson(),headers: headers);
      return response['message'] == 'success';
    } catch (e) {
      throw e;
    }
  }

}
