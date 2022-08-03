import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher/models/login_request_model.dart';
import 'package:teacher/models/password_change_request_model.dart';
import 'package:teacher/models/student_create_request_model.dart';
import 'package:teacher/models/student_get_request_model.dart';
import 'package:teacher/models/student_request_model.dart';
import 'package:teacher/models/teacher_message_request_model.dart';
import 'package:teacher/utils/constans/urls.dart';

class WebService {
  static signIn(LoginRequestModel loginRequestModel, bool isRemember) async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.http(Urls.BASE_URL, Urls.LOGIN_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(loginRequestModel));
    if (response.statusCode == 200) {
      await prefs.setString('Authorization',
          '${json.decode(response.body.toString())['access']}');

      await prefs.setBool('isRemember', isRemember);

      return true;
    } else {
      return json.decode(response.body.toString())['detail'];
    }
  }

  static passwordChange(
      PasswordChangeRequestModel passwordChangeRequestModel) async {
    final prefs = await SharedPreferences.getInstance();
    final response =
        await http.put(Uri.http(Urls.BASE_URL, Urls.PASSWORD_CHANGE_URL),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${prefs.getString('Authorization')}'
            },
            body: json.encode(passwordChangeRequestModel));
    if (response.statusCode == 200) {
      await prefs.remove('Authorization');
      await prefs.remove('isRemember');
      return true;
    } else {
      return json.decode(response.body.toString())['detail'];
    }
  }

  static studentCreate(
      StudentCreateRequestModel studentCreateRequestModel) async {
    final prefs = await SharedPreferences.getInstance();
    final response =
        await http.post(Uri.http(Urls.BASE_URL, Urls.STUDENT_CREATER_URL),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ${prefs.getString('Authorization')}'
            },
            body: jsonEncode(studentCreateRequestModel));
    if (response.statusCode == 201) {
      return true;
    } else {
      return json.decode(response.body.toString())['detail'];
    }
  }

  static Future<List<StudentGetRequestModel>> getStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.http(Urls.BASE_URL, Urls.STUDENT_GET_URL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('Authorization')}'
      },
    );

    if (response.statusCode == 200) {
      List jsonresponse = json.decode(response.body);
      return jsonresponse
          .map((student) => StudentGetRequestModel.fromJson(student))
          .toList();
    } else {
      throw Exception('Error');
    }
  }

  static getStudentWithUserName(username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.http(Urls.BASE_URL, Urls.STUDENT_GET_URL + username),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('Authorization')}'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return false;
    }
  }

  static changeStudentData(
      StudentRequestModel studentRequestModel, username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.put(
      Uri.http(Urls.BASE_URL, Urls.STUDENT_GET_URL + username + '/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('Authorization')}'
      },
      body: jsonEncode(studentRequestModel),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static studentDelete(username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.delete(
      Uri.http(Urls.BASE_URL, Urls.STUDENT_DELETE_URL + username + '/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('Authorization')}'
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  static teacherMessageEdit(
      TeacherMessageRequestChangeModel teacherMessageRequestChangeModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.put(
      Uri.http(Urls.BASE_URL, Urls.TEACHER_MESSAGE_EDIT),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('Authorization')}'
      },
      body: jsonEncode(teacherMessageRequestChangeModel),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static teacherGetMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.http(Urls.BASE_URL, Urls.TEACHER_MESSAGE_EDIT),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('Authorization')}'
        });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw false;
    }
  }
}
