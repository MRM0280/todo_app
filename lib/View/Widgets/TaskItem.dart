import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Statics/Colors.dart';

class TaskItem extends StatefulWidget {
  final String title;
  final String desc;
  final Color taskColor;
  final Function onTap;
  final Function delete;
  final String heroTag;
  final bool isProject;
  final bool isDone;
  final Function undo;

  TaskItem(
      {this.title,
      this.desc = '',
      this.taskColor,
      this.delete,
      this.onTap,
      this.heroTag,
      this.isProject = false,
      this.isDone = false,
      this.undo});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem>
    with SingleTickerProviderStateMixin {
  var tween = Tween<Offset>(begin: Offset.zero, end: Offset(-2, 0))
      .chain(CurveTween(curve: Curves.easeInOutBack));
  AnimationController animationController;
  double butPadding = 5;
  bool isCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isCheck = widget.isDone;
    if (isCheck) butPadding = 0;
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    animationController.addListener(() {
      if (animationController.isCompleted) {
        widget.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animationController.drive(tween),
      child: Hero(
        tag: widget.heroTag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            child: Container(
              height: 90,
              width: double.maxFinite,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorsStatic.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(isCheck ? 0.04 : 0.07),
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(0, 2))
                  ]),
              child: Row(children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (!widget.isProject) {
                          butPadding = 0;
                          Timer(Duration(milliseconds: 500), () {
                            animationController.forward();
                          });
                        } else {
                          if (butPadding == 0) {
                            butPadding = 5;
                            widget.undo();
                          } else {
                            butPadding = 0;
                            widget.delete();
                          }
                          isCheck = !isCheck;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(butPadding),
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.taskColor
                                    .withOpacity(isCheck ? 0.2 : 0.3)),
                          )),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color:
                              widget.taskColor.withOpacity(isCheck ? 0.1 : 0.2),
                          shape: BoxShape.circle),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ColorsStatic.titleColor
                                  .withOpacity(isCheck ? 0.3 : 1),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.desc,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ColorsStatic.underTitleColor
                                .withOpacity(isCheck ? 0.1 : 0.5),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
