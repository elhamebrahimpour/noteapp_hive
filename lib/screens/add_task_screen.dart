import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp_hive/constants/app_colors.dart';
import 'package:noteapp_hive/custom-widgets/task_type_item.dart';
import 'package:noteapp_hive/model/task.dart';
import 'package:noteapp_hive/utilities/utilities.dart';
import 'package:time_pickerr/time_pickerr.dart';

class AddTaskSreen extends StatefulWidget {
  const AddTaskSreen({Key? key}) : super(key: key);

  @override
  State<AddTaskSreen> createState() => _AddTaskSreenState();
}

class _AddTaskSreenState extends State<AddTaskSreen> {
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _subTitleFocusNode = FocusNode();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();

  //get box to put data in it
  var taskBox = Hive.box<Task>('taskBox');

  DateTime? _taskTime;

  int _selectedItemIndex = 0;

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(() {
      setState(() {});
    });
    _subTitleFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.greenColor,
        elevation: 0,
        title: Text(
          'افزودن تسک جدید',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.whiteColor, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            _getTextField(
                'عنوان', 'عنوان تسک', _titleFocusNode, 1, _titleController),
            const SizedBox(
              height: 24,
            ),
            _getTextField('توضیحات', 'توضیحات تسک', _subTitleFocusNode, 2,
                _subTitleController),
            const SizedBox(
              height: 24,
            ),
            OutlinedButton(
              onPressed: () {
                showModalBottomSheet(
                  barrierColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: ((context) {
                    return _getTaskTimeWidget();
                  }),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'انتخاب زمان',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'دسته بندی',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
                const Divider(
                  color: AppColors.greenColor,
                  thickness: 2,
                  indent: 260,
                  endIndent: 18,
                ),
                const SizedBox(
                  height: 12,
                ),
                //category list
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    height: 102,
                    margin: const EdgeInsets.only(right: 8, bottom: 8),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: getTaskTypeList().length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () => setState(() {
                              _selectedItemIndex = index;
                            }),
                            child: TaskTypeItemWidget(
                              taskType: getTaskTypeList()[index],
                              index: index,
                              selectedItemIndex: _selectedItemIndex,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ElevatedButton(
                onPressed: () {
                  addTask(_titleController.text, _subTitleController.text);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenColor,
                  minimumSize: const Size(178, 48),
                ),
                child: const Text(
                  'افزودن تسک',
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getTaskTimeWidget() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 380,
        decoration: const BoxDecoration(
          color: AppColors.greenColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: CustomHourPicker(
          title: 'انتخاب زمان انجام تسک',
          negativeButtonText: 'حذف زمان',
          positiveButtonText: 'انتخاب زمان',
          titleStyle: const TextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 18),
          negativeButtonStyle: const TextStyle(
              color: AppColors.redColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Shabnam'),
          positiveButtonStyle: const TextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Shabnam'),
          elevation: 0,
          onPositivePressed: (context, time) {
            _taskTime = time;
          },
          onNegativePressed: (context) {
            if (kDebugMode) {
              print('onNegative');
            }
          },
        ),
      ),
    );
  }

  addTask(String taskTitle, String taskSubTitle) {
    var task = Task(
      title: taskTitle,
      subTitle: taskSubTitle,
      time: _taskTime!,
      taskType: getTaskTypeList()[_selectedItemIndex],
    );
    taskBox.add(task);
  }

  Widget _getTextField(String str1, String str2, FocusNode focusNode,
      int maxLines, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 44, top: 12),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.blackColor),
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  const BorderSide(width: 2, color: AppColors.greyColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 3,
                color: AppColors.greenColor,
              ),
            ),
            labelText: str1,
            labelStyle: TextStyle(
                color: focusNode.hasFocus
                    ? AppColors.greenColor
                    : AppColors.greyColor,
                fontSize: 18),
            hintText: str2,
            hintStyle: const TextStyle(color: AppColors.greyColor),
          ),
        ),
      ),
    );
  }
}
