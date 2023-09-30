import 'dart:ui';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<DrawingPoints> drawingPoints = [];
  double strokeWidth = 3;
  Color selectedColor = Colors.black;
  List<Color> palet = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.amber,
    Colors.white,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            palet.length,
            (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = palet[index];
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: palet[index],
                    ),
                  ),
                )).toList(),
      )),
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                drawingPoints.add(DrawingPoints(
                    offset: details.localPosition,
                    paint: Paint()
                      ..color = selectedColor
                      ..strokeWidth = strokeWidth
                      ..isAntiAlias = true));
              });
            },
            onPanUpdate: (details) {
              setState(() {
                drawingPoints.add(DrawingPoints(
                    offset: details.localPosition,
                    paint: Paint()
                      ..color = selectedColor
                      ..strokeWidth = strokeWidth
                      ..isAntiAlias = true
                      ..strokeCap = StrokeCap.round));
              });
            },
            onPanEnd: (details) {
              setState(() {
                drawingPoints.add(DrawingPoints(offset: null, paint: null));
              });
            },
            child: CustomPaint(
              painter: Custom(drawingPoints),
              child: Container(),
            ),
          ),
          Positioned(
            top: 20,
            right: 40,
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.close),
                  label: Text("Clear"),
                  onPressed: () {
                    setState(() {
                      drawingPoints = [];
                    });
                  },
                ),
                Slider(
                    value: strokeWidth,
                    min: 1,
                    max: 10,
                    onChanged: (v) {
                      setState(() {
                        strokeWidth = v;
                      });
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DrawingPoints {
  Offset? offset;
  Paint? paint;
  DrawingPoints({this.offset, this.paint});
}

class Custom extends CustomPainter {
  List<DrawingPoints> drawingPoints;
  Custom(this.drawingPoints);
  List<Offset> offsetList = [];
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i].offset != null &&
          drawingPoints[i + 1].offset != null) {
        canvas.drawLine(drawingPoints[i].offset!, drawingPoints[i + 1].offset!,
            drawingPoints[i].paint!);
      } else if (drawingPoints[i + 1] == null) {
        offsetList.clear();
        offsetList.add(drawingPoints[i].offset!);
        canvas.drawPoints(
            PointMode.points, offsetList, drawingPoints[i].paint!);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
