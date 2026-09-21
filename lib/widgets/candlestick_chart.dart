import 'package:flutter/material.dart';

class CandlestickChart extends StatelessWidget {
  const CandlestickChart({super.key});

  @override
  Widget build(BuildContext context) {
    // 描画用のダミーローソク足データ (始値, 高値, 安値, 終値)
    final candles = [
      _CandleData(1045, 1060, 1040, 1055),
      _CandleData(1055, 1070, 1050, 1065),
      _CandleData(1065, 1065, 1040, 1042), // 陰線
      _CandleData(1042, 1050, 1035, 1038), // 陰線
      _CandleData(1038, 1080, 1035, 1075),
      _CandleData(1075, 1100, 1070, 1095),
      _CandleData(1095, 1120, 1090, 1115),
      _CandleData(1115, 1130, 1100, 1105), // 陰線
      _CandleData(1105, 1160, 1100, 1150),
      _CandleData(1150, 1187, 1140, 1169),
    ];

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomPaint(
        painter: _CandlePainter(candles),
        child: Container(),
      ),
    );
  }
}

class _CandleData {
  final double open;
  final double high;
  final double low;
  final double close;
  _CandleData(this.open, this.high, this.low, this.close);
}

class _CandlePainter extends CustomPainter {
  final List<_CandleData> candles;
  _CandlePainter(this.candles);

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    double minVal = candles.map((e) => e.low).reduce((a, b) => a < b ? a : b);
    double maxVal = candles.map((e) => e.high).reduce((a, b) => a > b ? a : b);
    double range = maxVal - minVal;

    double candleWidth = size.width / (candles.length * 1.8);

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      double x = (i + 0.5) * (size.width / candles.length);

      // Y座標への変換関数
      double getY(double val) => size.height - ((val - minVal) / range * size.height);

      bool isBull = c.close >= c.open; // 陽線か陰線か
      Color color = isBull ? const Color(0xFF4895EF) : const Color(0xFFF72585);

      Paint paint = Paint()
        ..color = color
        ..strokeWidth = 2.0;

      // ヒゲ（高値 - 安値）
      canvas.drawLine(Offset(x, getY(c.high)), Offset(x, getY(c.low)), paint);

      // 実体（始値 - 終値）
      double top = getY(isBull ? c.close : c.open);
      double bottom = getY(isBull ? c.open : c.close);
      double height = (bottom - top).abs();
      if (height < 2) height = 2; // 最低描画サイズ

      Rect rect = Rect.fromLTWH(x - candleWidth / 2, top, candleWidth, height);
      canvas.drawRect(rect, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
