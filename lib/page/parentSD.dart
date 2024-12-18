import 'package:flutter/material.dart';

class CustomFunctionGraph extends StatefulWidget {
  @override
  _CustomFunctionGraphState createState() => _CustomFunctionGraphState();
}

class _CustomFunctionGraphState extends State<CustomFunctionGraph> with SingleTickerProviderStateMixin {
  Offset _tooltipPosition = Offset.zero;
  bool _showTooltip = false;
  double _tooltipValue = 0.0;
  AnimationController? _animationController;
  Animation<double>? _tooltipOpacity;
  Animation<Offset>? _tooltipPositionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _tooltipOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
    _tooltipPositionAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -40),
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      child: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _tooltipPosition = details.localPosition;
                _showTooltip = true;
                _tooltipValue = _getValueAtPosition(details.localPosition);
                _animationController?.forward();
              });
            },
            onPanEnd: (_) {
              _animationController?.reverse().then((_) {
                setState(() {
                  _showTooltip = false;
                });
              });
            },
            child: CustomPaint(
              size: Size(double.infinity, screenHeight * 0.4), // Responsive height
              painter: FunctionGraphPainter(),
            ),
          ),
          AnimatedBuilder(
            animation: _animationController!,
            builder: (context, child) {
              return Positioned(
                left: _tooltipPosition.dx,
                top: _tooltipPosition.dy + _tooltipPositionAnimation!.value.dy,
                child: Opacity(
                  opacity: _tooltipOpacity!.value,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02, // Responsive padding
                        vertical: screenHeight * 0.01, // Responsive padding
                      ),
                      color: Colors.black87.withOpacity(0.8),
                      child: Text(
                        '${_tooltipValue.toStringAsFixed(1)} hours',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.03, // Responsive font size
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double _getValueAtPosition(Offset position) {
    double stepWidth = MediaQuery.of(context).size.width / 7;
    int dayIndex = (position.dx / stepWidth).floor();
    List<double> studyHours = [6, 4.5, 3, 6, 2, 0, 0]; // Example hours for each day (Sun-Sat)

    return studyHours[dayIndex];
  }
}

class FunctionGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintFill = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red.shade300.withOpacity(0.3), Colors.red.withOpacity(0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    Paint paintLine = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red.shade700, Colors.red.shade900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    Paint paintAxis = Paint()
      ..color = Colors.grey[900]!
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    TextStyle textStyle = TextStyle(
      color: Colors.grey[800]!,
      fontSize: size.width * 0.035, // Responsive font size
      fontWeight: FontWeight.w600,
      fontFamily: 'Roboto',
    );

    double stepWidth = size.width / 7;
    double stepHeight = size.height / 6;

    void drawGridLine(Offset start, Offset end) {
      canvas.drawLine(start, end, paintGrid);
    }

    for (double i = stepHeight; i <= size.height; i += stepHeight) {
      drawGridLine(Offset(0, i), Offset(size.width, i));
    }

    for (double i = stepWidth; i <= size.width; i += stepWidth) {
      drawGridLine(Offset(i, 0), Offset(i, size.height));
    }

    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paintAxis);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paintAxis);

    List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < days.length; i++) {
      textPainter.text = TextSpan(
        text: days[i],
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(i * stepWidth + (stepWidth - textPainter.width) / 2, size.height - textPainter.height - 8),
      );
    }

    List<String> hours = ['0', '1', '2', '3', '4', '5', '6'];
    for (int i = 0; i < hours.length; i++) {
      textPainter.text = TextSpan(
        text: hours[i],
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width - 10, size.height - i * stepHeight - (textPainter.height / 2)),
      );
    }

    List<double> studyHours = [6, 4.5, 3, 6, 2, 0, 0];

    Path path = Path();
    path.moveTo(0, size.height - ((studyHours[0] - 0) / 6) * size.height);

    for (int i = 1; i < studyHours.length; i++) {
      double x = i * stepWidth;
      double y = size.height - ((studyHours[i] - 0) / 6) * size.height;

      path.quadraticBezierTo(
        (x - stepWidth / 2),
        size.height - ((studyHours[i - 1] - 0) / 6) * size.height,
        x,
        y,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paintFill);
    canvas.drawPath(path, paintLine);

    for (int i = 0; i < studyHours.length; i++) {
      double x = i * stepWidth;
      double y = size.height - ((studyHours[i] - 0) / 6) * size.height;

      TextStyle labelStyle = TextStyle(
        color: Colors.black,
        fontSize: size.width * 0.03, // Responsive font size
        fontWeight: FontWeight.bold,
      );

      textPainter.text = TextSpan(
        text: '${studyHours[i].toStringAsFixed(1)}',
        style: labelStyle,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height - 4),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
