class GradeModel {
  int id = 0;
  String name = '';
  String grade = '';

  GradeModel({required this.id, required this.name, required this.grade});

  GradeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    grade = json['grade'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
    };
  }
}