import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/Controllers/ProjectController.dart';
import 'package:todo_app/View/AddProjectPage.dart';
import 'package:todo_app/View/ProjectDetailPage.dart';
import 'package:todo_app/Statics/Colors.dart';
import 'package:todo_app/Statics/Texts.dart';
import 'package:todo_app/View/Widgets/ProjectItem.dart';

class ProjectsPage extends StatefulWidget {
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Map<String, dynamic>> projects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsStatic.backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProjectPage(),
              )).then((value) {
            setState(() {});
          });
        },
        heroTag: 'add button',
        backgroundColor: ColorsStatic.profileColor,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, 'test');
                    },
                    child: Icon(Icons.arrow_back_ios_rounded,
                        textDirection: TextDirection.ltr,
                        color: ColorsStatic.topPageTitleColor,
                        size: 30),
                  ),
                  Text(
                    Texts.projectPageTitle,
                    style: TextStyle(
                        color: ColorsStatic.topPageTitleColor, fontSize: 20),
                  ),
                  Container()
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: FutureBuilder(
                  future: ProjectsController().getProjects(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    projects = snapshot.data;
                    return projects.isEmpty
                        ? Center(
                            child: Text(
                              Texts.noProject,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: ColorsStatic.underTitleColor),
                            ),
                          )
                        : GridView.builder(
                            itemCount: projects.length,
                            padding:
                                EdgeInsets.only(left: 20, bottom: 20, top: 20),
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, mainAxisSpacing: 10),
                            itemBuilder: (context, index) {
                              var project = projects[index];
                              List<dynamic> tasks =
                                  json.decode(project['project_tasks']);
                              return ProjectItem(
                                name: project['project_name'],
                                doneCount: project['project_taskDone'],
                                fullCount: tasks.length,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProjectDetailPage(project['id']),
                                      )).then((value) {
                                    setState(() {});
                                  });
                                },
                                projectColor: Color(project['project_color']),
                              );
                            },
                          );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
