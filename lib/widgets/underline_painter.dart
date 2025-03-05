import 'package:flutter/material.dart';

class UnderlinePainter extends CustomPainter {
  final Animation<double> animation;

  UnderlinePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final start = Offset(0, size.height);
    final end = Offset(size.width, size.height);

    // 使用动画值来控制下划线的绘制长度
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(animation.value * size.width, end.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant UnderlinePainter oldDelegate) {
    return false; // 动画由RepaintBoundary处理，这里返回false
  }
}
