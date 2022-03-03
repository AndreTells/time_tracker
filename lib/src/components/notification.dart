import 'package:flutter/material.dart';

class CustomAlertNotification extends StatefulWidget {
  final String message;
  const CustomAlertNotification({Key? key, required this.message})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomAlertNotificationState();

  static void createNotification(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          overlayEntry?.remove();
        },
        child: CustomAlertNotification(message: message),
      );
    });
    overlayState?.insert(overlayEntry);
  }
}

class _CustomAlertNotificationState extends State<CustomAlertNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> position;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    position = Tween<Offset>(begin: const Offset(0.0, -4.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      color: Colors.transparent,
      child: Align(
          alignment: Alignment.topCenter,
          child: SlideTransition(
              position: position,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 30,
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_sharp,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.message,
                        ),
                      ],
                    ),
                  ),
                ),
              ))),
    ));
  }
}
