import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tabungan_siswa/models/student_model.dart';
import 'package:http/http.dart' as http;
import 'package:tabungan_siswa/util/constant.dart';

class GradepageProvider with ChangeNotifier {
  List<StudentModel>? _studentModel;
  StudentModel? _student;
  int _monthDeposit = 0;
  int _searchMonthDeposit = 0;


  int get searchMonthDeposit => _searchMonthDeposit;

  set searchMonthDeposit(int value) {
    _searchMonthDeposit = value;
    notifyListeners();
  }

  StudentModel get student => _student!;

  set student(StudentModel value) {
    _student = value;
    notifyListeners();
  }

  int get monthDeposit => _monthDeposit;

  set monthDeposit(int value) {
    _monthDeposit = value;
    notifyListeners();
  }

  List<StudentModel> get studentModel => _studentModel!;

  set studentModel(List<StudentModel> value) {
    _studentModel = value;
    notifyListeners();
  }

  Future<bool> getData({required String token}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/grade');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };

      var response = await http.get(url, headers: headers);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        List students = jsonDecode(response.body)['data']['students'];
        List<StudentModel> studentModel = [];

        for (var item in students) {
          studentModel.add(StudentModel.fromJsonGrade(item));
        }

        _studentModel = studentModel;

        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> getDataDetail({required String token, required int id}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/students/$id');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };

      var response = await http.get(url, headers: headers);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var student = jsonDecode(response.body)['data']['student'];
        var monthDeposit = jsonDecode(response.body)['data']['month_deposit'];
        _student = StudentModel.fromJsonGrade(student);
        _monthDeposit = monthDeposit;

        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> getDataSavingsMonth({required String token, required String month, required String year, required int id}) async {
    String indexMonth = '';
    if (month == 'Januari') indexMonth = '01';
    if (month == 'Februari') indexMonth = '02';
    if (month == 'Maret') indexMonth = '03';
    if (month == 'April') indexMonth = '04';
    if (month == 'Mei') indexMonth = '05';
    if (month == 'Juni') indexMonth = '06';
    if (month == 'Juli') indexMonth = '07';
    if (month == 'Agustus') indexMonth = '08';
    if (month == 'September') indexMonth = '09';
    if (month == 'Oktober') indexMonth = '10';
    if (month == 'November') indexMonth = '11';
    if (month == 'Desember') indexMonth = '12';

    try {
      var url = Uri.parse('${Constant.baseUrl}/detailofmonth/$id/$indexMonth/$year');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };
      var body = {
        'month': indexMonth,
        'year': year,
        'student_id': id
      };

      var response = await http.get(url, headers: headers);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var total = jsonDecode(response.body)['data']['total'];
        _searchMonthDeposit = total;
        return true;
      }
    } catch (e) {
      print(e);
    }
    
    return false;
  }
}