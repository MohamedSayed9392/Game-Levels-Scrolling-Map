# Game Levels Scrolling Map

A package for making game levels map like candy crush or similar games using flutter with ability to be horizontal or vertical

## Getting Started

* This package enables you to build a Game levels map like candy crush with the following features :
  - Option to make it horizontal map or vertical
  - Option to reverse the scrolling start direction
  - Option to add the x,y points positions
  - Option to extract the x,y points positions from asset SVG file or online SVG file

## Platform Support

| Android ✔️ | IOS ✔️ | MacOS ✔️ ️| Web ✔️ | Linux ✔️ | Windows ✔ ️|

## Usage
<br>

**Step 1** Import `package:game_levels_scrolling_map/game_levels_scrolling_map.dart` which contain the main widget of the map `GameLevelsScrollingMap`
then Import `package:game_levels_scrolling_map/model/point_model.dart` which contain the model of points<br>

**Step 2** Start adding your points widgets by creating a new List of points and adding widgets to it using the `PointModel` class<br>

```dart
List<PointModel> points = [];
      
for(int i = 0; i<50 ; i++){
  PointModel point = PointModel(100,Container(width: 40, height: 40, color: Colors.red, child: Text("$i")));
  
  /* To make the map scroll to a specific point just make its parameter 'isCurrent' = true like the following which will make the map scroll to it once created*/
  if(i == 20) point.isCurrent = true;
  
  points.add(point);
}
```

**Step 3** Use `GameLevelScrollingMap.scrollable` widget to build the map<br>

**- To make vertical map:**<br>
<img src="https://raw.githubusercontent.com/MohamedSayed9392/Game-Levels-Scrolling-Map/master/screenshots/screenshot_map_vertical.png" alt="Vertical Map Example" width="400"/><br>

```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      child: GameLevelsScrollingMap.scrollable(
              imageUrl: "assets/drawable/map_vertical.png",
              direction: Axis.vertical,
              reverseScrolling: true,
              svgUrl: 'assets/svg/map_vertical.svg',
              points: points,)
          ),
        );
}
```
**- To make horizontal map:**<br>
<img src="https://raw.githubusercontent.com/MohamedSayed9392/Game-Levels-Scrolling-Map/master/screenshots/screenshot_map_horizantal.png" alt="Horizontal Map Example" width="500"/><br><br>

```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      child: GameLevelsScrollingMap.scrollable(
            imageUrl: "assets/drawable/map_horizontal.png",
            direction: Axis.horizontal,
            svgUrl: 'assets/svg/map_horizontal.svg',
            points: points,)
          ),
        );
}
```



