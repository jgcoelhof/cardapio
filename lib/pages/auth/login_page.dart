import 'package:cardapio/pages/auth/register_page.dart';
import 'package:cardapio/pages/product_page.dart';
import 'package:cardapio/pages/qrcode/qrcode_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../service/database_service.dart';
import '../../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  bool isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(95, 181, 94.94, 48),
                      child: Image.asset(
                        'assets/images/cardapio_web.png',
                        height: 68,
                        width: 200.05719,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(46, 0, 44, 20),
                      child: Column(
                        children: [
                          TextFormField(
                            style: textStyleInput,
                            decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                            ),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },

                            // check tha validation
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Insira um e-mail válido";
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            obscureText: isShowPassword,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Senha",
                                suffixIcon: CupertinoButton(
                                  child: Icon(
                                    isShowPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xFFFF6130),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isShowPassword = !isShowPassword;
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                )),
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Sua senha deve ter pelo menos 6 caracteres";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          SizedBox(
                            width: 390,
                            height: 62,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF6130),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              child: const Text(
                                "Entrar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                login();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 29, 0, 25),
                            child: Row(children: [
                              Container(
                                height: 1,
                                width: 134,
                                color: Color(0xFFFF6130),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text("ou",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFFF6130),
                                  )),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                height: 1,
                                width: 134,
                                color: Color(0xFFFF6130),
                              ),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(75, 0, 0, 143),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/google_login.png',
                                  height: 62,
                                ),
                                SizedBox(
                                  width: 27,
                                ),
                                Image.asset(
                                  'assets/images/apple_login.png',
                                  height: 62,
                                ),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: "Não possui conta? ",
                              style: const TextStyle(
                                  color: Color(0xFFFF6130), fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Crie agora",
                                    style: const TextStyle(
                                        color: Color(0xFFFF6130),
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(
                                            context, const RegisterPage());
                                      }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, const QrCodePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
