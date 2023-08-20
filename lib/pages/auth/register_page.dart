import 'package:cardapio/pages/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../../widgets/widgets.dart';
import '../qrcode/qrcode_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  String email = "";
  String password = "";
  String fullName = "";
  bool _isLoading = false;
  bool isShowPassword = true;
  bool isShowConfirmPassword = true;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90, // Set this height
          flexibleSpace: Container(
            color: const Color(0xFFFF6130),
            child: Column(
              children: const [
                SizedBox(
                  height: 60,
                ),
                Text('Criar conta',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFF2F2F7),
                    )),
              ],
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(144, 460, 20, 0),
                    child: Image.asset(
                      'assets/images/cutlery.png',
                      height: 373,
                      width: 226,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(95, 50, 94.94, 48),
                            child: Image.asset(
                              'assets/images/cardapio_web.png',
                              height: 60,
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
                                    labelText: "Nome de Usuário",
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      fullName = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Campo obrigatório";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
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
                                  controller: _pass,
                                  obscureText: isShowPassword,
                                  decoration: textInputDecoration.copyWith(
                                    labelText: "Senha",
                                    suffixIcon: CupertinoButton(
                                      child:  Icon(
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
                                    ),
                                  ),
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
                                  height: 16,
                                ),
                                TextFormField(
                                  obscureText: isShowConfirmPassword,
                                  decoration: textInputDecoration.copyWith(
                                    labelText: "Confirmar Senha",
                                    suffixIcon: CupertinoButton(
                                      child:  Icon(
                                        isShowConfirmPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Color(0xFFFF6130),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isShowConfirmPassword =
                                              !isShowConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Confirme a senha';
                                    }
                                    if (val != _pass.text) {
                                      return "As senhas não correspondem";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 182,
                                ),
                                SizedBox(
                                  width: 390,
                                  height: 62,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFFF6130),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25))),
                                    child: const Text(
                                      "Iniciar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: 22),
                                    ),
                                    onPressed: () {
                                      register();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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
