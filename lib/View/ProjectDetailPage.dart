import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:todo_app/Controllers/ProjectController.dart';
import 'package:todo_app/Dialogs.dart';
import 'package:todo_app/View/AddProjectPage.dart';
import 'package:todo_app/View/AddTask/AddTaskPage.dart';
import 'package:todo_app/Statics/Colors.dart';
import 'package:todo_app/Statics/Statics.dart';
import 'package:todo_app/Statics/Texts.dart';
import 'package:todo_app/View/Widgets/TaskItem.dart';

class ProjectDetailPage extends StatefulWidget {
  final int projectId;
  ProjectDetailPage(this.projectId);

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  Map project;
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ProjectsController().getProjects(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var find = snapshot.data.where((element) {
            return element['id'] == widget.projectId;
          });
          List<dynamic> tasks = json.decode(find.first['project_tasks']);

          project = {
            'id': find.first['id'],
            'project_name': find.first['project_name'],
            'project_tasks': tasks,
            'project_taskDone': find.first['project_taskDone'],
            'project_color': find.first['project_color']
          };
          if (project['project_taskDone'] == tasks.length) {
            isDone = true;
          } else {
            isDone = false;
          }
          return Scaffold(
            backgroundColor: ColorsStatic.backgroundColor,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskPage(
                          projectId: project['id'],
                          projectColor: project['project_color'],
                          projectName: project['project_name'],
                          projectTaskDone: project['project_taskDone'],
                          edit: true,
                          tasks: tasks),
                    )).then((value) {
                  setState(() {});
                });
              },
              heroTag: 'add button',
              backgroundColor: ColorsStatic.profileColor,
              child: Icon(Icons.add),
            ),
            body: SafeArea(
                child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextScroll(
                              project['project_name'],
                              intervalSpaces: 10,
                              style: TextStyle(
                                  color: ColorsStatic.topPageTitleColor,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddProjectPage(
                                        projectId: project['id'],
                                        projectName: project['project_name'],
                                        projectColor:
                                            Color(project['project_color']),
                                        projectTaskDone:
                                            project['project_taskDone'],
                                        projectTasks:
                                            find.first['project_tasks']),
                                  )).then((value) {
                                setState(() {});
                              });
                            },
                            child: Icon(
                              Icons.edit_outlined,
                              color: ColorsStatic.topPageTitleColor,
                              size: 27,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Flexible(
                        child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 80),
                      physics: BouncingScrollPhysics(),
                      itemCount: project['project_tasks'].length,
                      itemBuilder: (context, index) {
                        Map task = project['project_tasks'][index];
                        String heroTag =
                            'task ' + index.toString() + ' in project';
                        return TaskItem(
                          heroTag: heroTag,
                          title: task['task_title'],
                          desc: task['task_desc'],
                          taskColor: Color(task['task_color']),
                          isProject: true,
                          isDone: task['task_isDone'],
                          undo: () {
                            btn(task, true);
                            setState(() {});
                          },
                          onTap: () {
                            Dialogs.showTaskDetails(context, task, heroTag,
                                tasks: tasks,
                                index: index,
                                projectColor: project['project_color'],
                                projectId: project['id'],
                                projectName: project['project_name'],
                                projectTaskDone: project['project_taskDone'],
                                refresh: () {
                              setState(() {});
                            });
                          },
                          delete: () {
                            btn(task, false);
                            setState(() {});
                          },
                        );
                      },
                    ))
                  ],
                ),
                Align(
                  alignment: Statics.appTextDirection == TextDirection.rtl
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 15, right: 20),
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: () {
                          if (isDone) {
                            ProjectsController().deleteProject(project['id']);
                            Dialogs.showSuccessDialog(
                                context, Texts.projectCompletedDialog);
                            Timer(Duration(seconds: 1), () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          } else {
                            Dialogs.deleteProjectDelete(context, () {
                              ProjectsController().deleteProject(project['id']);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 115,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  Statics.appTextDirection == TextDirection.rtl
                                      ? 23
                                      : 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: isDone ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(children: [
                            Icon(
                              isDone ? Icons.check : Icons.delete_outline,
                              size: 23,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: FittedBox(
                                child: Text(
                                  isDone
                                      ? Texts.addDescDone
                                      : Texts.deleteProject,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            isDone
                                ? SizedBox(
                                    height: 20,
                                  )
                                : Container()
                          ]),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
          );
        });
  }

  btn(task, bool isUndo) {
    List<String> tasks = [];
    project['project_tasks'].forEach((element) {
      String taskTitle = element['task_title'];
      String taskDesc = element['task_desc'];
      String taskColor = element['task_color'].toString();
      String taskIsDone = element == task
          ? isUndo
              ? 'false'
              : 'true'
          : element['task_isDone'].toString();
      tasks.add(
          '{"task_title": "$taskTitle", "task_desc": "$taskDesc", "task_color": $taskColor, "task_isDone": $taskIsDone}');
    });
    ProjectsController().updateProject(
        project['id'],
        project['project_name'],
        tasks.toString(),
        isUndo
            ? project['project_taskDone'] - 1
            : project['project_taskDone'] + 1,
        project['project_color']);
  }
}
