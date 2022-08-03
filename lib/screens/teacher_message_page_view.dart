import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:teacher/models/teacher_message_request_model.dart';
import 'package:teacher/utils/network_util/network_util.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../utils/appsize/appsize.dart';
import '../../utils/themes/theme.dart';
import '../../widgets/button.dart';
import 'home_page_view.dart';

class TeacherMessageEdit extends StatefulWidget {
  const TeacherMessageEdit({Key? key}) : super(key: key);

  @override
  State<TeacherMessageEdit> createState() => _TeacherMessageEditState();
}

class _TeacherMessageEditState extends State<TeacherMessageEdit> {
  TextEditingController teacherMessageEditController = TextEditingController();
  bool _validateTeacherMessage = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  @override
  void dispose() {
    teacherMessageEditController.dispose();
    super.dispose();
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
                            padding: const EdgeInsets.all(25),
                            child: CustomTextFieldWidget(
                              maxLiness: 3,
                              textEditingController:
                                  teacherMessageEditController,
                              validate: _validateTeacherMessage,
                              errorText: 'Bu xana boş qala bilməz',
                              labelText: 'Mesajı dəyişin',
                            ),
                          ),
                          SizedBox(height: 10),
                          (_isLoading == false)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 25),
                                  child: CustomButtom(
                                      textButton: 'Dəyiş',
                                      click: () {
                                        editTeacherMessage();
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

  getMessage() async {
    var response = await WebService.teacherGetMessage();
    if (response != false) {
      setState(() {
        teacherMessageEditController.text =
            response["membership_expired_message"];
      });
    } else {}
  }

  editTeacherMessage() async {
    setState(() {
      teacherMessageEditController.text.isEmpty
          ? _validateTeacherMessage = true
          : _validateTeacherMessage = false;
    });
    if (_validateTeacherMessage == false) {
      setState(() {
        _isLoading = true;
      });
      TeacherMessageRequestChangeModel teacherMessageRequestChangeModel =
          TeacherMessageRequestChangeModel(
              membershipExpiredMessage: teacherMessageEditController.text);
      var response =
          await WebService.teacherMessageEdit(teacherMessageRequestChangeModel);
      if (response == true) {
        setState(() {
          _isLoading = false;
        });
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Mesaj uğurla dəyişdirildi",
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        showTopSnackBar(
            context,
            CustomSnackBar.error(
                message: "Mesaj dəyişdirilərkən problem yaşandı"));
      }
    }
  }
}
