import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/providers/student_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:tabungan_siswa/util/loading_page.dart';
import 'package:tabungan_siswa/util/savings_card.dart';

class DetailSavingsPage extends StatefulWidget {
  final bool isDeposit;
  final int id;
  const DetailSavingsPage({Key? key, required this.isDeposit, required this.id}) : super(key: key);

  @override
  State<DetailSavingsPage> createState() => _DetailSavingsPageState();
}

class _DetailSavingsPageState extends State<DetailSavingsPage> {
  final box = Hive.box('box');
  bool isLoading = true;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    StudentProvider studentProvider = Provider.of<StudentProvider>(context, listen: false);
    if (await studentProvider.getDetailSavings(token: box.get('token'), id: widget.id)) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    StudentProvider studentProvider = Provider.of<StudentProvider>(context);

    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColorPrimary,
        centerTitle: true,
        title: Text('Detail Tabungan', style: secondaryTextStyle.copyWith(fontWeight: bold),),
      );
    }

    Widget emptyContent(String name) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off, size: 50, color: tertiaryTextColor,),
            const SizedBox(height: 10,),
            Text('Daftar $name Kosong', style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),),
          ],
        ),
      );
    }

    Widget contentDeposit() {
      int index = 0;
      return (studentProvider.studentModel.depositModel.isEmpty) ? emptyContent('Pemasukan') : Container(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          children: studentProvider.studentModel.depositModel.map((e) {
            return SavingsCard(isDeposit: true, depositModel: studentProvider.studentModel.depositModel[index++],);
          }).toList(),
        ),
      );
    }

    Widget contentCredit() {
      int index = 0;
      return (studentProvider.studentModel.creditModel.isEmpty) ? emptyContent('Pengeluaran') : Container(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          children: studentProvider.studentModel.creditModel.map((e) {
            return SavingsCard(isDeposit: false, creditModel: studentProvider.studentModel.creditModel[index++],);
          }).toList(),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: header(),
      body: (isLoading) ? const LoadingPage() : (widget.isDeposit) ? contentDeposit() : contentCredit(),
    );
  }
}
