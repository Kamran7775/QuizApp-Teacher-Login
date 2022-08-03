import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher/models/student_get_request_model.dart';
import 'package:teacher/screens/auth/login_page_view.dart';
import 'package:teacher/screens/create_student_page_view.dart';
import 'package:teacher/screens/edit_student_page_view.dart';
import 'package:teacher/screens/password_change_page_view.dart';
import 'package:teacher/screens/teacher_message_page_view.dart';
import 'package:teacher/utils/network_util/network_util.dart';
import '../utils/themes/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Themes.primaryColor,
          elevation: 0,
          title: Text(
            "Tələbələrin Siyahısı",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
                iconSize: 30,
                color: Colors.white,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Mesaj",
                          style: TextStyle(color: Themes.primaryTextcolor)),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text("Şifrəni dəyiş",
                          style: TextStyle(color: Themes.primaryTextcolor)),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text("Çıxış",
                          style: TextStyle(color: Themes.primaryTextcolor)),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => TeacherMessageEdit()));
                  } else if (value == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordChange()));
                  } else if (value == 2) {
                    deleteAccesToken();
                  }
                }),
          ],
        ),
        body: FutureBuilder<List<StudentGetRequestModel>>(
          future: WebService.getStudent(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              List<StudentGetRequestModel>? data = snapshot.data;
              return Container(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: _getStudent(data));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: SpinKitCircle(
              size: 100,
              itemBuilder: (context, index) {
                final colors = [
                  Themes.primaryColor,
                  Themes.primaryTextcolor,
                  Colors.blue,
                  Themes.primaryColor,
                ];
                final color = colors[index % colors.length];
                return DecoratedBox(
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle));
              },
            ));
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CreateStudent()));
          },
          backgroundColor: Themes.primaryColor,
          label: Text(
            'Tələbə Qeydiyyatı',
            style: TextStyle(fontSize: 14),
          ),
          icon: Icon(Icons.add),
          splashColor: Themes.primaryTextcolor,
        ),
      ),
    );
  }

  deleteAccesToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('Authorization');
    await prefs.remove('isRemember');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  ListView _getStudent(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditStudentView(
                            userName: data[index].username,
                          )));
            },
            child: Card(
              elevation: 5,
              child: ListTile(
                title: Text(data[index].firstName + ' ' + data[index].lastName,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  data[index].username,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                leading: CircleAvatar(
                    backgroundColor: Themes.primaryColor,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                trailing: Container(
                  width: 155,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 50,
                        child: Row(),
                      ),
                      Expanded(
                        flex: 50,
                        child: data[index].isActive
                            ? Center(
                                child: Text('Aktiv',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              )
                            : Text(
                                'Aktiv deyil',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
