import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/blocs/project_selector_bloc/project_selector_bloc.dart';
import 'package:time_tracker/src/components/text_field.dart';
import 'package:time_tracker/src/data/project_model.dart';
import 'package:time_tracker/src/components/flap.dart';

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
    return Dismissible(
      key: UniqueKey(),
      background: Container(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
      onDismissed: (DismissDirection direction) {
        BlocProvider.of<ProjectSelectorBloc>(context)
            .add(DeleteItem(id: project.id));
      },
      child: Row(
        children: [
          const SizedBox(
            width: 8.0,
          ),
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
      ),
    );
  }

  List<Widget> projectsToWidgets(BuildContext context, List<Project> projects) {
    return List.generate(
        projects.length, (i) => itemTemplate(context, projects[i]));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Flap(),
            CustomTextField(textController: textController),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (textController.text.isEmpty) {
              return;
            }
            BlocProvider.of<ProjectSelectorBloc>(context).add(NewItem(
                name: textController.text,
                //TODO: get colours from user
                color: const Color.fromARGB(255, 255, 0, 0)));

            FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
            textController.clear();
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
