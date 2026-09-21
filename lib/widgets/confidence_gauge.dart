import 'dart:math';
import 'package:flutter/material.dart';

class ConfidenceGauge extends StatelessWidget {
  final double value; // 0.0 ～ 100.0

  const ConfidenceGauge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('信頼度', style: TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        SizedBox(
          width: 90,
          height: 45,
          child: CustomPaint(
            painter: _GaugePainter(value),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toInt()}%',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4CC9F0)),
        ),
        const Text('高い', style: TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  _GaugePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 4;

    // 背景の半円弧（グラデーション）
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [Colors.redAccent, Colors.yellowAccent, Colors.greenAccent],
        startAngle: pi,
        endAngle: pi * 2,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      bgPaint,
    );

    // 指針（針）の描画
    double angle = pi + (value / 100.0) * pi;
    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + (radius - 8) * cos(angle),
      center.dy + (radius - 8) * sin(angle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
