import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverlayLoadingMolecules extends StatelessWidget {
  OverlayLoadingMolecules({required this.visible});

  //表示状態
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return visible
        ? Container(
      decoration: new BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
        ],
      ),
    )
        : Container();
  }
}