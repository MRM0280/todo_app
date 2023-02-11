import 'package:flutter/material.dart';
import 'package:todo_app/Statics/Colors.dart';
import 'package:todo_app/Statics/Texts.dart';

class ProjectItem extends StatelessWidget {
  final String name;
  final int fullCount;
  final int doneCount;
  final Color projectColor;
  final Function onTap;

  ProjectItem(
      {this.doneCount,
      this.fullCount,
      this.name,
      this.projectColor,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    double calc = (doneCount * 100) / fullCount;
    int percent = calc.toInt();
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
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
        child: Column(children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: projectColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.only(left: 15, bottom: 15,right: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        fullCount.toString() + '  ${Texts.tasks}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ]),
              ),
            ),
          ),
          Expanded(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${percent.toString()}%',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ColorsStatic.titleColor),
                        )
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    height: 5,
                    decoration: BoxDecoration(
                        color: projectColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      children: [
                        Expanded(
                            flex: percent == 0 ? 1 : percent,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: projectColor,
                                  borderRadius: BorderRadius.circular(50)),
                            )),
                        Expanded(flex: 100 - percent, child: Container()),
                      ],
                    ),
                  ))
                ]),
              ],
            ),
            decoration: BoxDecoration(
                color: ColorsStatic.backgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          )),
        ]),
      ),
    );
  }
}
