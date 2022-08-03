import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:teacher/models/password_change_request_model.dart';
import 'package:teacher/screens/auth/login_page_view.dart';
import 'package:teacher/screens/home_page_view.dart';
import 'package:teacher/utils/network_util/network_util.dart';
import 'package:teacher/widgets/button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../utils/appsize/appsize.dart';
import '../utils/themes/theme.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key? key}) : super(key: key);

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  TextEditingController oldPassordChangeEditingController =
      TextEditingController();
  TextEditingController newPassordChangeEditingController =
      TextEditingController();
  TextEditingController reNewPassordChangeEditingController =
      TextEditingController();

  bool _validateOldPassword = false;
  bool _validateNewPassword = false;
  bool _validateReNewPassword = false;
  bool _isLoading = false;
  bool reNewPassword = true;
  @override
  void dispose() {
    super.dispose();
    oldPassordChangeEditingController.dispose();
    newPassordChangeEditingController.dispose();
    reNewPassordChangeEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Themes.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace_outlined,
              size: 30,
              color: Themes.primaryColor,
            ),
          ),
          elevation: 0,
          backgroundColor: Themes.scaffoldBackgroundColor,
        ),
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
                            color: Themes.primaryColor.withOpacity(0.25),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 25),
                            child: CustomTextFieldWidget(
                              textEditingController:
                                  oldPassordChangeEditingController,
                              validate: _validateOldPassword,
                              errorText: 'Bu xana boş qala bilməz',
                              labelText: 'Köhnə şifrə',
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: CustomTextFieldWidget(
                              textEditingController:
                                  newPassordChangeEditingController,
                              validate: _validateNewPassword,
                              errorText: 'Bu xana boş qala bilməz',
                              labelText: 'Yeni şifrə',
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: CustomTextFieldWidget(
                              textEditingController:
                                  reNewPassordChangeEditingController,
                              validate: _validateReNewPassword,
                              errorText: (reNewPassword == true)
                                  ? 'Bu xana boş qala bilməz'
                                  : 'Şifrələr eyniləşməlidir',
                              labelText: 'Təkrar yeni şifrə',
                            ),
                          ),
                          SizedBox(height: 25),
                          (_isLoading == false)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 25),
                                  child: CustomButtom(
                                      textButton: 'Dəyiş',
                                      click: () {
                                        changePassword();
                                      }),
                                )
                              : SpinKitFadingCircle(color: Themes.primaryColor)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  changePassword() async {
    setState(() {
      oldPassordChangeEditingController.text.isEmpty
          ? _validateOldPassword = true
          : _validateOldPassword = false;
      newPassordChangeEditingController.text.isEmpty
          ? _validateNewPassword = true
          : _validateNewPassword = false;
      reNewPassordChangeEditingController.text.isEmpty
          ? _validateReNewPassword = true
          : _validateReNewPassword = false;
    });
    if (_validateOldPassword == false &&
        _validateNewPassword == false &&
        _validateReNewPassword == false) {
      if (reNewPassordChangeEditingController.text ==
          newPassordChangeEditingController.text) {
        setState(() {
          _isLoading = true;
        });
        PasswordChangeRequestModel passwordChangeRequestModel =
            PasswordChangeRequestModel(
                oldPassword: oldPassordChangeEditingController.text,
                newPassword: newPassordChangeEditingController.text);
        var response =
            await WebService.passwordChange(passwordChangeRequestModel);
        if (response == true) {
          setState(() {
            _isLoading = false;
          });
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "Şifrə uğurla dəyişdirildi",
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                  message: "Şifrə dəyişdirilərkən problem yaşandı"));
        }
      } else {
        setState(() {
          _validateReNewPassword = true;
          reNewPassword = false;
        });
      }
    }
  }
}
