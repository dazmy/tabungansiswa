import 'package:flutter/material.dart';
import 'package:tabungan_siswa/models/teacher_model.dart';
import 'package:tabungan_siswa/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  TeacherModel _teacherModel = TeacherModel(id: 0, name: '', username: '', gradeId: 0, token: '');

  TeacherModel get teacherModel => _teacherModel;

  set teacherModel(TeacherModel value) {
    _teacherModel = value;
    notifyListeners();
  }

  Future<bool> login({required String username, required String password}) async {
    try {
      await AuthService().login(username: username, password: password);
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> logout({String? token}) async {
    try {
      await AuthService().logout(token: token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register({required String name, required int grade, required String username, required String password, required String passwordConfirm}) async {
    try {
      await AuthService().register(name: name, grade: grade, username: username, password: password, passwordConfirm: passwordConfirm);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}