import 'package:tabungan_siswa/models/student_model.dart';

class CreditModel {
  int id = 0;
  int credit = 0;
  int studentId = 0;
  DateTime inputDate = DateTime.parse('2023-07-18 00:00:00');
  DateTime createdAt = DateTime.parse('2001-01-01T23:42:18.000000Z');
  // except grade page below
  StudentModel studentModel = StudentModel(id: 0, name: '', gradeId: 0);

  CreditModel({required this.id, required this.credit, required this.studentId, required this.studentModel, required this.createdAt});

  CreditModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    credit = json['credit'];
    studentId = json['student_id'];
    inputDate = DateTime.parse(json['input_date']);
    createdAt = DateTime.parse(json['created_at']);
    studentModel = StudentModel.fromJson(json['student']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'credit': credit,
      'student_id': studentId,
      'input_date': inputDate.toString().split('.')[0],
      'created_at': createdAt.toString(),
      'student': studentModel.toJson(),
    };
  }

  // for grade page
  CreditModel.fromJsonGrade(Map<String, dynamic> json) {
    id = json['id'];
    credit = json['credit'];
    studentId = json['student_id'];
    inputDate = DateTime.parse(json['input_date']);
    createdAt = DateTime.parse(json['created_at']);
  }

  Map<String, dynamic> toJsonGrade() {
    return {
      'id': id,
      'credit': credit,
      'student_id': studentId,
      'input_date': inputDate.toString().split('.')[0],
      'created_at': createdAt.toString(),
    };
  }
}