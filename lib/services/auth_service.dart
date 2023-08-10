import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tabungan_siswa/util/constant.dart';

class AuthService {
  final box = Hive.box('box');

  Future<bool> login({required String username, required String password}) async {
    var url = Uri.parse('${Constant.baseUrl}/login');
    var headers = {
      'Accept': 'application/json',
    };
    var body = {
      'username': username,
      'password': password,
    };

    var response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 && (jsonDecode(response.body)['success'] == true)) {
      var type = jsonDecode(response.body)['data']['type'];
      var token = jsonDecode(response.body)['data']['token'];
      var data = jsonDecode(response.body)['data']['user'];

      box.put('isLogin', true);
      box.put('token', '$type $token');
      box.put('teacherId', data['id']);

      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<bool> logout({String? token}) async {
    var url = Uri.parse('${Constant.baseUrl}/logout');
    var headers = {
      'Authorization': token!,
      'Accept': 'application/json',
    };

    var response = await http.post(url, headers: headers);
    print(response.body);
    print(response.statusCode);

    if(response.statusCode == 200 && (jsonDecode(response.body)['success'] == true)) {
      return true;
    } else {
      throw Exception('Failed Logout');
    }
  }

  Future<bool> register({required String name, required int grade, required String username, required String password, required String passwordConfirm}) async {
    var url = Uri.parse('${Constant.baseUrl}/register');
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var body = {
      'name': name,
      'username': username,
      'grade_id': grade,
      'password': password,
      'password_confirmation': passwordConfirm,
    };
    
    var response = await http.post(url, headers: headers, body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
    
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Register Failed');
    }
  }
}