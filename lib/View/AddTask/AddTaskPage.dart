import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_app/Controllers/ProjectController.dart';
import 'package:todo_app/Dialogs.dart';
import 'package:todo_app/View/AddTask/AddDescriptionPage.dart';
import 'package:todo_app/View/HomePage.dart';
import 'package:todo_app/Statics/Colors.dart';
import 'package:todo_app/Statics/Statics.dart';
import 'package:todo_app/Statics/Texts.dart';

class AddTaskPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final String projectName;
  final int projectId;
  final List<dynamic> tasks;
  final int projectTaskDone;
  final int projectColor;
  final int index;
  final bool edit;

  AddTaskPage(
      {this.task,
      this.projectName,
      this.tasks,
      this.projectColor,
      this.projectId,
      this.projectTaskDone,
      this.index,
      this.edit = false});
  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController title = TextEditingController();
  bool isFirstTime = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ColorsStatic.selectedColor = ColorsStatic.profileColor;
    if (widget.task != null) {
      title.text = widget.task['task_title'];
      ColorsStatic.selectedColor = Color(widget.task['task_color']);
    }
    if (widget.tasks == null) {
      Statics.addedTask.clear();
    } else {
      Statics.addedTask = widget.tasks;
      isFirstTime = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsStatic.backgroundColor,
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.projectName != null && widget.projectId == null
                        ? InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 30,
                              color: ColorsStatic.topPageTitleColor,
                            ),
                          )
                        : Container(),
                    Text(
                     widget.task == null ? Texts.addTaskTitle : Texts.editTaskTitle,
                      style: TextStyle(
                          color: ColorsStatic.topPageTitleColor, fontSize: 20),
                    ),
                    widget.projectName != null && widget.projectId == null
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 43,
                              width: 43,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: ColorsStatic.topPageTitleColor)),
                              child: FittedBox(
                                  child: Icon(
                                Icons.close,
                                color: ColorsStatic.topPageTitleColor,
                              )),
                            ),
                          )
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Padding(
                      padding: EdgeInsets.only(left: 35, right: 80, top: 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: title,
                            onChanged: (text) {
                              setState(() {});
                            },
                            style: TextStyle(
                                fontSize: 22,
                                color: Statics.theme == 'litght'
                                    ? Colors.black
                                    : Colors.white),
                            decoration: InputDecoration(
                              hintText: Texts.addTaskTextFeild,
                              hintStyle: TextStyle(
                                  fontSize: 22,
                                  color: ColorsStatic.textFeildColor),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorsStatic.profileColor,
                                      width: 2)),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorsStatic.textFeildColor
                                          .withOpacity(0.5),
                                      width: 2)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorsStatic.textFeildColor
                                          .withOpacity(0.5),
                                      width: 2)),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Container(
                                height: 45,
                                width: 120,
                                padding: EdgeInsets.all(Statics.appTextDirection == TextDirection.rtl ? 7: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsStatic.textFeildColor
                                            .withOpacity(0.3),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(100)),
                                child: FittedBox(
                                  child: Text(
                                    Texts.addTaskDate,
                                    style: TextStyle(
                                        color: ColorsStatic.textFeildColor
                                            .withOpacity(0.7)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Dialogs.showColorsDialog(
                                    context,
                                    refresh: setState,
                                  );
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: ColorsStatic.textFeildColor
                                              .withOpacity(0.5),
                                          width: 2),
                                      shape: BoxShape.circle),
                                  child: FittedBox(
                                      child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: ColorsStatic.selectedColor,
                                        shape: BoxShape.circle),
                                  )),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            widget.projectName != null &&
                                    Statics.addedTask.isNotEmpty &&
                                    !isFirstTime
                                ? InkWell(
                                    onTap: done,
                                    child: Container(
                                        height: 45,
                                        width: 110,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    ColorsStatic.profileColor),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        padding: EdgeInsets.all(10),
                                        child: FittedBox(
                                          child: Text(
                                            Texts.addDescDone,
                                            style: TextStyle(
                                                fontSize: 17,
                                                color:
                                                    ColorsStatic.profileColor),
                                          ),
                                        )),
                                  )
                                : Container(),
                            Spacer(),
                            Hero(
                              tag: 'add button',
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: next,
                                  child: Container(
                                      height: 45,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          color: title.text.isEmpty
                                              ? ColorsStatic.profileColor
                                                  .withOpacity(0.5)
                                              : ColorsStatic.profileColor,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      padding: EdgeInsets.all(9),
                                      child: FittedBox(
                                        child: Row(
                                          children: [
                                            Text(
                                              Texts.addTaskNext,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }

  done() async {
    List<String> tasks = [];
    Statics.addedTask.forEach((element) {
      String taskTitle = element['task_title'];
      String taskDesc = element['task_desc'];
      String taskColor = element['task_color'].toString();
      String taskIsDone = element['task_isDone'].toString();
      tasks.add(
          '{"task_title": "$taskTitle", "task_desc": "$taskDesc", "task_color": $taskColor, "task_isDone": $taskIsDone}');
    });
    FocusScope.of(context).unfocus();
    if (widget.projectId != null) {
      await ProjectsController().updateProject(
          widget.projectId,
          widget.projectName,
          tasks.toString(),
          widget.projectTaskDone,
          widget.projectColor);
      Navigator.pop(context);
    } else {
      await ProjectsController().insertProject(widget.projectName,
          tasks.toString(), ColorsStatic.projectSelectedColor.value);
      Dialogs.showSuccessDialog(context, Texts.projectCreateDialog);
      Timer(
        Duration(seconds: 1),
        () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    }
  }

  next() {
    if (title.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      print(widget.projectName);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddDescriptionPage(title,
                task: widget.task,
                projectColor: widget.projectColor,
                projectId: widget.projectId,
                projectTaskDone: widget.projectTaskDone,
                projectName: widget.projectName,
                index: widget.index,
                tasks: widget.tasks,
                edit: widget.edit),
          )).then((value) {
        if (widget.projectName != null && value == 'added') {
          setState(() {
            isFirstTime = false;
            ColorsStatic.selectedColor = Colors.blueAccent;
            title.clear();
            print(Statics.addedTask);
          });
        }
      });
    }
  }
}
