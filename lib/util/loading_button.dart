import 'package:flutter/material.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultMargin + 10),
      height: 70,
      width: double.infinity,
      child: TextButton(
        onPressed: null,
        style: TextButton.styleFrom(
            backgroundColor: tertiaryTextColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.threeArchedCircle(color: backgroundColorPrimary, size: 30),
            SizedBox(width: defaultMargin,),
            Text('Loading', style: redTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
          ],
        ),
      ),
    );
  }
}
