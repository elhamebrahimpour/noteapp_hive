import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp_hive/constants/app_colors.dart';
import 'package:noteapp_hive/model/task.dart';
import 'package:noteapp_hive/model/task_type.dart';
import 'package:noteapp_hive/model/task_type_enum.dart';
import 'package:noteapp_hive/screens/home_screen.dart';

void main() async {
  //initialize address for saving data
  await Hive.initFlutter();
  //create box and save data in this box in the future
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskTypeAdapter());
  Hive.registerAdapter(TaskTypeEnumAdapter());
  await Hive.openBox<Task>('taskBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(
              fontFamily: 'Shabnam',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.blackColor),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
