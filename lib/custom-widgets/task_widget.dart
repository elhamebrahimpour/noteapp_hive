import 'package:flutter/material.dart';
import 'package:noteapp_hive/constants/app_colors.dart';
import 'package:noteapp_hive/model/task.dart';
import 'package:noteapp_hive/screens/edit_task_screen.dart';

class TaskWidget extends StatefulWidget {
  TaskWidget({Key? key, required this.task}) : super(key: key);
  Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool isBoxChecked = false;

  @override
  void initState() {
    super.initState();
    isBoxChecked = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return _getTaskItem();
  }

  Widget _getTaskItem() {
    return GestureDetector(
      onTap: () => setState(() {
        isBoxChecked = !isBoxChecked;
        widget.task.isDone = isBoxChecked;
        widget.task.save();
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        height: 144,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.greenColor, width: 1.5),
          color: AppColors.whiteColor,
        ),
        child: _getMainContent(),
      ),
    );
  }

  Widget _getMainContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: isBoxChecked,
                      onChanged: ((value) {}),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      checkColor: AppColors.whiteColor,
                      activeColor: AppColors.greenColor,
                    ),
                  ),
                  Text(widget.task.title,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                widget.task.subTitle,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  _getTimeAndEditContainer(
                    AppColors.greenColor,
                    AppColors.whiteColor,
                    _checkTimeUnderTen(widget.task.time),
                    'icon_time_16',
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => EditTaskScreen(
                              task: widget.task,
                            )),
                      ),
                    ),
                    child: _getTimeAndEditContainer(
                      AppColors.lightGreen,
                      AppColors.greenColor,
                      'ویرایش',
                      'icon_edit',
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Image.asset('images/${widget.task.taskType.image}'),
      ],
    );
  }

  Widget _getTimeAndEditContainer(
      Color color, Color textColor, String string, String iconName) {
    return Container(
      height: 28,
      width: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              string,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14, color: textColor),
            ),
            Image.asset('images/$iconName.png'),
          ],
        ),
      ),
    );
  }

  String _checkTimeUnderTen(DateTime time) {
    if (time.hour < 10 && time.minute < 10) {
      return '0${time.hour}:0${time.minute}';
    } else if (time.minute < 10) {
      return '${time.hour}:0${time.minute}';
    } else if (time.hour < 10) {
      return '0${time.hour}:${time.minute}';
    } else {
      return '${time.hour}:${time.minute}';
    }
  }
}
  //if we want to show time in a correct and common time format we can use this method
 /* String _getTimeHour(DateTime timeHour) {
    if (timeHour.hour < 10) {
      return '0${timeHour.hour}'; //changes 0:0 -> 00:00 or 1:6 -> 01:06
    } else {
      return timeHour.hour.toString();
    }
  }*/
//'${_getTimeHour(widget.task.time)}:${_getTimeMinute(widget.task.time)}',
