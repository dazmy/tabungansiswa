import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tabungan_siswa/util/constant.dart';

class PDFProvider with ChangeNotifier {
  Future<bool> downloadPDFMonth({required String token, required String month, required String year}) async {
    try {
      var url = Uri.parse('${Constant.baseUrl}/datamonth/$month/$year');
      var headers = {
        'Accept': 'application/json',
        'Authorization': token,
      };

      var response = await http.get(url, headers: headers);
      print(response.statusCode);

      if (response.statusCode == 200) {
        var time = DateTime.now().millisecondsSinceEpoch;
        var path = '/storage/emulated/0/Download/laporan-tabungan-$month-$year-$time.pdf';
        var file = File(path);
        file.writeAsBytes(response.bodyBytes);
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}