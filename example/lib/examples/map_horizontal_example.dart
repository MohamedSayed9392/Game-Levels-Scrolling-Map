import 'package:flutter/material.dart';
import 'package:game_levels_scrolling_map/game_levels_scrolling_map.dart';
import 'package:game_levels_scrolling_map/model/point_model.dart';

class MapHorizontalExample extends StatefulWidget {
  const MapHorizontalExample({Key? key}) : super(key: key);

  @override
  State<MapHorizontalExample> createState() => _MapHorizontalExampleState();
}

class _MapHorizontalExampleState extends State<MapHorizontalExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: GameLevelsScrollingMap.scrollable(
        imageUrl: "assets/drawable/map_horizontal.png",
        svgUrl: "assets/svg/map_horizontal.svg",
        points: points,
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    fillTestData();
  }

  List<PointModel> points = [];

  void fillTestData() {
    for (int i = 0; i < 50; i++) {
      points.add(PointModel(100, testWidget(i)));
    }
  }

  Widget testWidget(int order) {
    return InkWell(
      hoverColor: Colors.blue,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/drawable/map_horizontal_point.png",
            fit: BoxFit.fitWidth,
            width: 100,
          ),
          Text("$order",
              style: const TextStyle(color: Colors.black, fontSize: 40))
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Point $order"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
