import 'package:flutter/material.dart';
import 'package:todo_app/Controllers/ProjectController.dart';
import 'package:todo_app/Dialogs.dart';
import 'package:todo_app/View/AddTask/AddTaskPage.dart';
import 'package:todo_app/Statics/Colors.dart';
import 'package:todo_app/Statics/Statics.dart';
import 'package:todo_app/Statics/Texts.dart';

class AddProjectPage extends StatefulWidget {
  final int projectId;
  final String projectName;
  final String projectTasks;
  final int projectTaskDone;
  final Color projectColor;

  AddProjectPage(
      {this.projectId,
      this.projectName,
      this.projectTaskDone,
      this.projectTasks,
      this.projectColor});
  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final TextEditingController projectName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.projectId != null) {
      projectName.text = widget.projectName;
      ColorsStatic.projectSelectedColor = widget.projectColor;
    } else {
      ColorsStatic.projectSelectedColor = Colors.blueAccent;
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
                    Container(),
                    Text(
                      widget.projectId == null
                          ? Texts.addProjectPageTitle
                          : Texts.editProjectPageTitle,
                      style: TextStyle(
                          color: ColorsStatic.topPageTitleColor, fontSize: 20),
                    ),
                    InkWell(
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
                            controller: projectName,
                            onChanged: (text) {
                              setState(() {});
                            },
                            style: TextStyle(
                                fontSize: 25,
                                color: Statics.theme == 'litght'
                                    ? Colors.black
                                    : Colors.white),
                            decoration: InputDecoration(
                              hintText: Texts.addProjectTextFeild,
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
                              InkWell(
                                onTap: () {
                                  Dialogs.showColorsDialog(context,
                                      refresh: setState, isForProject: true);
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
                                        color:
                                            ColorsStatic.projectSelectedColor,
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
                            Hero(
                              tag: 'add button',
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: btn,
                                  child: Container(
                                      height: 45,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          color: projectName.text.isEmpty
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
                                              widget.projectId != null
                                                  ? Texts.addProjectEdit
                                                  : Texts.addTaskNext,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            RotatedBox(
                                              quarterTurns:
                                                  widget.projectId != null
                                                      ? 3
                                                      : 0,
                                              child: Icon(
                                                Icons.arrow_forward_ios_rounded,
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
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }

  btn() {
    if (projectName.text.isNotEmpty) {
      if (widget.projectId != null) {
        ProjectsController().updateProject(
            widget.projectId,
            projectName.text,
            widget.projectTasks,
            widget.projectTaskDone,
            ColorsStatic.projectSelectedColor.value);
        Navigator.pop(context);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage(projectName: projectName.text),
            ));
      }
    }
  }
}
