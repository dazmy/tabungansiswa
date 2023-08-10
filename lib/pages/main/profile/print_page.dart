import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/providers/pdf_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:tabungan_siswa/util/downloading_dialog.dart';
import 'package:tabungan_siswa/util/loading_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PrintPage extends StatefulWidget {
  const PrintPage({Key? key}) : super(key: key);

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  List<String> months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  String defaultValue = 'Januari';
  TextEditingController yearController = TextEditingController();
  final box = Hive.box('box');
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    PDFProvider pdfProvider = Provider.of<PDFProvider>(context, listen: false);

    downloadPDF() async {
      String lowerMonth = defaultValue.toLowerCase();
      String id = box.get('teacherId').toString();
      final url = 'http://192.168.100.6:8081/api/datamonth/$lowerMonth/${yearController.text}/$id';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('gagal');
      }
    }

    usingFilePath() async {
      setState(() {
        isLoading = true;
      });

      if (await pdfProvider.downloadPDFMonth(token: box.get('token'), month: defaultValue.toLowerCase(), year: yearController.text)) {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Download Selesai', style: primaryTextStyle.copyWith(fontWeight: bold),)),
          );
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Download Gagal', style: primaryTextStyle.copyWith(fontWeight: bold),)),
          );
        });
      }
    }

    PreferredSizeWidget header() {
      return AppBar(
        centerTitle: true,
        backgroundColor: backgroundColorPrimary,
        title: Text('Kelola Print', style: secondaryTextStyle.copyWith(fontWeight: bold),),
      );
    }

    Widget content() {
      return Container(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          children: [
            DropdownButton<String>(
              isExpanded: true,
              style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),
              value: defaultValue,
              onChanged: (String? e) {
                setState(() {
                  defaultValue = e!;
                });
              },
              items: months.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
            ),
            SizedBox(height: defaultMargin,),
            SizedBox(
              // width: 100,
              child: TextFormField(
                controller: yearController,
                maxLength: 4,
                keyboardType: TextInputType.number,
                style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),
                decoration: const InputDecoration.collapsed(hintText: 'Input Tahun'),
              ),
            ),
            SizedBox(height: defaultMargin,),
            (isLoading) ? const LoadingButton() : Container(
              margin: EdgeInsets.only(top: defaultMargin + 10),
              height: 70,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  var status = await Permission.storage.request();
                  if (status.isGranted) {
                    await usingFilePath();
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: backgroundColorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    )
                ),
                child: Text('Download', style: secondaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: header(),
      body: content(),
    );
  }
}
