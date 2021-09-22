import 'package:flutter/material.dart';

class PointModel {
  double? width;
  Widget? child;

  PointModel(this.width, this.child,);

  PointModel.fromJson(Map<String, dynamic> json) {
    width = json['Width'];
    child = json['Child'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Width'] = this.width;
    data['Child'] = this.child;
    return data;
  }
}