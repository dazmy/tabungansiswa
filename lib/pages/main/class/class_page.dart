import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/providers/gradepage_provider.dart';
import 'package:tabungan_siswa/providers/savings_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:tabungan_siswa/util/loading_button_small.dart';
import 'package:tabungan_siswa/util/loading_page.dart';
import 'package:tabungan_siswa/util/student_card.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key}) : super(key: key);

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  final box = Hive.box('box');
  bool isLoading = true;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    GradepageProvider gradePageProvider = Provider.of<GradepageProvider>(context, listen: false);
    if (await gradePageProvider.getData(token: box.get('token'))) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    GradepageProvider gradePageProvider = Provider.of<GradepageProvider>(context);
    GradepageProvider gradepageProvider = Provider.of<GradepageProvider>(context, listen: false);
    SavingsProvider savingsProvider = Provider.of<SavingsProvider>(context, listen: false);

    handleAddStudent() async {
      Navigator.pop(context);
      setState(() {
        isLoading = true;
      });
      if (await savingsProvider.addStudent(token: box.get('token'), name: nameController.text)) {
        if (await gradepageProvider.getData(token: box.get('token'))) {
          setState(() {
            nameController.text = '';
            isLoading = false;
          });
          if (!mounted) return;
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Center(child: Text('Berhasil Tambah Data', style: primaryTextStyle.copyWith(fontWeight: bold),),),
            );
          });
        }
      } else {
        setState(() {
          nameController.text = '';
          isLoading = false;
        });
        if (!mounted) return;
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Gagal Tambah Data', style: primaryTextStyle.copyWith(fontWeight: bold),),),
          );
        });
      }
    }

    handleRefresh() async {
      setState(() {
        isLoading = true;
      });
      if (await gradepageProvider.getData(token: box.get('token'))) {
        setState(() {
          nameController.text = '';
          isLoading = false;
        });
      } else {
        print('tidak bisa load data');
      }
    }

    Future<void> showDialogAdd() async {
      return showDialog(barrierDismissible: false, context: context, builder: (_) {
        return AlertDialog(
          title: Center(child: Text('Tambah Siswa', style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),)),
          content: Row(
            children: [
              Text('Nama :', style: primaryTextStyle.copyWith(fontWeight: medium),),
              const SizedBox(width: 5,),
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),
                ),
              ),
            ],
          ),
          actions: [
            MaterialButton(onPressed: () {
              Navigator.pop(context);
            }, color: backgroundColorPrimary, child: Text('Cancel', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
            MaterialButton(onPressed: handleAddStudent, color: Colors.green[600], child: Text('Tambah', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
          ],
        );
      });
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(left: defaultMargin, top: 15, right: defaultMargin),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daftar Siswa', style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
                  SizedBox(height: defaultMargin,),
                ],
              ),
            ),
            // kalau  bisa tambah fitur search
            InkWell(
              onTap: showDialogAdd,
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColorPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.add, color: secondaryTextColor,),
              ),
            ),
            const SizedBox(width: 10,),
            InkWell(
              onTap: handleRefresh,
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColorPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.refresh, color: secondaryTextColor,),
              ),
            ),
          ],
        ),
      );
    }

    Widget emptyContent() {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_off, size: 50, color: tertiaryTextColor,),
              const SizedBox(height: 10,),
              Text('Daftar Siswa Kosong', style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),),
            ],
          ),
        ),
      );
    }

    Widget floatButton() {
      return Container(
        height: MediaQuery.of(context).size.height * 0.77,
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: backgroundColorPrimary,
            child: const Icon(Icons.add, size: 30,),
          ),
        ),
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin,),
        child: (gradePageProvider.studentModel.isEmpty) ? emptyContent() : ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: gradePageProvider.studentModel.length,
          // physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return StudentCard(studentModel: gradePageProvider.studentModel[index],);
          },
        ),
      );
    }

    refreshThisPage() async {
      await gradepageProvider.getData(token: box.get('token'));
      setState(() {});
    }

    return RefreshIndicator(
      color: backgroundColorPrimary,
      backgroundColor: secondaryTextColor,
      onRefresh: () async {
        return refreshThisPage();
      },
      child: SafeArea(
        child: (isLoading) ? const LoadingPage() : Column(
          // padding: EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 15),
          children: [
            header(),
            Flexible(child: content()),
          ],
        ),
      ),
    );
  }
}
