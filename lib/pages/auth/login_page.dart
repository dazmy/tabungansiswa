import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabungan_siswa/providers/auth_provider.dart';
import 'package:tabungan_siswa/theme.dart';
import 'package:tabungan_siswa/util/loading_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSee = false;
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    Future<void> errorLoginShowDialog(e) async {
      return showDialog(context: context, builder: (context) {
        return SimpleDialog(
          title: Center(child: Text(e, style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),)),
          children: const [
            SizedBox(),
          ],
        );
      });
    }

    handleLogin() async {
      setState(() {
        isLoading = true;
      });

      try {
        await authProvider.login(username: usernameController.text, password: passwordController.text);
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      } catch (e) {
        errorLoginShowDialog('Email atau Password Salah');
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget textInfo() {
      return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
        child: Column(
          children: [
            Text('Tabungan Siswa', style: primaryTextStyle.copyWith(fontSize: 30, fontWeight: bold),),
            const SizedBox(height: 15,),
            Text('Silakan Login', style: primaryTextStyle.copyWith(fontSize: 25, fontWeight: medium),)
          ],
        ),
      );
    }

    Widget emailInput() {
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

    Widget loginButton() {
      return Container(
        margin: EdgeInsets.only(top: defaultMargin + 10),
        height: 70,
        width: double.infinity,
        child: TextButton(
          onPressed: handleLogin,
          style: TextButton.styleFrom(
              backgroundColor: backgroundColorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              )
          ),
          child: Text('Login', style: secondaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),),
        ),
      );
    }

    Widget toRegister() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Belum punya akun ? ', style: primaryTextStyle.copyWith(fontSize: 18),),
          Flexible(
            child: GestureDetector(onTap: () {
              Navigator.pushNamed(context, '/register');
            }, child: Text('Daftar disini', style: redTextStyle.copyWith(fontSize: 18),)),
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(defaultMargin),
        child: Center(
          child: Column(
            children: [
              textInfo(),
              emailInput(),
              passwordInput(),
              (isLoading) ? const LoadingButton() : loginButton(),
              const Spacer(),
              toRegister(),
            ],
          ),
        ),
      ),
    );
  }
}
