import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Controllers/PrefsController.dart';
import 'package:todo_app/View/AddTask/AddTaskPage.dart';
import 'package:todo_app/Statics/Colors.dart';
import 'package:todo_app/Statics/Statics.dart';
import 'package:todo_app/Statics/Texts.dart';

class Dialogs {
  static showColorsDialog(context,
      {Function refresh,
      bool isForProfile = false,
      bool isForProject = false}) {
    List<Color> colors = [
      Color(0xFF7F54AA),
      Color(0xFF7D51FF),
      Colors.blueAccent,
      Color(0xFF01A74B),
      Color(0xFF0FC15F),
      Color(0xFF29FF89),
      Color(0xFFFE6734),
      Color(0xFFFF8839),
      Color(0xFFEEFF00),
      Color(0xFFFF46E3),
      Color(0xFFB13558),
      Color(0xFF572324),
      Color(0xFF000000),
    ];

    isSelected(Color color) {
      if (isForProject) {
        return ColorsStatic.projectSelectedColor == color;
      } else if (isForProfile) {
        return ColorsStatic.profileColor == color;
      } else {
        return ColorsStatic.selectedColor == color;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Center(
                    child: InkWell(
                  onTap: () {},
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      height: MediaQuery.of(context).size.height / 2.3,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorsStatic.backgroundColor,),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 9),
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isForProject) {
                                  ColorsStatic.projectSelectedColor =
                                      colors[index];
                                } else if (isForProfile) {
                                  Prefs.set(
                                      'color', colors[index].value.toString());
                                  ColorsStatic.profileColor = colors[index];
                                } else {
                                  ColorsStatic.selectedColor = colors[index];
                                }
                                Navigator.pop(context);
                                refresh(() {});
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              padding: EdgeInsets.all(
                                  isSelected(colors[index]) ? 5 : 0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 2,
                                      color: isSelected(colors[index])
                                          ? colors[index]
                                          : Colors.transparent)),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: colors[index],
                                    shape: BoxShape.circle),
                              ),
                            ),
                          );
                        },
                      )),
                )),
              ),
            ),
          );
        });
      },
    );
  }

  static void showErrorDialog(BuildContext context,
      [String text = "خطایی رخ داد"]) {
    Flushbar(
      isDismissible: false,
      borderRadius: BorderRadius.circular(10),
      backgroundColor: ColorsStatic.backgroundColor,
      borderColor: Colors.red,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 150.0,
      ),
      animationDuration: const Duration(milliseconds: 500),
      messageText: AutoSizeText(
        "$text",
        maxLines: 1,
        textDirection: TextDirection.rtl,
        minFontSize: 3,
        maxFontSize: 12.0,
        style: const TextStyle(
          color: Colors.red,
        ),
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: const Icon(
        Icons.error_outline,
        size: 28.0,
        color: Colors.red,
      ),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void showSuccessDialog(BuildContext context, String text) {
    Flushbar(
      isDismissible: false,
      borderRadius: BorderRadius.circular(10),
      backgroundColor: ColorsStatic.backgroundColor,
      borderColor: ColorsStatic.profileColor,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 150.0),
      animationDuration: const Duration(milliseconds: 500),
      messageText: AutoSizeText(
        "$text",
        maxLines: 1,
        textDirection: TextDirection.rtl,
        minFontSize: 3,
        maxFontSize: 12.0,
        style: TextStyle(
          color: ColorsStatic.profileColor,
        ),
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: Icon(
        Icons.check_circle,
        size: 28.0,
        color: ColorsStatic.profileColor,
      ),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static showTaskDetails(
      BuildContext context, Map<String, dynamic> task, String heroTag,
      {List<dynamic> tasks,
      int index,
      int projectColor,
      int projectId,
      String projectName,
      int projectTaskDone,
      Function refresh}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: false,
          barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Hero(
                      tag: heroTag,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: ColorsStatic.backgroundColor,
                                border: Border.all(
                                    color: ColorsStatic.profileColor, width: 3),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      Text(
                                        Texts.taskDetailTitle,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: ColorsStatic.titleColor),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddTaskPage(
                                                        task: task,
                                                        index: index,
                                                        projectColor:
                                                            projectColor,
                                                        projectId: projectId,
                                                        projectName:
                                                            projectName,
                                                        projectTaskDone:
                                                            projectTaskDone,
                                                        tasks: tasks),
                                              ));
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 25,
                                          color: ColorsStatic.titleColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2),
                                    child: Divider(
                                        color: ColorsStatic.profileColor,
                                        thickness: 2),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        task['task_title'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: ColorsStatic.titleColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          task['task_desc'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: ColorsStatic.titleColor),
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        )).then((value) {
      if (refresh != null) {
        refresh();
      }
    });
  }

  static deleteProjectDelete(BuildContext context, Function yes) {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Center(
                  child: InkWell(
                onTap: () {},
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorsStatic.backgroundColor,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Texts.deleteProjectDialog,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorsStatic.titleColor,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    border:
                                        Border.all(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(Texts.no,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                            InkWell(
                              onTap: yes,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                        color: Colors.green, width: 2),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(Texts.yes,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              )),
            ),
          ),
        );
      },
    );
  }

  static showSettings(BuildContext context, Function refresh, String lan,
      Function lanToFA, Function lanToEN) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return WillPopScope(
            onWillPop: () {
              Navigator.pop(context);
              refresh();
              return null;
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  refresh();
                  if (lan != Statics.language) {
                    if (Statics.language == 'FA') {
                      lanToFA();
                    } else {
                      lanToEN();
                    }
                  }
                },
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Center(
                      child: InkWell(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorsStatic.backgroundColor,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Texts.appColor,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: ColorsStatic.topPageTitleColor),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Dialogs.showColorsDialog(context,
                                          refresh: setState,
                                          isForProfile: true);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ColorsStatic.textFeildColor
                                                  .withOpacity(0.5),
                                              width: 2),
                                          shape: BoxShape.circle),
                                      child: FittedBox(
                                          child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            color: ColorsStatic.profileColor,
                                            shape: BoxShape.circle),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Texts.language,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: ColorsStatic.topPageTitleColor),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (Statics.language == 'EN') {
                                            await Prefs.set('lan', 'FA');
                                            setState(() {
                                              Statics.language = 'FA';
                                            });
                                          } else {
                                            await Prefs.set('lan', 'EN');
                                            setState(() {
                                              Statics.language = 'EN';
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          size: 22,
                                          color: ColorsStatic.topPageTitleColor,
                                        ),
                                      ),
                                      Text(
                                        Statics.language,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                ColorsStatic.topPageTitleColor),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (Statics.language == 'EN') {
                                            await Prefs.set('lan', 'FA');
                                            setState(() {
                                              Statics.language = 'FA';
                                            });
                                          } else {
                                            await Prefs.set('lan', 'EN');
                                            setState(() {
                                              Statics.language = 'EN';
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 22,
                                          color: ColorsStatic.topPageTitleColor,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  )),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
