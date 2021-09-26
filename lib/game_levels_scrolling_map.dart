library game_levels_scrolling_map;

import 'dart:async';
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'config/q.dart';
import 'widgets/loading_progress.dart';
import '../helper/utils.dart';


import 'model/point_model.dart';

class GameLevelsScrollingMap extends StatefulWidget {
  double? height;
  double? width;

  String imageUrl;
  String? svgUrl = "";

  List<double>? x_values = [];
  List<double>? y_values = [];

  List<PointModel>? points = [];

  double? pointsPositionDeltaX = 0;
  double? pointsPositionDeltaY = 0;

  bool isScrollable = false;
  Axis? direction = Axis.horizontal;
  bool? reverseScrolling = false;

  GameLevelsScrollingMap(this.imageUrl,
      {@required this.width,
        this.svgUrl,
        this.points,
        this.x_values,
        this.y_values,
        this.pointsPositionDeltaX,
        this.pointsPositionDeltaY,
        Key? key})
      : super(key: key);

  GameLevelsScrollingMap.scrollable(this.imageUrl,
      {this.width,
        this.height,
        this.direction,
        this.svgUrl,
        this.points,
        this.x_values,
        this.y_values,
        this.pointsPositionDeltaX,
        this.pointsPositionDeltaY,
        this.reverseScrolling,
        Key? key})
      : super(key: key) {
    isScrollable = true;
  }

  @override
  _GameLevelsScrollingMapState createState() => _GameLevelsScrollingMapState();
}

class _GameLevelsScrollingMapState extends State<GameLevelsScrollingMap> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initDeviceDimensions();
      initDefaults();

      if (widget.svgUrl!.isNotEmpty) {
        _getPathFromSVG().then((value) {
          _loadImage(widget.imageUrl);
        });
      }else{
        _loadImage(widget.imageUrl);
      }
    });
  }

  void initDeviceDimensions() {
    Q.deviceWidth = MediaQuery.of(context).size.width;
    Q.deviceHeight = MediaQuery.of(context).size.height;

    print("${Q.TAG} Device Dimensions : ${Q.deviceWidth} x ${Q.deviceHeight}");
  }

  void initDefaults() {
    widget.svgUrl ??= "";
    widget.x_values ??= [];
    widget.y_values ??= [];
    widget.points ??= [];
    widget.pointsPositionDeltaX ??= 0;
    widget.pointsPositionDeltaY ??= 0;
    widget.direction ??= Axis.horizontal;
    widget.reverseScrolling ??=false;
    widget.height ??= Q.deviceHeight;
    if(widget.direction == Axis.vertical) {
      widget.width ??= Q.deviceWidth;
    }else if(widget.direction == Axis.horizontal){
      widget.width ??= 0;
    }
    if (widget.width == double.infinity) {
      widget.width = Q.deviceWidth;
    }

    print("widget.height : ${widget.height}");
  }

  GlobalKey _key = GlobalKey();
  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        key: widget.key ?? _key,
        color: Colors.red,
        width: widget.width != 0 ? widget.width : maxWidth,
        height: maxHeight,
        child: widget.isScrollable
            ? SingleChildScrollView(
          scrollDirection: widget.direction ?? Axis.horizontal,
          reverse: widget.reverseScrolling ?? false,
          child: aspectRatioWidget(),
        )
            : aspectRatioWidget());
  }

  Widget aspectRatioWidget() {
    return AspectRatio(
        aspectRatio: aspectRatio,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return imageWidth != 0
                  ? Stack(
                  textDirection: TextDirection.ltr,
                  alignment: AlignmentDirectional.topStart,
                  children: widgets)
                  : const LoadingProgress();
            }));
  }

  bool isImageLoaded = false;

  double aspectRatio = 1;
  double imageWidth = 0;
  double imageHeight = 0;
  double maxWidth = 0;
  double maxHeight = 0;

  Completer<ui.Image> completer = Completer<ui.Image>();

  Future<ui.Image> _loadImage(var path) async {
    ImageStream stream;
    if (path.contains("assets")) {
      stream = AssetImage(path).resolve(ImageConfiguration.empty);
    } else {
      stream = NetworkImage(path).resolve(ImageConfiguration.empty);
    }

    ImageStreamListener? listener;
    listener = ImageStreamListener((ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      print("${Q.TAG} image path : ${widget.imageUrl}");
      print("${Q.TAG} image dimensions : ${image.width} x ${image.height}");

      imageWidth = image.width.toDouble();
      imageHeight = image.height.toDouble();
      aspectRatio = image.width.toDouble() / image.height.toDouble();

      if (widget.isScrollable) {
        if(widget.direction == Axis.horizontal) {
          maxHeight = widget.height!;
          maxWidth = maxHeight * aspectRatio;
        }else if(widget.direction == Axis.vertical){
          maxWidth = widget.width!;
          maxHeight = maxWidth / aspectRatio;
        }
      } else {
        maxWidth = widget.width!;
        maxHeight = maxWidth / aspectRatio;
      }

      print(
          "${Q.TAG} image all dimensions : $imageWidth : $imageHeight : $aspectRatio");

      widgets.add(backgroundImage());
      drawPoints();

      completer.complete(image);
      stream.removeListener(listener!);

      setState(() => {});
    });

    stream.addListener(listener);
    return completer.future;
  }

  Widget backgroundImage() {
    return Container(
      height: maxHeight,
      width: maxWidth,
      child: imageWidth != 0
          ? widget.imageUrl.contains("assets")
          ? Image.asset(widget.imageUrl, fit: BoxFit.fill)
          : Image.network(widget.imageUrl, fit: BoxFit.fill)
          : const LoadingProgress(),
    );
  }

  void drawPoints() {
    print("${Q.TAG} maxWidth / imageWidth : ${maxWidth / imageWidth}");
    print("${Q.TAG} maxHeight / imageHeight : ${maxHeight / imageHeight}");

    for (int i = 0; i < widget.points!.length; i++) {
      //widget.points!.add(PointModel(100, testWidget(i)));
      if (widget.x_values!.length > i) {
        var x = (widget.x_values![i] * maxWidth / imageWidth) +
            widget.pointsPositionDeltaX!;

        x = x - (widget.points![i].width! / 2);

        var y = (widget.y_values![i] * maxHeight / imageHeight) +
            widget.pointsPositionDeltaY!;

        y = y - (widget.points![i].width! / 2);

        print(
            "${Q.TAG} old x,y : ${widget.x_values![i]},${widget.y_values![i]} ## new x,y : $x,$y");

        widgets.add(pointWidget(x, y, child: widget.points![i].child));
      }else{
        break;
      }
    }
  }

  Widget pointWidget(double x, double y, {Widget? child}) {
    return Positioned(child: child ?? Container(), left: x, top: y);
  }

  String? _pathSVG;

  Future _getPathFromSVG() async {
    await getPointsPathFromXML().then((value) {
      _pathSVG = value.replaceAll(",", " ");
      print("pathSVG : $_pathSVG");
      List<String> arrayOfPoints = _pathSVG!.split(" ");
      for (int i = 0; i < arrayOfPoints.length; i++) {
        if (i % 2 == 0) {
          widget.x_values!.add(double.parse(arrayOfPoints[i]));
        } else {
          widget.y_values!.add(double.parse(arrayOfPoints[i]));
        }
      }
    });
  }

  Future<String> getPointsPathFromXML() async {
    String path = "";
    XmlDocument x = await Utils.readSvg(widget.svgUrl!);
    Utils.getXmlWithClass(x, "st0").forEach((element) {
      path = element.getAttribute("points")!;
    });
    return path;
  }
}

