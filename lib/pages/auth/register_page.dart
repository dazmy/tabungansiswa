import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/providers/auth_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:tabungan_siswa/util/loading_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<int> classGrade = [1, 2, 3, 4, 5, 6];
  int dropdownValue = 1;
  List<String> selectGrade = ['Pilih Kelas', '1', '2A', '2B', '3', '4A', '4B', '5', '6'];
  String dropdownValueSelect = 'Pilih Kelas';

  bool isSee = false;
  bool isSee2 = false;
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Future<void> customShowDialog(String text, Function()? onPressed, String textButton) async {
      return showDialog(barrierDismissible: false, context: context, builder: (context) {
        return AlertDialog(

          title: Text(text, style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
          actions: [
            MaterialButton(onPressed: onPressed, child: Text(textButton, style: primaryTextStyle.copyWith(fontWeight: bold),),)
          ],
        );
      });
    }

    handleRegister() async {
      setState(() {
        isLoading = true;
      });

      try {
        if (dropdownValueSelect != 'Pilih Kelas') {
          int grade = 0;
          if(dropdownValueSelect == '1') grade = 1;
          if(dropdownValueSelect == '2A') grade = 2;
          if(dropdownValueSelect == '2B') grade = 3;
          if(dropdownValueSelect == '3') grade = 4;
          if(dropdownValueSelect == '4A') grade = 5;
          if(dropdownValueSelect == '4B') grade = 6;
          if(dropdownValueSelect == '5') grade = 7;
          if(dropdownValueSelect == '6') grade = 8;
          if (await authProvider.register(name: nameController.text, grade: grade, username: usernameController.text, password: passwordController.text, passwordConfirm: passwordConfirmController.text)) {
           customShowDialog('Berhasil Daftar', () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false), 'Login');
          } else {
            customShowDialog('Silakan Isi Dengan Benar', () => Navigator.pop(context), 'Kembali');
          }
        } else {
          customShowDialog('Silakan Isi Dengan Benar', () => Navigator.pop(context), 'Kembali');
        }
      } catch (e) {
        customShowDialog('Gagal Daftar', () => Navigator.pop(context), 'Kembali');
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget textInfo() {
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          children: [
            Text('Tabungan Siswa', style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
            const SizedBox(height: 15,),
            Text('Silakan Daftar Sebagai Guru', style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),)
          ],
        ),
      );
    }

    Widget nameInput() {
      return Container(
        height: 50,
        margin: EdgeInsets.only(top: defaultMargin + 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: formFieldColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: nameController,
                style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),
                decoration: InputDecoration.collapsed(
                  hintText: 'Nama',
                  hintStyle: tertiaryTextStyle,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Icon(Icons.person, color: primaryTextColor, size: 30,)
          ],
        ),
      );
    }

    // Widget classInput() {
    //   return Container(
    //     // height: 50,
    //     margin: EdgeInsets.only(top: defaultMargin),
    //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(12),
    //       color: formFieldColor,
    //     ),
    //     child: DropdownButtonFormField(
    //       decoration: const InputDecoration(border: InputBorder.none),
    //       value: dropdownValue,
    //       style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),
    //       items: classGrade.map((e) {
    //         return DropdownMenuItem(value: e,child: Text(e.toString(), style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),),);
    //       }).toList(),
    //       onChanged: (v) {
    //         dropdownValue = v!;
    //         print(dropdownValue);
    //       },
    //     ),
    //   );
    // }

    Widget classV2Input() {
      return Container(
        // height: 50,
        margin: EdgeInsets.only(top: defaultMargin),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: formFieldColor,
        ),
        child: DropdownButton<String>(
          value: dropdownValueSelect,
          isExpanded: true,
          underline: const SizedBox(),
          style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),
          onChanged: (String? v) {
            setState(() {
              dropdownValueSelect = v!;
            });
          },
          items: selectGrade.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            );
          }).toList(),
        ),
      );
    }

    Widget usernameInput() {
      return Container(
        height: 50,
        margin: EdgeInsets.only(top: defaultMargin),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: formFieldColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: usernameController,
                style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),
                decoration: InputDecoration.collapsed(
                  hintText: 'Username',
                  hintStyle: tertiaryTextStyle,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Icon(Icons.account_circle, color: primaryTextColor, size: 30,)
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        height: 50,
        margin: EdgeInsets.only(top: defaultMargin),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: formFieldColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: passwordController,
                obscureText: (isSee) ? false : true,
                style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),
                decoration: InputDecoration.collapsed(
                  hintText: 'Password',
                  hintStyle: tertiaryTextStyle,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            GestureDetector(onTap: () {
              setState(() {
                isSee = !isSee;
              });
            }, child: Icon((isSee) ? Icons.visibility : Icons.visibility_off, color: primaryTextColor, size: 30,))
          ],
        ),
      );
    }

    Widget passwordConfirmInput() {
      return Container(
        height: 50,
        margin: EdgeInsets.only(top: defaultMargin),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: formFieldColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: passwordConfirmController,
                obscureText: (isSee2) ? false : true,
                style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),
                decoration: InputDecoration.collapsed(
                  hintText: 'Konfirmasi Password',
                  hintStyle: tertiaryTextStyle,
                ),
              ),
            ),
            const SizedBox(width: 10,),
            GestureDetector(onTap: () {
              setState(() {
                isSee2 = !isSee2;
              });
            }, child: Icon((isSee2) ? Icons.visibility : Icons.visibility_off, color: primaryTextColor, size: 30,))
          ],
        ),
      );
    }

    Widget registerButton() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin + 10),
        height: 70,
        width: double.infinity,
        child: TextButton(
          onPressed: handleRegister,
          style: TextButton.styleFrom(
              backgroundColor: backgroundColorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              )
          ),
          child: Text('Daftar', style: secondaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
        ),
      );
    }

    Widget toLogin() {
      return Container(
        height: MediaQuery.of(context).size.height * 0.238,
        alignment: FractionalOffset.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sudah punya akun ? ', style: primaryTextStyle.copyWith(fontSize: 18),),
            Flexible(
              child: GestureDetector(onTap: () {
                Navigator.pop(context);
              }, child: Text('Login disini', style: redTextStyle.copyWith(fontSize: 18),)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: ListView(
        padding: EdgeInsets.all(defaultMargin),
          children: [
            textInfo(),
            nameInput(),
            classV2Input(),
            usernameInput(),
            passwordInput(),
            passwordConfirmInput(),
            (isLoading) ? const LoadingButton() : registerButton(),
            toLogin(),
          ],
        ),
      ),
    );
  }
}
