import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/pages/main/class/detail_savings_page.dart';
import 'package:tabungan_siswa/providers/gradepage_provider.dart';
import 'package:tabungan_siswa/providers/savings_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:tabungan_siswa/util/loading_page.dart';

class DetailStudentPage extends StatefulWidget {
  final int id;
  const DetailStudentPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailStudentPage> createState() => _DetailStudentPageState();
}

class _DetailStudentPageState extends State<DetailStudentPage> {
  List<String> months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  String defaultValue = 'Januari';
  final box = Hive.box('box');
  bool isLoading = true;

  TextEditingController depositController = TextEditingController();
  TextEditingController creditController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  TextEditingController dateController = TextEditingController();
  TextEditingController hourController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    GradepageProvider gradePageProvider = Provider.of(context, listen: false);
    if (await gradePageProvider.getDataDetail(token: box.get('token'), id: widget.id)) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    GradepageProvider gradePageProvider = Provider.of(context);
    SavingsProvider savingsProvider = Provider.of<SavingsProvider>(context, listen: false);

    handleAdd() async {
      Navigator.pop(context);
      setState(() {
        isLoading = true;
      });
      if (await savingsProvider.addDeposit(token: box.get('token'), id: widget.id, deposit: depositController.text, inputDate: '${dateController.text} ${hourController.text}')) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return DetailStudentPage(id: widget.id);
        }));
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Berhasil Tambah', style: primaryTextStyle.copyWith(fontWeight: bold),),),
          );
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Gagal Tambah', style: primaryTextStyle.copyWith(fontWeight: bold),),),
          );
        });
      }
    }

    handleReduce() async {
      Navigator.pop(context);
      setState(() {
        isLoading = true;
      });
      if (await savingsProvider.addCredit(token: box.get('token'), id: widget.id, credit: creditController.text, inputDate: '${dateController.text} ${hourController.text}')) {
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return DetailStudentPage(id: widget.id);
        }));
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Berhasil Ambil', style: primaryTextStyle.copyWith(fontWeight: bold),),),
          );
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Gagal Ambil', style: primaryTextStyle.copyWith(fontWeight: bold),),),
          );
        });
      }
    }

    handleDeleteStudent() async {
      if (await savingsProvider.deleteStudent(token: box.get('token'), id: widget.id)) {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }

    Future<void> showDialogAdd() async {
      return showDialog(barrierDismissible: false, context: context, builder: (_) {
        return AlertDialog(
          title: Text('Tambah Tabungan', style: primaryTextStyle.copyWith(fontWeight: bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Rp. ', style: primaryTextStyle,),
                  Expanded(
                    child: TextFormField(
                      controller: depositController,
                      keyboardType: TextInputType.number,
                      style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              TextFormField(
                keyboardType: TextInputType.none,
                controller: dateController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_month, size: 20,),
                  hintText: 'Pilih Tanggal',
                  hintStyle: primaryTextStyle
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 30,),
              TextFormField(
                keyboardType: TextInputType.none,
                controller: hourController,
                decoration: InputDecoration(
                    icon: const Icon(Icons.access_time, size: 20,),
                    hintText: 'Pilih Jam',
                    hintStyle: primaryTextStyle
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                  if (pickedTime != null) {
                    setState(() {
                      hourController.text = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00';
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            MaterialButton(onPressed: () {
              Navigator.pop(context);
            }, color: backgroundColorPrimary, child: Text('Cancel', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
            MaterialButton(onPressed: handleAdd, color: Colors.green[600], child: Text('Tambah', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
          ],
        );
      });
    }

    Future<void> showDialogReduce() async {
      return showDialog(barrierDismissible: false, context: context, builder: (_) {
        return AlertDialog(
          title: Text('Ambil Tabungan', style: primaryTextStyle.copyWith(fontWeight: bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Rp. ', style: primaryTextStyle,),
                  Expanded(
                    child: TextFormField(
                      controller: creditController,
                      keyboardType: TextInputType.number,
                      style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              TextFormField(
                keyboardType: TextInputType.none,
                controller: dateController,
                decoration: InputDecoration(
                    icon: const Icon(Icons.calendar_month, size: 20,),
                    hintText: 'Pilih Tanggal',
                    hintStyle: primaryTextStyle
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 30,),
              TextFormField(
                keyboardType: TextInputType.none,
                controller: hourController,
                decoration: InputDecoration(
                    icon: const Icon(Icons.access_time, size: 20,),
                    hintText: 'Pilih Jam',
                    hintStyle: primaryTextStyle
                ),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                  if (pickedTime != null) {
                    setState(() {
                      hourController.text = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00';
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            MaterialButton(onPressed: () {
              Navigator.pop(context);
            }, color: backgroundColorPrimary, child: Text('Cancel', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
            MaterialButton(onPressed: handleReduce, color: Colors.green[600], child: Text('Ambil', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
          ],
        );
      });
    }

    Future<void> showDialogDeleteStudent() async {
      return showDialog(context: context, builder: (_) {
        return AlertDialog(
          title: Center(child: Text('Hapus Siswa', style: primaryTextStyle.copyWith(fontWeight: bold),)),
          content: Row(
            children: [
              Text('Nama : ', style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),),
              Expanded(child: Text(gradePageProvider.student.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),)),
            ],
          ),
          actions: [
            MaterialButton(onPressed: () {
              Navigator.pop(context);
            }, color: backgroundColorPrimary, child: Text('Cancel', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
            MaterialButton(onPressed: handleDeleteStudent, color: Colors.green[600], child: Text('Hapus Siswa', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
          ],
        );
      });
    }

    handleSearchByMonth() async {
      if (await gradePageProvider.getDataSavingsMonth(token: box.get('token'), month: defaultValue, year: yearController.text, id: widget.id)) {
        if (!mounted) return;
        return showDialog(context: context, builder: (_) {
          return AlertDialog(
            title: Center(child: Text('Rp. ${gradePageProvider.searchMonthDeposit}', style: primaryTextStyle.copyWith(fontWeight: bold),)),
          );
        });
      } else {
        if (!mounted) return;
        return showDialog(context: context, builder: (_) {
          return AlertDialog(
            title: Center(child: Text('Gagal Ambil Data', style: primaryTextStyle.copyWith(fontWeight: bold),)),
          );
        });
      }
    }
    
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: backgroundColorPrimary,
        centerTitle: true,
        title: Text('Detail Siswa', style: secondaryTextStyle.copyWith(fontWeight: bold),),
        actions: [
          IconButton(onPressed: showDialogDeleteStudent, icon: const Icon(Icons.delete, size: 30,)),
        ],
      );
    }

    Widget content() {
      return Container(
        margin: EdgeInsets.all(defaultMargin),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama :', style: tertiaryTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),),
                Text(gradePageProvider.student.name, style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
                const SizedBox(height: 10,),
                Text('Kelas :', style: tertiaryTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),),
                Text(gradePageProvider.student.gradeModel.name, style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
                const SizedBox(height: 10,),
                Text('Jumlah Keseluruhan Tabungan :', style: tertiaryTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),),
                Text('Rp. ${gradePageProvider.student.totalDeposit - gradePageProvider.student.totalCredit}', style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
                const SizedBox(height: 10,),
                Text('Tabungan Bulan Ini :', style: tertiaryTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),),
                Text('Rp. ${gradePageProvider.monthDeposit}', style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
                const SizedBox(height: 10,),
                Text('Cari Tabungan Bulan :', style: tertiaryTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        DropdownButton<String>(
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
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: yearController,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),
                            decoration: const InputDecoration.collapsed(hintText: 'Input Tahun'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: defaultMargin,),
                    MaterialButton(onPressed: handleSearchByMonth, color: backgroundColorPrimary, child: Text('Cari', style: secondaryTextStyle.copyWith(fontWeight: bold),)),
                  ],
                ),
                SizedBox(height: defaultMargin * 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: TextButton(
                            onPressed: showDialogReduce,
                            style: TextButton.styleFrom(
                              backgroundColor: backgroundColorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              )
                            ),
                            child: Text('Ambil', style: secondaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),),
                          ),
                        ),
                        SizedBox(height: defaultMargin,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return DetailSavingsPage(isDeposit: false, id: widget.id,);
                              }));
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: tertiaryTextColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                            child: Text('Detail', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: TextButton(
                            onPressed: showDialogAdd,
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                            child: Text('Tambah', style: secondaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),),
                          ),
                        ),
                        SizedBox(height: defaultMargin,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return DetailSavingsPage(isDeposit: true, id: widget.id,);
                              }));
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: tertiaryTextColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                )
                            ),
                            child: Text('Detail', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: header(),
      body: (isLoading) ? const LoadingPage() : content(),
    );
  }
}
