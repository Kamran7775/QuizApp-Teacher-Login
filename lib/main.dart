import 'package:flutter/material.dart';
import 'package:teacher/screens/auth/splash_screen_page_view.dart';

main() {
  runApp(QuizAppTeacher());
}

class QuizAppTeacher extends StatefulWidget {
  const QuizAppTeacher({Key? key}) : super(key: key);

  @override
  State<QuizAppTeacher> createState() => _QuizAppTeacherState();
}

class _QuizAppTeacherState extends State<QuizAppTeacher> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kursun Adi',
      home: SplashScreen(),
    );
  }
}
