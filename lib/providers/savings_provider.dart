import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tabungan_siswa/util/constant.dart';

class SavingsProvider with ChangeNotifier {
  Future<bool> addStudent({required String token, required String name}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/students');
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      var body = {
        'name': name
      };

      var response = await  http.post(url, headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        print('berhasil add student');
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> deleteStudent({required String token, required int id}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/students/$id');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };

      var response = await http.delete(url, headers: headers);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print('berhasil hapus student');
        return true;
      }
    } catch (e) {
      print(e);
    }
    
    return false;
  }
  
  Future<bool> addDeposit({required String token, required int id, required String deposit, required String inputDate}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/deposit');
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      var body = {
        'deposit': deposit,
        'student_id': id,
        'input_date': inputDate
      };

      var response = await http.post(url, headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print('success add deposit');
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> addCredit({required String token, required int id, required String credit, required String inputDate}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/credit');
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      // id student
      var body = {
        'credit': credit,
        'student_id': id,
        'input_date': inputDate,
      };

      var response = await http.post(url, headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print('success add credit');
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> editDeposit({required String token, required int id, required String deposit, required String inputDate}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/deposit/$id');
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': token,

      };
      var body = {
        'deposit': deposit,
        'input_date': inputDate
      };

      var response = await http.put(url, headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print('success edit');
        return true;
      }
    } catch (e) {
      print(e);
    }
    
    return false;
  }

  Future<bool> editCredit({required String token, required int id, required String credit, required String inputDate}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/credit/$id');
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': token,

      };
      var body = {
        'credit': credit,
        'input_date': inputDate
      };

      var response = await http.put(url, headers: headers, body: jsonEncode(body));
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        print('success edit');
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> deleteDeposit({required String token, required int id}) async {
    try {
      // id deposit
      var url = Uri.parse('${Constant.baseUrl}/deposit/$id');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };

      var response = await http.delete(url, headers: headers);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 && (jsonDecode(response.body)['success'] == true)) {
        print('berhasil hapus');
        return true;
      }
    } catch (e) {
      print(e);
    }
    
    return false;
  }

  Future<bool> deleteCredit({required String token, required int id}) async {
    try {
      // id credit
      var url = Uri.parse('${Constant.baseUrl}/credit/$id');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };

      var response = await http.delete(url, headers: headers);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 && (jsonDecode(response.body)['success'] == true)) {
        print('berhasil hapus');
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}