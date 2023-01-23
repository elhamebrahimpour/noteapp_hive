import 'package:flutter/material.dart';
import 'package:noteapp_hive/constants/app_colors.dart';
import 'package:noteapp_hive/model/task_type.dart';

class TaskTypeItemWidget extends StatelessWidget {
  TaskTypeItemWidget(
      {Key? key,
      required this.taskType,
      required this.index,
      required this.selectedItemIndex})
      : super(key: key);
  TaskType taskType;
  int index;
  int selectedItemIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6, left: 6, bottom: 6),
      width: 90,
      decoration: BoxDecoration(
        color: (selectedItemIndex == index)
            ? AppColors.greenColor
            : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (selectedItemIndex == index)
              ? AppColors.greenColor
              : AppColors.lightGreen,
          width: (selectedItemIndex == index) ? 3 : 2,
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'images/${taskType.image}',
            height: 60,
          ),
          Text(
            taskType.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: (selectedItemIndex == index)
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
                fontWeight: selectedItemIndex == index
                    ? FontWeight.w800
                    : FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
