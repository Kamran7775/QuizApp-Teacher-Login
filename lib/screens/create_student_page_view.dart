import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:teacher/models/student_create_request_model.dart';
import 'package:teacher/screens/home_page_view.dart';
import 'package:teacher/utils/appsize/appsize.dart';
import 'package:teacher/utils/network_util/network_util.dart';
import 'package:teacher/widgets/button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../utils/themes/theme.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({Key? key}) : super(key: key);

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> {
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController fatherNameEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController finCodeEditingController = TextEditingController();

  bool _validateFirstName = false;
  bool _validateLastName = false;
  bool _validateFatherName = false;
  bool _validatePhoneNumber = false;
  bool _validateFinCode = false;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    firstNameEditingController.dispose();
    lastNameEditingController.dispose();
    fatherNameEditingController.dispose();
    phoneNumberEditingController.dispose();
    finCodeEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Themes.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: Icon(
              Icons.keyboard_backspace_outlined,
              size: 30,
              color: Themes.primaryTextcolor,
            ),
          ),
          title: Text(
            "Qeydiyyat",
            style: TextStyle(color: Themes.primaryTextcolor, fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 70),
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
                        borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        CustomTextFieldWidget(
                          labelText: "Adı",
                          textEditingController: firstNameEditingController,
                          validate: _validateFirstName,
                          errorText: 'Bu xana boş qala bilməz',
                        ),
                        SizedBox(height: 13),
                        CustomTextFieldWidget(
                          labelText: "Soyadı",
                          textEditingController: lastNameEditingController,
                          validate: _validateLastName,
                          errorText: 'Bu xana boş qala bilməz',
                        ),
                        SizedBox(height: 13),
                        CustomTextFieldWidget(
                          labelText: "Ata adı",
                          textEditingController: fatherNameEditingController,
                          validate: _validateFatherName,
                          errorText: 'Bu xana boş qala bilməz',
                        ),
                        SizedBox(height: 13),
                        CustomTextFieldWidget(
                          labelText: "Nömrəsi",
                          textEditingController: phoneNumberEditingController,
                          validate: _validatePhoneNumber,
                          errorText: 'Bu xana boş qala bilməz',
                        ),
                        SizedBox(height: 13),
                        CustomTextFieldWidget(
                          labelText: "Fin kodu",
                          textEditingController: finCodeEditingController,
                          validate: _validateFinCode,
                          errorText:
                              (finCodeEditingController.text.isEmpty == true)
                                  ? "Bu xana boş qala bilməz"
                                  : "Fin kod 7 simvol olmalıdı",
                          maxLength: 7,
                        ),
                        SizedBox(height: 20),
                        (_isLoading == false)
                            ? Container(
                                height: 50,
                                width: 150,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        firstNameEditingController.text.isEmpty
                                            ? _validateFirstName = true
                                            : _validateFirstName = false;
                                        lastNameEditingController.text.isEmpty
                                            ? _validateLastName = true
                                            : _validateLastName = false;
                                        fatherNameEditingController.text.isEmpty
                                            ? _validateFatherName = true
                                            : _validateFatherName = false;
                                        phoneNumberEditingController
                                                .text.isEmpty
                                            ? _validatePhoneNumber = true
                                            : _validatePhoneNumber = false;
                                        (finCodeEditingController
                                                    .text.isEmpty ||
                                                finCodeEditingController
                                                        .text.length !=
                                                    7)
                                            ? _validateFinCode = true
                                            : _validateFinCode = false;
                                        if (_validateFirstName == false &&
                                            _validateLastName == false &&
                                            _validateFatherName == false &&
                                            _validatePhoneNumber == false &&
                                            _validateFinCode == false) {
                                          studentCreate();
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Əlavə et",
                                      style: TextStyle(
                                          color: Themes.primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Themes.primaryColor
                                            .withOpacity(0.25),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Themes.primaryColor, width: 1)),
                              )
                            : SpinKitFadingCircle(color: Themes.primaryColor)
                      ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  studentCreate() async {
    setState(() {
      _isLoading = true;
    });
    StudentCreateRequestModel studentCreateRequestModel =
        StudentCreateRequestModel(
            firstName: firstNameEditingController.text,
            lastName: lastNameEditingController.text,
            fatherName: fatherNameEditingController.text,
            phoneNumber: phoneNumberEditingController.text,
            finNumber: finCodeEditingController.text);
    var response = await WebService.studentCreate(studentCreateRequestModel);
    if (response == true) {
      setState(() {
        _isLoading = false;
      });
      showTopSnackBar(context,
          CustomSnackBar.success(message: 'Tələbə uğurla əlavə edildi'));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setState(() {
        _isLoading = false;
      });
      showTopSnackBar(context, CustomSnackBar.error(message: 'Xəta baş verdi'));
    }
  }
}
