import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class Blend {
  final Tuple2<String, Color> _blend;

  Blend(
    this._blend,
  );

  Widget get widget {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: _blend.item2,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        _blend.item1,
        style: TextStyle(fontSize: 14, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
