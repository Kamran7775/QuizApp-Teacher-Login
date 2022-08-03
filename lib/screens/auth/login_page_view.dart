import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:teacher/models/login_request_model.dart';
import 'package:teacher/screens/home_page_view.dart';
import 'package:teacher/utils/appsize/appsize.dart';
import 'package:teacher/utils/network_util/network_util.dart';
import 'package:teacher/utils/themes/theme.dart';
import 'package:teacher/widgets/button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool _validateUsername = false;
  bool _validatePassword = false;
  bool _checkBox = false;
  bool _isLoading = false;
  bool _isObcuse = true;
  @override
  void dispose() {
    super.dispose();
    userNameEditingController.dispose();
    passwordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Themes.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: (MediaQuery.of(context).size.width < 550)
                          ? AppSize.calculateWidth(context, 400)
                          : AppSize.calculateWidth(context, 200),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Themes.primaryColor.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 25),
                          child: CustomTextFieldWidget(
                            labelText: 'İsdifadəçi Adı',
                            prefix: Icon(
                              Icons.person,
                              color: Themes.primaryTextcolor,
                            ),
                            textEditingController: userNameEditingController,
                            validate: _validateUsername,
                            errorText: 'Bu xana boş qala bilməz',
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: CustomTextFieldWidget(
                              prefix: Icon(
                                Icons.vpn_key,
                                color: Themes.primaryTextcolor,
                              ),
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObcuse = !_isObcuse;
                                  });
                                },
                                icon: Icon(
                                  (_isObcuse)
                                      ? (Icons.visibility)
                                      : (Icons.visibility_off),
                                  color: Themes.primaryTextcolor,
                                ),
                              ),
                              labelText: "Şifrəniz",
                              obscureText: _isObcuse,
                              textEditingController: passwordEditingController,
                              validate: _validatePassword,
                              errorText: 'Bu xana boş qala bilməz',
                            )),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Yadda saxla',
                                style:
                                    TextStyle(color: Themes.primaryTextcolor),
                              ),
                              Checkbox(
                                fillColor: MaterialStateProperty.all(
                                    Themes.primaryColor),
                                activeColor: Themes.primaryColor,
                                value: _checkBox,
                                onChanged: (value) {
                                  setState(() {
                                    _checkBox = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        (_isLoading == false)
                            ? SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 25),
                                    child: CustomButtom(
                                      textButton: "Daxil ol",
                                      click: () {
                                        setState(() {
                                          userNameEditingController.text.isEmpty
                                              ? _validateUsername = true
                                              : _validateUsername = false;
                                          passwordEditingController.text.isEmpty
                                              ? _validatePassword = true
                                              : _validatePassword = false;
                                        });

                                        if (_validateUsername == false &&
                                            _validatePassword == false) {
                                          login();
                                        }
                                      },
                                    )))
                            : SpinKitFadingCircle(
                                color: Themes.primaryColor,
                              ),
                      ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    setState(() {
      _isLoading = true;
    });
    LoginRequestModel loginRequestModel = LoginRequestModel(
        username: userNameEditingController.text,
        password: passwordEditingController.text);
    var response = await WebService.signIn(loginRequestModel, _checkBox);
    if (response == true) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setState(() {
        _isLoading = false;
      });
      showTopSnackBar(
          context, CustomSnackBar.error(message: "Xeta bas verdi!"));
    }
  }
}
