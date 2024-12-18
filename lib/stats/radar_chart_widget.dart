import 'package:flutter/material.dart';
import 'dart:math';

class RadarChartWidget extends StatelessWidget {
  final List<RadarData> data;
  final String title;

  RadarChartWidget({
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 300), // Adjust size as needed
      painter: RadarChartPainter(data: data, title: title),
    );
  }
}

class RadarData {
  final String moduleName;
  final double value;

  RadarData({
    required this.moduleName,
    required this.value,
  });
}

class RadarChartPainter extends CustomPainter {
  final List<RadarData> data;
  final String title;

  RadarChartPainter({
    required this.data,
    required this.title,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'No data available',
          style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height / 2 - textPainter.height / 2));
      return;
    }

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple.withOpacity(0.3), Colors.purple.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20; // Adjust padding
    final step = 2 * pi / data.length;

    // Calculate the maximum value for scaling
    final maxValue = data.map((d) => d.value).reduce(max);

    // Draw the radar chart grid
    for (int i = 0; i < data.length; i++) {
      final angle = step * i;
      final x = center.dx + (radius * cos(angle));
      final y = center.dy + (radius * sin(angle));
      if (i > 0) {
        canvas.drawLine(center, Offset(x, y), gridPaint);
      }
      canvas.drawLine(center, Offset(x, y), gridPaint);

      // Draw axis labels with improved alignment
      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].moduleName,
          style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final labelOffset = Offset(
        x - textPainter.width / 2,
        y - textPainter.height / 2,
      );
      textPainter.paint(canvas, labelOffset);
    }

    // Draw the radar chart area
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final angle = step * i;
      final x = center.dx + (radius * (data[i].value / maxValue) * cos(angle));
      final y = center.dy + (radius * (data[i].value / maxValue) * sin(angle));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Fill the radar chart area
    canvas.drawPath(path, fillPaint);
    // Draw the radar chart outline
    canvas.drawPath(path, linePaint);

    // Draw title with additional space
    final titlePainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final titleOffset = Offset(center.dx - titlePainter.width / 2, 0); // Adjust the 20 to increase/decrease space
    titlePainter.paint(canvas, titleOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
