import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/providers/auth_provider.dart';
import 'package:tabungan_siswa/providers/profile_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:tabungan_siswa/util/loading_button_small.dart';
import 'package:tabungan_siswa/util/loading_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  bool isLoadingButton = false;
  final box = Hive.box('box');

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    if (await profileProvider.getData(token: box.get('token'))) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);

    handleLogout() async {
      setState(() {
        isLoadingButton = true;
      });

      try {
        box.delete('isLogin');
        box.delete('id');
        await AuthProvider().logout(token: box.get('token'));
        box.delete('token');
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } catch (e) {}

      setState(() {
        isLoadingButton = true;
      });
    }

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profil Guru', style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
          Text('Data', style: tertiaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),),
        ],
      );
    }

    Widget content() {
      return Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            ClipRRect(child: Image.asset('assets/image_profile.png', width: 140,)),
            const SizedBox(height: 15,),
            Text(profileProvider.teacherModel.name, style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),),
            const SizedBox(height: 5,),
            Text('Guru ${profileProvider.teacherModel.gradeModel.name}', style: tertiaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),),
            SizedBox(height: defaultMargin,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: tertiaryTextColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      Text(profileProvider.totalStudents.toString(), style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
                      const SizedBox(height: 5,),
                      Text('Siswa', style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),),
                    ],
                  ),
                ),
                Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: tertiaryTextColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      Text(profileProvider.totalStudentsWhereHasDeposit.toString(), style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
                      const SizedBox(height: 5,),
                      Text('Menabung', style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: defaultMargin * 5,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 70,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/print');
                },
                style: TextButton.styleFrom(
                    backgroundColor: tertiaryTextColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    )
                ),
                child: Text('Kelola Print', style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
              ),
            ),
            SizedBox(height: defaultMargin,),
            (isLoadingButton) ? const LoadingButtonSmall() : SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 70,
              child: TextButton(
                onPressed: handleLogout,
                style: TextButton.styleFrom(
                    backgroundColor: backgroundColorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    )
                ),
                child: Text('Logout', style: secondaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: (isLoading) ? const LoadingPage() : ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 15),
        children: [
          header(),
          content(),
        ],
      ),
    );
  }
}
