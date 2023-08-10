import 'package:tabungan_siswa/models/grade_model.dart';

class TeacherModel {
  int id = 0;
  String name = '';
  String username = '';
  int gradeId = 0;
  String token = '';
  GradeModel gradeModel = GradeModel(id: 0, name: '', grade: '');

  TeacherModel({required this.id, required this.name, required this.username, required this.gradeId, required this.token});

  TeacherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    gradeId = json['grade_id'];
    gradeModel = GradeModel.fromJson(json['grade']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'grade_id': gradeId,
      'grade': gradeModel.toJson(),
    };
  }
}