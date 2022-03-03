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
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.pop(context, activity);
      },
      child: Row(
        children: [
          Text(
            activity.getName(),
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
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
        child: BlocBuilder<ActivitySelectorBloc, ActivitySelectorState>(
            //specify buildWhen for better performance
            builder: (context, state) {
          return ListView(
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
              ...activitiesToWidgets(context, state.getActivities()),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<ActivitySelectorBloc>(context)
              .add(NewItem(name: textController.text));
          textController.clear();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
