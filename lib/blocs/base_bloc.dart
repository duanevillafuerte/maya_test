import 'package:flutter/material.dart';

abstract class Bloc {
  void dispose();
}

abstract class BaseBloc implements Bloc {
  showBottomSheet({required BuildContext context, required String message}) {
    if (context.mounted) {
      Scaffold.of(context).showBottomSheet((context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          height: 100,
          child: Center(
            child: Text(message, style: TextStyle(color: Colors.white)),
          ),
        );
      }, backgroundColor: Colors.transparent);
    }
  }
}
