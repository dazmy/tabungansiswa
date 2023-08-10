import 'package:flutter/material.dart';
import 'package:tabungan_siswa/models/credit_model.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:intl/intl.dart';

class CreditTile extends StatelessWidget {
  final CreditModel creditModel;
  const CreditTile({Key? key, required this.creditModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dt = creditModel.inputDate;

    return Container(
      margin: const EdgeInsets.all(7),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: defaultMargin - 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: secondaryTextColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(creditModel.studentModel.name, style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
                Text(DateFormat.yMMMMd('id_ID').format(dt), style: tertiaryTextStyle.copyWith(fontWeight: semiBold),),
              ],
            ),
          ),
          Text('Rp. ${creditModel.credit}', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),)
        ],
      ),
    );
  }
}
