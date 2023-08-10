import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabungan_siswa/models/credit_model.dart';
import 'package:tabungan_siswa/models/deposit_model.dart';
import 'package:tabungan_siswa/models/teacher_model.dart';

import 'package:http/http.dart' as http;
import 'package:tabungan_siswa/util/constant.dart';

class HomepageProvider with ChangeNotifier {
  TeacherModel _teacherModel = TeacherModel(id: 0, name: '', username: '', gradeId: 0, token: '');
  List<DepositModel> _depositModel = [];
  List<CreditModel> _creditModel = [];

  List<DepositModel> get depositModel => _depositModel;

  set depositModel(List<DepositModel> value) {
    _depositModel = value;
    notifyListeners();
  }

  List<CreditModel> get creditModel => _creditModel;

  set creditModel(List<CreditModel> value) {
    _creditModel = value;
    notifyListeners();
  }

  TeacherModel get teacherModel => _teacherModel;

  set teacherModel(TeacherModel value) {
    _teacherModel = value;
    notifyListeners();
  }

  // logic here
  Future<bool> getData({required String token}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/homepage');
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

        List deposit = jsonDecode(response.body)['data']['deposit_students'];
        List<DepositModel> depositModel = deposit.map((e) => DepositModel.fromJson(e)).toList();
        _depositModel = depositModel;

        List credit = jsonDecode(response.body)['data']['credit_students'];
        List<CreditModel> creditModel = credit.map((e) => CreditModel.fromJson(e)).toList();
        _creditModel = creditModel;
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}