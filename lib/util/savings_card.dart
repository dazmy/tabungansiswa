import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/models/credit_model.dart';
import 'package:tabungan_siswa/models/deposit_model.dart';
import 'package:tabungan_siswa/pages/main/class/detail_savings_page.dart';
import 'package:tabungan_siswa/providers/savings_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:intl/intl.dart';

class SavingsCard extends StatefulWidget {
  final bool isDeposit;
  DepositModel? depositModel;
  CreditModel? creditModel;
  SavingsCard({Key? key, required this.isDeposit, this.depositModel, this.creditModel}) : super(key: key);

  @override
  State<SavingsCard> createState() => _SavingsCardState();
}

class _SavingsCardState extends State<SavingsCard> {
  @override
  Widget build(BuildContext context) {
    DateTime dtDeposit = widget.depositModel?.inputDate ?? DateTime.now();
    DateTime dtCredit = widget.creditModel?.inputDate ?? DateTime.now();
    SavingsProvider savingsProvider = Provider.of<SavingsProvider>(context, listen: false);
    TextEditingController editController = TextEditingController(text: widget.depositModel?.deposit.toString() ?? widget.creditModel?.credit.toString());
    TextEditingController dateController = TextEditingController(text: (widget.isDeposit) ? DateFormat('yyyy-MM-dd').format(dtDeposit) : DateFormat('yyyy-MM-dd').format(dtCredit));
    TextEditingController hourController = TextEditingController(text: (widget.isDeposit) ? DateFormat('HH:mm:ss').format(dtDeposit) : DateFormat('HH:mm:ss').format(dtCredit));
    final box = Hive.box('box');

    handleEditDeposit() async {
      if (await savingsProvider.editDeposit(token: box.get('token'), id: widget.depositModel!.id, deposit: editController.text, inputDate: '${dateController.text} ${hourController.text}')) {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailSavingsPage(isDeposit: true, id: widget.depositModel!.studentId);
        }));
      }
    }

    handleEditCredit() async {
      if (await savingsProvider.editCredit(token: box.get('token'), id: widget.creditModel!.id, credit: editController.text, inputDate: '${dateController.text} ${hourController.text}')) {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailSavingsPage(isDeposit: false, id: widget.creditModel!.studentId);
        }));
      }
    }

    handleDelete() async {
      if (widget.isDeposit) {
        if (await savingsProvider.deleteDeposit(token: box.get('token'), id: widget.depositModel!.id)) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailSavingsPage(isDeposit: true, id: widget.depositModel!.studentId);
          }));
        }
      } else {
        if (await savingsProvider.deleteCredit(token: box.get('token'), id: widget.creditModel!.id)) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailSavingsPage(isDeposit: false, id: widget.creditModel!.studentId);
          }));
        }
      }
    }

    Future<void> showDialogEdit() async {
      return showDialog(barrierDismissible: false, context: context, builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Edit ${DateFormat('yMMMd').format((widget.isDeposit) ? dtDeposit : dtCredit)}', style: primaryTextStyle.copyWith(fontWeight: bold),)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Rp .', style: primaryTextStyle,),
                  Expanded(
                    child: TextFormField(
                      controller: editController,
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
            MaterialButton(onPressed: (widget.isDeposit) ? handleEditDeposit : handleEditCredit, color: Colors.green[600], child: Text('Edit', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
          ],
        );
      });
    }

    Future<void> showDialogDelete() async {
      return showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Center(child: Text((widget.isDeposit) ? 'Hapus Pemasukan' : 'Hapus Pengeluaran', style: primaryTextStyle.copyWith(fontWeight: bold),)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateFormat('yMMMMd').format((widget.isDeposit) ? dtDeposit : dtCredit), style: primaryTextStyle,),
              Text((widget.isDeposit) ? 'Rp. ${widget.depositModel!.deposit}' : 'Rp. ${widget.creditModel!.credit}' , style: primaryTextStyle,),
            ],
          ),
          actions: [
            MaterialButton(onPressed: () {
              Navigator.pop(context);
            }, color: backgroundColorPrimary, child: Text('Cancel', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
            MaterialButton(onPressed: handleDelete, color: Colors.green[600], child: Text('Hapus', style: secondaryTextStyle.copyWith(fontWeight: bold),),),
          ],
        );
      });
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(defaultMargin),
      decoration: BoxDecoration(
        color: tertiaryTextColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((widget.isDeposit) ? DateFormat.yMMMMd('id_ID').format(dtDeposit) : DateFormat('yMMMMd').format(dtCredit), style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
                Text((widget.isDeposit) ? 'Pemasukan' : 'Pengeluaran', style: redTextStyle.copyWith(fontWeight: bold),),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text((widget.isDeposit) ? 'Rp. ${widget.depositModel!.deposit}' : 'Rp. ${widget.creditModel!.credit}', style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
              Text((widget.isDeposit) ? DateFormat('HH:mm:ss').format(dtDeposit) : DateFormat('HH:mm:ss').format(dtCredit), style: redTextStyle.copyWith(fontWeight: bold),),
            ],
          ),
          const SizedBox(width: 10,),
          Column(
            children: [
              GestureDetector(onTap: showDialogEdit, child: Icon(Icons.edit, size: 20, color: Colors.green[600],)),
              const SizedBox(height: 10,),
              GestureDetector(onTap: showDialogDelete, child: Icon(Icons.delete, size: 20, color: backgroundColorPrimary,)),
            ],
          ),
        ],
      ),
    );
  }
}
