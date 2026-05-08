import 'package:flutter/material.dart';

class GlobePainter extends CustomPainter {
  const GlobePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 0.5;

    canvas.drawCircle(Offset(cx, cy), r, paint);
    canvas.drawLine(Offset(1, cy), Offset(size.width - 1, cy), paint);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: size.width * 0.5,
        height: size.height - 1,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(GlobePainter old) => old.color != color;
}
