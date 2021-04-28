import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  const AdaptiveFlatButton({Key key, this.handler}) : super(key: key);
  final Function handler;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Icon(Icons.date_range),
          )
        : TextButton(
            onPressed: handler,
            child: Icon(Icons.date_range),
          );
  }
}
