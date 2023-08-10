import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabungan_siswa/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:tabungan_siswa/util/constant.dart';

class StudentProvider with ChangeNotifier {
  StudentModel? _studentModel;

  StudentModel get studentModel => _studentModel!;

  set studentModel(StudentModel value) {
    _studentModel = value;
    notifyListeners();
  }

  Future<bool> getDetailSavings({required String token, required int id}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/deposit/$id');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };
      
      var response = await http.get(url, headers: headers);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var studentModel = jsonDecode(response.body)['data']['student'];
        _studentModel = StudentModel.fromJsonDetailStudent(studentModel);
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}