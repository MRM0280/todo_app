import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Controllers/PrefsController.dart';
import 'package:todo_app/Controllers/ProjectController.dart';
import 'package:todo_app/Controllers/TaskController.dart';
import 'package:todo_app/Dialogs.dart';
import 'package:todo_app/View/AddProjectPage.dart';
import 'package:todo_app/View/AddTask/AddTaskPage.dart';
import 'package:todo_app/View/ProjectDetailPage.dart';
import 'package:todo_app/View/ProjectsPage.dart';
import 'package:todo_app/Statics/Colors.dart';
import 'package:todo_app/Statics/Statics.dart';
import 'package:todo_app/Statics/Texts.dart';
import 'package:todo_app/View/Widgets/ProjectItem.dart';
import 'package:todo_app/View/Widgets/TaskItem.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> projects = [];
  ScrollController scrollController;

  @override
  void initState() {
    getData();
    super.initState();
    scrollController = ScrollController();
  }

  getData() async {
    ColorsStatic.profileColor = (await Prefs.get('color')) != null
        ? Color(int.parse(await Prefs.get('color')))
        : Colors.blueAccent;
    if (await Prefs.get('theme') == 'dark') {
      setState(() {
        Statics.theme = 'dark';
        ColorsStatic.backgroundColor = Color(0xff535353);
        ColorsStatic.titleColor = Colors.white;
        ColorsStatic.underTitleColor = Colors.white.withOpacity(0.5);
        ColorsStatic.topPageTitleColor = Colors.white;
        ColorsStatic.textFeildColor = Colors.white;
      });
    } else {
      setState(() {
        Statics.theme = 'litght';
        ColorsStatic.backgroundColor = Colors.white;
        ColorsStatic.titleColor = Colors.black;
        ColorsStatic.underTitleColor = Colors.black.withOpacity(0.5);
        ColorsStatic.topPageTitleColor = Color(0xff737373);
        ColorsStatic.textFeildColor = Color(0xFFADADAD);
      });
    }
    Statics.language = (await Prefs.get('lan')) ?? 'EN';
    if (Statics.language == 'FA') {
      lanToFA();
    } else {
      lanToEN();
    }
    if ((await Prefs.get('color')) != null) {
      ColorsStatic.profileColor = Color(int.parse(await Prefs.get('color')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsStatic.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskPage(),
              ));
        },
        heroTag: 'add button',
        backgroundColor: ColorsStatic.profileColor,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: Container(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () async {
                      if (Statics.theme == 'litght') {
                        await Prefs.set('theme', 'dark');

                        setState(() {
                          Statics.theme = 'dark';
                        });
                        ColorsStatic.backgroundColor = Color(0xff535353);
                        ColorsStatic.titleColor = Colors.white;
                        ColorsStatic.underTitleColor =
                            Colors.white.withOpacity(0.5);
                        ColorsStatic.topPageTitleColor = Colors.white;
                        ColorsStatic.textFeildColor = Colors.white;
                      } else {
                        await Prefs.set('theme', 'litght');
                        setState(() {
                          Statics.theme = 'litght';
                        });

                        ColorsStatic.backgroundColor = Colors.white;
                        ColorsStatic.titleColor = Colors.black;
                        ColorsStatic.underTitleColor =
                            Colors.black.withOpacity(0.5);
                        ColorsStatic.topPageTitleColor = Color(0xff737373);
                        ColorsStatic.textFeildColor = Color(0xFFADADAD);
                      }
                    },
                    child: Icon(
                      Statics.theme == 'litght'
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      size: 30,
                      color: ColorsStatic.topPageTitleColor,
                    )),
                Text(
                  Texts.wellcome,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: ColorsStatic.titleColor),
                ),
                InkWell(
                    onTap: () {
                      Dialogs.showSettings(
                          context,
                          () {
                            setState(() {});
                          },
                          Statics.language,
                          () {
                            lanToFA();
                          },
                          () {
                            lanToEN();
                          });
                    },
                    child: Icon(
                      Icons.settings,
                      size: 30,
                      color: ColorsStatic.topPageTitleColor,
                    ))
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Texts.yourProjects,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: ColorsStatic.titleColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectsPage(),
                        )).then((value) {
                      setState(() {});
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text(
                      Texts.seeAllProjects,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          FutureBuilder(
              future: ProjectsController().getProjects(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                projects = snapshot.data;
                return Container(
                  height: MediaQuery.of(context).size.height / 4.2,
                  width: double.maxFinite,
                  child: projects.isEmpty
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddProjectPage(),
                                )).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            width: MediaQuery.of(context).size.width / 2.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      spreadRadius: 5,
                                      offset: Offset(0, 1))
                                ],
                                color: ColorsStatic.backgroundColor),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 50,
                                  color: ColorsStatic.underTitleColor,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  Texts.addProject,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: ColorsStatic.underTitleColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: projects.length,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(left: 20),
                          itemBuilder: (context, index) {
                            var project = projects[index];
                            List<dynamic> tasks =
                                json.decode(project['project_tasks']);
                            return Row(
                              children: [
                                ProjectItem(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProjectDetailPage(
                                                        project['id'])))
                                        .then((value) {
                                      setState(() {});
                                      print('test');
                                    });
                                  },
                                  name: project['project_name'],
                                  fullCount: tasks.length,
                                  doneCount: project['project_taskDone'],
                                  projectColor: Color(project['project_color']),
                                ),
                                (projects.length - 1) == index
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddProjectPage(),
                                              )).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 10, 20, 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.1,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 5,
                                                    spreadRadius: 5,
                                                    offset: Offset(0, 1))
                                              ],
                                              color:
                                                  ColorsStatic.backgroundColor),
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 50,
                                                color: ColorsStatic
                                                    .underTitleColor,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                Texts.addProject,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorsStatic
                                                      .underTitleColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            );
                          },
                        ),
                );
              }),
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  Texts.yourTasks,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: ColorsStatic.titleColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Flexible(
              child: FutureBuilder(
                  future: TasksController().getTasks(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    tasks = snapshot.data;
                    return tasks.length == 0
                        ? Center(
                            child: Text(
                              Texts.noTask,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: ColorsStatic.underTitleColor),
                            ),
                          )
                        : ListView.builder(
                            itemCount: tasks.length,
                            controller: scrollController,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var task = tasks[index];
                              String heroTag = 'task ' + index.toString();
                              return Dismissible(
                                confirmDismiss: (direction) {
                                  return null;
                                },
                                key: Key(tasks[index].toString()),
                                onDismissed: (direction) {
                                  setState(() {
                                    tasks.removeAt(index);
                                  });
                                },
                                child: TaskItem(
                                  onTap: () {
                                    Dialogs.showTaskDetails(
                                        context, task, heroTag);
                                  },
                                  heroTag: heroTag,
                                  title: task['task_title'],
                                  desc: task['task_desc'],
                                  taskColor: Color(task['task_color']),
                                  delete: () {
                                    TasksController().deleteTask(task['id']);
                                    setState(() {
                                      tasks.remove(task);
                                      Timer(Duration(milliseconds: 100), () {
                                        if (tasks.isNotEmpty) {
                                          scrollController.jumpTo(0);
                                        }
                                      });
                                    });
                                  },
                                ),
                              );
                            },
                          );
                  }))
        ]),
      )),
    );
  }

  lanToFA() {
    setState(() {
      Statics.appTextDirection = TextDirection.rtl;
      Texts.wellcome = 'کارها را انجام بده';
      Texts.noTask = 'کاری وجود ندارد';
      Texts.yourProjects = 'پروژه های شما';
      Texts.seeAllProjects = 'دیدن همه';
      Texts.yourTasks = 'کار های شما';
      Texts.addTaskTitle = 'افزودن کار';
      Texts.editTaskTitle = 'ویرایش کار';
      Texts.addTaskTextFeild = 'کار را وارد کنید';
      Texts.addTaskDate = 'امروز';
      Texts.addTaskNext = 'بعدی';
      Texts.addDescTitle = 'افزودن توضیحات';
      Texts.addDescDone = 'تمام';
      Texts.addDescTextFeild = 'توضیحات را وارد کنید';
      Texts.addTaskDialog = 'کار با موفقیت اضافه شد';
      Texts.taskDetailTitle = 'کار';
      Texts.editTaskDialog = 'کار با موفقیت ویرایش شد';
      Texts.addProject = 'افزودن پروژه';
      Texts.noProject = 'پروژه ای وجود ندارد';
      Texts.projectPageTitle = 'پروژه ها';
      Texts.addProjectPageTitle = 'ساخت پروژه';
      Texts.editProjectPageTitle = 'ویرایش پروژه';
      Texts.addProjectTextFeild = 'اسم پروژه را وارد کنید';
      Texts.addTaskToProjectDialog = 'کار به پروژه اضافه شد';
      Texts.projectCreateDialog = 'پروژه با موفقیت ساخته شد';
      Texts.addProjectEdit = 'ویرایش';
      Texts.deleteProject = 'حذف';
      Texts.deleteProjectDialog = 'آیا مطمئن به حذف پروژه هستید ؟';
      Texts.yes = 'بله';
      Texts.no = 'خیر';
      Texts.projectCompletedDialog = 'پروژه انجام شد';
      Texts.appColor = 'رنگ برنامه :';
      Texts.language = 'زبان';
      Texts.tasks = 'کار';
      Get.forceAppUpdate();
    });
  }

  lanToEN() {
    setState(() {
      Statics.appTextDirection = TextDirection.ltr;
      Texts.wellcome = 'Do The Tasks';
      Texts.noTask = 'No Task To do';
      Texts.yourProjects = 'Your Projects';
      Texts.seeAllProjects = 'See All';
      Texts.yourTasks = 'Your Tasks';
      Texts.addTaskTitle = 'Add Task';
      Texts.editTaskTitle = 'Edit Task';
      Texts.addTaskTextFeild = 'Enter Task';
      Texts.addTaskDate = 'Today';
      Texts.addTaskNext = 'Next';
      Texts.addDescTitle = 'Add Description';
      Texts.addDescDone = 'Done';
      Texts.addDescTextFeild = 'Enter Description';
      Texts.addTaskDialog = 'Task Added successfully';
      Texts.taskDetailTitle = 'Task';
      Texts.editTaskDialog = 'Task Edited successfully';
      Texts.addProject = 'Add Project';
      Texts.noProject = 'No Project';
      Texts.projectPageTitle = 'Projects';
      Texts.addProjectPageTitle = 'Create Project';
      Texts.editProjectPageTitle = 'Edit Project';
      Texts.addProjectTextFeild = 'Enter Project Name';
      Texts.addTaskToProjectDialog = 'Task Added To Project';
      Texts.projectCreateDialog = 'Project Created successfully';
      Texts.addProjectEdit = 'Edit';
      Texts.deleteProject = 'Delete';
      Texts.deleteProjectDialog =
          'Are you sure you want to delete this project ?';
      Texts.yes = 'Yes';
      Texts.no = 'No';
      Texts.projectCompletedDialog = 'Project Completed';
      Texts.appColor = 'App Color :';
      Texts.language = 'Language';
      Texts.tasks = 'Tasks';
      Get.forceAppUpdate();
    });
  }
}
