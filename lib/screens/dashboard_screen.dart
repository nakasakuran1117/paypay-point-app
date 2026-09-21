import 'package:flutter/material.dart';
import '../widgets/candlestick_chart.dart';
import '../widgets/confidence_gauge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isAutoUpdate = false;
  String selectedPeriod = '1日';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Point Auto\nManager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          Row(
            children: [
              const Text('自動更新', style: TextStyle(fontSize: 11, color: Colors.grey)),
              Switch(
                value: isAutoUpdate,
                onChanged: (val) => setState(() => isAutoUpdate = val),
                activeColor: const Color(0xFF4895EF),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('今の状況をひと目で確認', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),

            // 1. コースカード
            _buildCourseCard(),
            const SizedBox(height: 16),

            // 2. チャートカード
            _buildChartCard(),
            const SizedBox(height: 16),

            // 3. 現在のポイント状況 & ステータスグリッド
            _buildStatusCard(),
            const SizedBox(height: 16),

            // 4. 免責事項（法的リスク回避表記）
            _buildDisclaimer(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4895EF).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.emoji_events_outlined, color: Color(0xFF4895EF)),
                  SizedBox(width: 8),
                  Text('スタンダード', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('選択中', style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('リスク: 低〜中', style: TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('1169 pt', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('上昇傾向', style: TextStyle(color: Color(0xFF4895EF), fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('📈 値動き', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('タップで選択・長押しで詳細', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          const CandlestickChart(),
          const SizedBox(height: 12),
          // 期間切替ボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['1分', '1日', '1月', '1年', '3年', '最新'].map((p) {
              bool isSelected = p == selectedPeriod;
              return GestureDetector(
                onTap: () => setState(() => selectedPeriod = p),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4895EF) : const Color(0xFF1C2541),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(p, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.grey)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131B2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('現在のポイント状況', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('現在のポイント', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 4),
                  const Text('1169 pt', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4895EF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('判断  追加候補', style: TextStyle(color: Color(0xFF4895EF), fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const ConfidenceGauge(value: 80.0),
            ],
          ),
          const SizedBox(height: 16),
          // グリッドステータス
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: const [
              _StatusItem(label: 'トレンド', value: '上昇傾向', valueColor: Color(0xFF4895EF)),
              _StatusItem(label: '変動幅', value: '低'),
              _StatusItem(label: '前回比', value: '-12 pt', valueColor: Colors.redAccent),
              _StatusItem(label: '手数料', value: '1.00%'),
              _StatusItem(label: '差引き試算', value: '±0.00%'),
              _StatusItem(label: '前回比率', value: '-1.00%', valueColor: Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'ⓘ この分析は動作確認用の合成データに基づく参考情報です。\n実際のPayPay操作は公式アプリで行います。',
        style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.4),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatusItem({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2541),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor ?? Colors.white)),
        ],
      ),
    );
  }
}
