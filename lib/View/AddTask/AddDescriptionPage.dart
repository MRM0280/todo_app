import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Controllers/ProjectController.dart';
import 'package:todo_app/Controllers/TaskController.dart';
import 'package:todo_app/Dialogs.dart';
import 'package:todo_app/View/HomePage.dart';
import 'package:todo_app/Statics/Colors.dart';
import 'package:todo_app/Statics/Statics.dart';
import 'package:todo_app/Statics/Texts.dart';

class AddDescriptionPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final TextEditingController title;
  final String projectName;
  final List<dynamic> tasks;
  final int index;
  final int projectId;
  final int projectTaskDone;
  final int projectColor;
  final bool edit;

  AddDescriptionPage(this.title,
      {this.task,
      this.projectName,
      this.index,
      this.tasks,
      this.projectColor,
      this.projectId,
      this.projectTaskDone,
      this.edit});

  @override
  State<AddDescriptionPage> createState() => _AddDescriptionPageState();
}

class _AddDescriptionPageState extends State<AddDescriptionPage> {
  final TextEditingController desc = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      print(widget.task);
      desc.text = widget.task['task_desc'];
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
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios_rounded,
                      textDirection: TextDirection.ltr,
                      color: ColorsStatic.topPageTitleColor,
                      size: 30),
                ),
                Text(
                  Texts.addDescTitle,
                  style: TextStyle(
                      color: ColorsStatic.topPageTitleColor, fontSize: 19),
                ),
                Container()
              ],
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Padding(
                  padding: EdgeInsets.only(left: 35, right: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: desc,
                        minLines: 8,
                        maxLines: 8,
                        style: TextStyle(
                            fontSize: 22,
                            color: Statics.theme == 'litght'
                                ? Colors.black
                                : Colors.white),
                        decoration: InputDecoration(
                          hintText: Texts.addDescTextFeild,
                          hintStyle: TextStyle(
                              fontSize: 22, color: ColorsStatic.textFeildColor),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorsStatic.profileColor, width: 2)),
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
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Hero(
                          tag: 'add button',
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: done,
                              child: Container(
                                  height: 45,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      color: ColorsStatic.profileColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  padding: EdgeInsets.all(9),
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        Text(
                                          Texts.addDescDone,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        RotatedBox(
                                          quarterTurns: 1,
                                          child: Icon(
                                            Icons.arrow_back_ios_rounded,
                                            textDirection: TextDirection.ltr,
                                            color: Colors.white,
                                            size: 20,
                                          ),
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
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  done() async {
    FocusScope.of(context).unfocus();
    if (widget.projectName != null) {
      if (widget.tasks != null) {
        if (widget.edit) {
          Statics.addedTask.add({
            'task_title': widget.title.text,
            'task_desc': desc.text,
            'task_color': ColorsStatic.selectedColor.value,
            'task_isDone': false
          });
          Dialogs.showSuccessDialog(context, Texts.addTaskToProjectDialog);
          Timer(
            Duration(seconds: 1),
            () {
              Navigator.pop(context);
              Navigator.pop(context, 'added');
            },
          );
        } else {
          print(widget.index);
          widget.tasks[widget.index] = {
            'task_title': widget.title.text,
            'task_desc': desc.text,
            'task_color': ColorsStatic.selectedColor.value,
            'task_isDone': false
          };
          List<String> tasks = [];
          widget.tasks.forEach((element) {
            String taskTitle = element['task_title'];
            String taskDesc = element['task_desc'];
            String taskColor = element['task_color'].toString();
            String taskIsDone = element['task_isDone'].toString();
            tasks.add(
                '{"task_title": "$taskTitle", "task_desc": "$taskDesc", "task_color": $taskColor, "task_isDone": $taskIsDone}');
          });
          print(tasks.toString());
          await ProjectsController().updateProject(
              widget.projectId,
              widget.projectName,
              tasks.toString(),
              widget.projectTaskDone,
              widget.projectColor);
          Dialogs.showSuccessDialog(context, Texts.editTaskDialog);
          Timer(Duration(seconds: 1), () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
      } else {
        Statics.addedTask.add({
          'task_title': widget.title.text,
          'task_desc': desc.text,
          'task_color': ColorsStatic.selectedColor.value,
          'task_isDone': false
        });
        Dialogs.showSuccessDialog(context, Texts.addTaskToProjectDialog);
        Timer(
          Duration(seconds: 1),
          () {
            Navigator.pop(context);
            Navigator.pop(context, 'added');
          },
        );
      }
    } else if (widget.task != null) {
      await TasksController().updateTask(widget.task['id'], widget.title.text,
          desc.text, ColorsStatic.selectedColor.value);
      Dialogs.showSuccessDialog(context, Texts.editTaskDialog);
      Timer(
        Duration(seconds: 1),
        () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (route) => false);
        },
      );
    } else {
      await TasksController().insertTask(
          widget.title.text, desc.text, ColorsStatic.selectedColor.value);
      Dialogs.showSuccessDialog(context, Texts.addTaskDialog);
      Timer(
        Duration(seconds: 1),
        () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
              (route) => false);
        },
      );
    }
  }
}
