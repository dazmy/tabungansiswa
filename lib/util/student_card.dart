import 'package:flutter/material.dart';
import 'package:tabungan_siswa/models/student_model.dart';
import 'package:tabungan_siswa/pages/main/class/detail_student_page.dart';
import 'package:tabungan_siswa/theme.dart';

class StudentCard extends StatelessWidget {
  final StudentModel studentModel;
  const StudentCard({Key? key, required this.studentModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: defaultMargin),
      padding: EdgeInsets.all(defaultMargin),
      decoration: BoxDecoration(
        color: secondaryTextColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentModel.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: primaryTextStyle.copyWith(fontWeight: bold),),
                GestureDetector(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailStudentPage(id: studentModel.id,);
                  }));
                }, child: Text('Lihat Detail Siswa', style: redTextStyle.copyWith(fontWeight: bold),)),
              ],
            ),
          ),
          const SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text('Jml Pemasukan ', style: primaryTextStyle,),
                  Text('Rp. ${studentModel.totalDeposit / 1000}K', style: primaryTextStyle.copyWith(fontWeight: bold),),
                ],
              ),
              Row(
                children: [
                  Text('Jml Pengeluaran ', style: primaryTextStyle,),
                  Text('Rp. ${studentModel.totalCredit}', style: primaryTextStyle.copyWith(fontWeight: bold),),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
