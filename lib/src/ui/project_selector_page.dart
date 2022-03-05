import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/blocs/project_selector_bloc/project_selector_bloc.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/data/sql_handler.dart';

class ProjectSelectorPage extends StatelessWidget {
  const ProjectSelectorPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectSelectorBloc>(
      create: (context) => ProjectSelectorBloc(),
      child: const _ProjectSelectorView(),
    );
  }
}

class _ProjectSelectorView extends StatefulWidget {
  const _ProjectSelectorView({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProjectSelectorPageViewState();
}

class _ProjectSelectorPageViewState extends State<_ProjectSelectorView> {
  final textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  //change to receive project as parameter later
  Widget itemTemplate(BuildContext context, Project project) {
    return Row(
      children: [
        Container(
          width: 15.0,
          height: 15.0,
          decoration: BoxDecoration(
            color: project.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(
          width: 13,
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, project);
          },
          child: Text(
            project.name,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        const Spacer(),
        const Icon(Icons.more_vert)
      ],
    );
  }

  List<Widget> projectsToWidgets(BuildContext context, List<Project> projects) {
    return List.generate(
        projects.length, (i) => itemTemplate(context, projects[i]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 3.0, 0.0, 0.0),
        child: ListView(
          children: [
            Card(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          textController.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder<ProjectSelectorState>(
                stream: BlocProvider.of<ProjectSelectorBloc>(context).stream,
                builder: (BuildContext context,
                    AsyncSnapshot<ProjectSelectorState> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      children:
                          projectsToWidgets(context, snapshot.data!.projects),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (textController.text.isEmpty) {
            return;
          }
          BlocProvider.of<ProjectSelectorBloc>(context).add(NewItem(
              name: textController.text,
              //TODO: get colours from user
              color: const Color.fromARGB(255, 255, 0, 0)));
          textController.clear();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
