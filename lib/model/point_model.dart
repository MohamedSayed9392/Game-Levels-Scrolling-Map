import 'package:flutter/material.dart';

class PointModel {
  double? width;
  Widget? child;
  bool? isCurrent;

  PointModel(this.width, this.child, {this.isCurrent = false});

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
