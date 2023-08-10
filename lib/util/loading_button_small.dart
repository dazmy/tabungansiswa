import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tabungan_siswa/theme.dart';

class LoadingButtonSmall extends StatelessWidget {
  const LoadingButtonSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 70,
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
