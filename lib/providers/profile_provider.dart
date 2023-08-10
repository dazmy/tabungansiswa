import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabungan_siswa/models/teacher_model.dart';
import 'package:http/http.dart' as http;
import 'package:tabungan_siswa/util/constant.dart';

class ProfileProvider with ChangeNotifier {
  TeacherModel _teacherModel = TeacherModel(id: 0, name: '', username: '', gradeId: 0, token: '');
  int _totalStudents = 0;
  int _totalStudentsWhereHasDeposit = 0;

  TeacherModel get teacherModel => _teacherModel;

  set teacherModel(TeacherModel value) {
    _teacherModel = value;
    notifyListeners();
  }

  int get totalStudents => _totalStudents;

  set totalStudents(int value) {
    _totalStudents = value;
    notifyListeners();
  }

  int get totalStudentsWhereHasDeposit => _totalStudentsWhereHasDeposit;

  set totalStudentsWhereHasDeposit(int value) {
    _totalStudentsWhereHasDeposit = value;
    notifyListeners();
  }

  Future<bool> getData({required String token}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/profile');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };

      var response = await http.get(url, headers: headers);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var teacher = jsonDecode(response.body)['data']['user'];
        TeacherModel teacherModel = TeacherModel.fromJson(teacher);
        _teacherModel = teacherModel;

        int students = jsonDecode(response.body)['data']['students'];
        int totalStudents = students;
        _totalStudents = totalStudents;

        int studentsDeposit = jsonDecode(response.body)['data']['students_deposit'];
        int totalStudentsWhereHasDeposit = studentsDeposit;
        _totalStudentsWhereHasDeposit = totalStudentsWhereHasDeposit;

        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}