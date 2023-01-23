import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp_hive/constants/app_colors.dart';
import 'package:noteapp_hive/custom-widgets/task_widget.dart';
import 'package:noteapp_hive/model/task.dart';
import 'package:noteapp_hive/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  //get box to put data in it
  var taskBox = Hive.box<Task>('taskBox');
  bool _isFabVisible = true;

  List<Task> taskList = [];
  bool _isSearchingInProgress = false;

  @override
  void initState() {
    super.initState();

    List<Task> taskList = taskBox.values.toList();
    setState(() {
      taskList = taskList;
    });

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      appBar: AppBar(
        backgroundColor: AppColors.greenColor,
        elevation: 0,
        title: Text(
          'برنامه ریز تسک ها',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.whiteColor, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 14, bottom: 10, left: 14, right: 14),
            child: _getSearchContainer(),
          ),
          Expanded(
            child: _getMainBody(),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isFabVisible,
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<Task>(
              builder: ((context) => const AddTaskSreen()),
            ),
          ),
          backgroundColor: AppColors.greenColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _getSearchContainer() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 255, 254),
        border: Border.all(color: AppColors.lightGreen, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Expanded(
              child: TextField(
                cursorColor: AppColors.greenColor,
                focusNode: _focusNode,
                controller: _textEditingController,
                style: const TextStyle(color: AppColors.blackColor),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  hintText: 'جستجوی تسک...',
                  hintStyle: TextStyle(color: AppColors.greyColor),
                ),
                onChanged: (value) {
                  _onSearchAction(value);
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: AppColors.greyColor,
            ),
          )
        ],
      ),
    );
  }

  _onSearchAction(String keyWord) {
    List<Task> filteredList = [];
    if (keyWord.isEmpty) {
      setState(() {});
      List<Task> updatedList = taskBox.values.toList();
      setState(() {
        taskList = updatedList;
        _isSearchingInProgress = false;
      });
      FocusScope.of(context).unfocus();
      return;
    }
    filteredList = taskBox.values
        .toList()
        .where((element) =>
            element.title.toLowerCase().contains(keyWord.toLowerCase()))
        .toList();
    setState(() {
      taskList = filteredList;
      _isSearchingInProgress = true;
    });
  }

  Widget _getMainBody() {
    return SafeArea(
      // NotificationListener -> this widget helps us to change
      // the visibility of FAB when scrolls the list
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.direction == ScrollDirection.forward) {
              _isFabVisible = true;
            }
            if (notification.direction == ScrollDirection.reverse) {
              _isFabVisible = false;
            }
          });
          return true;
        },
        child: ValueListenableBuilder(
          //box.listenable works as a valueNotifier in hive database
          valueListenable: taskBox.listenable(),
          builder: ((context, value, child) => ListView.builder(
                //get taskbox length from hive db
                itemCount: _isSearchingInProgress
                    ? taskList.length
                    : taskBox.values.length,
                itemBuilder: ((context, index) {
                  var task = _isSearchingInProgress
                      ? taskList[index]
                      : taskBox.values.toList()[index];
                  return _getTaskItem(task);
                }),
              )),
        ),
      ),
    );
  }

//use dismissable widget to slide item and delete it
  Widget _getTaskItem(Task task) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        task.delete();
      },
      child: TaskWidget(
        task: task,
      ),
    );
  }
}
