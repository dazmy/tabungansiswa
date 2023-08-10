import 'package:tabungan_siswa/models/credit_model.dart';
import 'package:tabungan_siswa/models/deposit_model.dart';
import 'package:tabungan_siswa/models/grade_model.dart';

class StudentModel {
  int id = 0;
  String name = '';
  int gradeId = 0;
  // for grade page
  int totalDeposit = 0;
  int totalCredit = 0;
  // for grade page and detail student
  List depositModel = [];
  List creditModel = [];
  // for detail student
  GradeModel gradeModel = GradeModel(id: 0, name: '', grade: '');

  StudentModel({required this.id, required this.name, required this.gradeId});

  StudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gradeId = json['grade_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade_id': gradeId,
    };
  }

  // for grade page
  StudentModel.fromJsonGrade(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gradeId = json['grade_id'];
    gradeModel = GradeModel.fromJson(json['grade']);
    totalDeposit = json['deposit'];
    totalCredit = json['credit'];
    depositModel = json['deposits'].map((e) => DepositModel.fromJsonGrade(e)).toList();
    creditModel = json['credits'].map((e) => CreditModel.fromJsonGrade(e)).toList();
  }

  Map<String, dynamic> toJsonGrade() {
    return {
      'id': id,
      'name': name,
      'grade_id': gradeId,
      'grade': gradeModel.toJson(),
      'deposit': totalDeposit,
      'credit': totalCredit,
      'deposits': depositModel.map((e) => e.toJsonGrade()).toList(),
      'credits': creditModel.map((e) => e.toJsonGrade()).toList(),
    };
  }

  // for detail student
  StudentModel.fromJsonDetailStudent(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gradeId = json['grade_id'];
    depositModel = json['deposits'].map((e) => DepositModel.fromJsonGrade(e)).toList();
    creditModel = json['credits'].map((e) => CreditModel.fromJsonGrade(e)).toList();
  }
}