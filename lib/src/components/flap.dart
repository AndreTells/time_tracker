import 'package:flutter/material.dart';

class Flap extends StatelessWidget {
  const Flap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        alignment: Alignment.center,
        children: [
          FractionallySizedBox(
            heightFactor: 0.08,
            widthFactor: 1,
            child: Card(
              color: Theme.of(context).colorScheme.secondaryVariant,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
            ),
          ),
          FractionallySizedBox(
            heightFactor: 0.024,
            widthFactor: 0.92,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
          ),
        ],
      ),
    );
  }
}
