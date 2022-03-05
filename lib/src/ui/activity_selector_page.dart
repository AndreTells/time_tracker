import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracker/src/blocs/activity_selector_bloc/activity_selector_bloc.dart';
import 'package:time_tracker/src/data/activity_model.dart';

class ActivitySelectorPage extends StatelessWidget {
  final int projectId;
  const ActivitySelectorPage({Key? key, required this.projectId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivitySelectorBloc>(
      create: (context) => ActivitySelectorBloc(projectId: projectId),
      child: const _ActivitySelectorView(),
    );
  }
}

class _ActivitySelectorView extends StatefulWidget {
  const _ActivitySelectorView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActivitySelectorPageViewState();
}

class _ActivitySelectorPageViewState extends State<_ActivitySelectorView> {
  final textController = TextEditingController();

  Widget itemTemplate(BuildContext context, Activity activity) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
      onDismissed: (DismissDirection direction) {
        BlocProvider.of<ActivitySelectorBloc>(context)
            .add(DeleteItem(id: activity.id));
      },
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context, activity);
        },
        child: Row(
          children: [
            Text(
              activity.name,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> activitiesToWidgets(
      BuildContext context, List<Activity> activities) {
    return List.generate(
        activities.length, (i) => itemTemplate(context, activities[i]));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 3.0, 0.0, 0.0),
        child: ListView(
          children: [
            //TODO: separete search bar into its own widget
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
            StreamBuilder(
                stream: BlocProvider.of<ActivitySelectorBloc>(context).stream,
                builder: (BuildContext context,
                    AsyncSnapshot<ActivitySelectorState> snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      shrinkWrap: true,
                      children: activitiesToWidgets(
                          context, snapshot.data!.activities),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<ActivitySelectorBloc>(context)
              .add(NewItem(name: textController.text));
          FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
          textController.clear();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
