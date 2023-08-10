import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/providers/homepage_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:tabungan_siswa/util/credit_tile.dart';
import 'package:tabungan_siswa/util/deposit_tile.dart';
import 'package:tabungan_siswa/util/loading_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  final box = Hive.box('box');

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    HomepageProvider homepageProvider = Provider.of<HomepageProvider>(context, listen: false);
    if (await homepageProvider.getData(token: box.get('token'))) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    HomepageProvider homepageProvider = Provider.of<HomepageProvider>(context);
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tabungan Siswa', style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
                  Text('SDN Margadadi 4', style: tertiaryTextStyle,),
                ],
              ),
            ),
            ClipRRect(child: Image.asset('assets/image_profile.png', width: 85,)),
          ],
        ),
      );
    }

    Widget textWelcome() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat Datang, ', style: primaryTextStyle.copyWith(fontSize: 20),),
            Text(homepageProvider.teacherModel.name, style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: bold),),
          ],
        ),
      );
    }

    Widget empty() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: defaultMargin * 3, vertical: defaultMargin * 4),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.folder_off, size: 30, color: tertiaryTextColor,),
              const SizedBox(height: 5,),
              Text('Data Kosong', style: primaryTextStyle.copyWith(fontWeight: medium),)
            ],
          ),
        ),
      );
    }

    Widget deposit() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Pemasukan Terbaru Siswa ', style: primaryTextStyle.copyWith(fontSize: 16),),
                Flexible(child: Text(homepageProvider.teacherModel.gradeModel.name, style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold),)),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryTextColor),
              ),
              child: (homepageProvider.depositModel.isEmpty) ? empty() : Column(
                children: homepageProvider.depositModel.map((e) {
                  return DepositTile(depositModel: e,);
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    Widget credit() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Pengeluaran Terbaru Siswa ', style: primaryTextStyle.copyWith(fontSize: 16),),
                Flexible(child: Text(homepageProvider.teacherModel.gradeModel.name, style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold),)),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryTextColor),
              ),
              child: (homepageProvider.creditModel.isEmpty) ? empty() : Column(
                children: homepageProvider.creditModel.map((e) {
                  return CreditTile(creditModel: e,);
                }).toList(),
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
          textWelcome(),
          deposit(),
          credit(),
        ],
      ),
    );
  }
}
