<<<<<<< HEAD
// lib/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/wallet.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // ---- mock state, replace with your API/provider/bloc ----
  final double totalValue = 85420.50;
  final double pnlAmt = 2184.30;
  final double pnlPct = 2.62;

  String instrument = 'XAU/USD';
  String timeframe = '1D';

  final wallets = <Wallet>[
    Wallet(key:'gold',     displayName:'Gold',     amount:3.25,    unit:'oz',  type:'metal', avgCost:2280.50, accentColor:AppColors.gold,     verified:true),
    Wallet(key:'silver',   displayName:'Silver',   amount:125.50,  unit:'oz',  type:'metal', avgCost:26.80,   accentColor:AppColors.silver,   verified:true),
    Wallet(key:'platinum', displayName:'Platinum', amount:1.50,    unit:'oz',  type:'metal', avgCost:945.00,  accentColor:AppColors.platinum, verified:true),
    Wallet(key:'USD',      displayName:'USD',      amount:12450.00,unit:'USD', type:'fiat',  accentColor:AppColors.usd, verified:true),
    Wallet(key:'SGD',      displayName:'SGD',      amount:8320.50, unit:'SGD', type:'fiat',  accentColor:AppColors.sgd, verified:true),
    Wallet(key:'retire',   displayName:'Retirement Fund', amount:1.00, unit:'oz', type:'metal', avgCost:2310.00, accentColor:AppColors.gold, verified:true, custom:true),
  ];

  final market = <MarketRow>[
    MarketRow('XAU/USD', 2345.20, 2346.80, 0.42, 2351.00, 2330.10),
    MarketRow('XAG/USD',   29.85,   29.92, -0.18,  30.20,   29.65),
    MarketRow('XPT/USD',  955.40,  957.10, 0.65,  960.00,  948.30),
    MarketRow('USD/SGD',    1.345,   1.346, -0.05,   1.349,   1.343),
  ];

  // ---------- chart data: replace with live data ----------
  List<FlSpot> get chartSpots => List.generate(
    24, (i) => FlSpot(i.toDouble(), 2330 + 25 * (i % 5) / 4 + (i.isEven ? 6 : -3)),
  );

  final _walletScroll = ScrollController();

  void _scrollWallets(int dir) {
    final offset = _walletScroll.offset + dir * 220;
    _walletScroll.animateTo(
      offset.clamp(0, _walletScroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopRow(),
            const SizedBox(height: 20),
            _buildBottomLayout(),
            const SizedBox(height: 16),
            const Text('My Saving Plans',
                style: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _buildSavingPlansGrid(),
=======
import 'package:flutter/material.dart';
import 'package:projectapp/constant/colours.dart';
import 'package:projectapp/screen/settings.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Background,
      appBar: AppBar(
        backgroundColor: Background,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'GBNX ', style: TextStyle(color: btn)),
              const TextSpan(text: 'Digital App', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 30),
            _buildSectionHeader("My Wallets", () {}),
            const SizedBox(height: 15),
            _buildWalletsList(), // Increased size for better appearance
            const SizedBox(height: 30),
            _buildSectionHeader("My Saving Plans", () {}),
            const SizedBox(height: 15),
            _buildSavingPlans(),
            const SizedBox(height: 30),
            _buildQuickActions(), // Moved under My Saving Plans
            const SizedBox(height: 30),
            _buildSectionHeader("Storage Charges", () {}),
            const SizedBox(height: 15),
            _buildStorageChargesCard(),
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  // ============== TOP ROW: portfolio + wallets ==============
  Widget _buildTopRow() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _panelBox(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildPortfolioSummary(),
          const SizedBox(width: 24),
          Container(width: 1, height: 90, color: AppColors.border),
          const SizedBox(width: 16),
          Expanded(child: _buildWalletCarousel()),
        ],
      ),
    );
  }

  Widget _buildPortfolioSummary() {
    final pnlPositive = pnlAmt >= 0;
    final fmt = NumberFormat('#,##0.00');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('TOTAL VALUE',
            style: TextStyle(color: AppColors.muted, fontSize: 12, letterSpacing: 0.5, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text('${fmt.format(totalValue)} USD',
            style: const TextStyle(color: AppColors.text, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(pnlPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: AppColors.green, size: 18),
              const SizedBox(width: 4),
              Text(
                '${pnlPositive ? "+" : "-"}${fmt.format(pnlAmt.abs())} USD '
                    '(${pnlPositive ? "+" : ""}${pnlPct.toStringAsFixed(2)}%)',
                style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCarousel() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 130,
          child: ListView.separated(
            controller: _walletScroll,
            scrollDirection: Axis.horizontal,
            itemCount: wallets.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => i == wallets.length
                ? _addWalletCard()
                : _walletCard(wallets[i]),
          ),
        ),
        Positioned(left: -4, child: _scrollBtn(Icons.chevron_left, () => _scrollWallets(-1))),
        Positioned(right: -4, child: _scrollBtn(Icons.chevron_right, () => _scrollWallets(1))),
      ],
    );
  }

  Widget _scrollBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.panel2,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 36, height: 36, child: Icon(icon, color: AppColors.text, size: 20)),
      ),
    );
  }

  Widget _walletCard(Wallet w) {
    final fmt = NumberFormat('#,##0.00');
    final amountStr = w.type == 'metal'
        ? '${fmt.format(w.amount * 31.1035)} g'   // oz → g
        : '${fmt.format(w.amount)} ${w.unit}';
    return Container(
      width: 200,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
=======
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: btn,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: btn.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          // top stripe
          Container(height: 3, width: double.infinity, color: w.accentColor,
              margin: const EdgeInsets.only(bottom: 10)),
          Row(
            children: [
              Expanded(child: Text(w.displayName,
                  style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 13),
                  overflow: TextOverflow.ellipsis)),
              if (w.verified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Verified',
                      style: TextStyle(color: AppColors.green, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(amountStr,
              style: const TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w700)),
          if (w.avgCost != null) ...[
            const SizedBox(height: 4),
            Text('Avg ${fmt.format(w.avgCost!)}',
                style: const TextStyle(color: AppColors.muted, fontSize: 11)),
          ],
        ],
      ),
    );
  }

  Widget _addWalletCard() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5, style: BorderStyle.solid),
      ),
      child: const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.add, color: AppColors.muted, size: 32),
          SizedBox(height: 4),
          Text('Add Wallet', style: TextStyle(color: AppColors.muted, fontSize: 13)),
        ]),
      ),
    );
  }

  // ============== BOTTOM: chart+market (left) + quick exchange (right) ==============
  Widget _buildBottomLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Column(children: [
            _buildChartCard(),
            const SizedBox(height: 16),
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(flex: 3, child: _buildQuickExchange()),
      ],
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _panelBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _instrumentDropdown(),
            const SizedBox(width: 12),
            const Text('2,346.80 USD',
                style: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('+0.42%',
                  style: TextStyle(color: AppColors.green, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            const Spacer(),
            _timeframeToggle(),
          ]),
          const SizedBox(height: 16),
          SizedBox(height: 280, child: _buildLineChart()),
=======
          const Text(
            "Total Balance",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            "SGD 45,250.00",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 5),
              const Text("+2.5% this month", style: TextStyle(color: Colors.greenAccent)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionItem(Icons.send_rounded, "Send"),
        _actionItem(Icons.account_balance_wallet_rounded, "Receive"),
        _actionItem(Icons.currency_exchange_rounded, "Exchange"),
      ],
    );
  }

  Widget _actionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6FA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: btn, size: 28),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onTap,
          child: Text("See All", style: TextStyle(color: btn)),
        ),
      ],
    );
  }

  Widget _buildWalletsList() {
    return SizedBox(
      height: 170, // Increased height for larger rectangles
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _walletCard(
            "Gold Wallet",
            "SGD 32,000",
            [const Color(0xFFFFD700), const Color(0xFFFFA500)],
            Icons.stars_rounded,
          ),
          _walletCard(
            "Silver Wallet",
            "SGD 8,000",
            [const Color(0xFFC0C0C0), const Color(0xFFA9A9A9)],
            Icons.monetization_on_rounded,
          ),
          _walletCard(
            "Platinum Wallet",
            "SGD 5,250",
            [const Color(0xFFE5E4E2), const Color(0xFFB7B7B7)],
            Icons.workspace_premium_rounded,
          ),
        ],
      ),
    );
  }

  Widget _walletCard(String name, String balance, List<Color> colors, IconData icon) {
    return Container(
      width: 333, // Increased width by 33px for an even wider look
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(35), // Even more rounded for a modern look
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const Icon(Icons.more_horiz, color: Colors.white70, size: 24),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                balance,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
        ],
      ),
    );
  }

<<<<<<< HEAD
  Widget _instrumentDropdown() {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.panel2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButton<String>(
          value: instrument,
          dropdownColor: AppColors.panel,
          style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
          icon: const Icon(Icons.expand_more, color: AppColors.muted, size: 16),
          items: const [
            DropdownMenuItem(value: 'XAU/USD', child: Text('XAU/USD')),
            DropdownMenuItem(value: 'XAG/USD', child: Text('XAG/USD')),
            DropdownMenuItem(value: 'XPT/USD', child: Text('XPT/USD')),
            DropdownMenuItem(value: 'USD/SGD', child: Text('USD/SGD')),
          ],
          onChanged: (v) => setState(() => instrument = v ?? instrument),
        ),
      ),
    );
  }

  Widget _timeframeToggle() {
    const tfs = ['1H', '1D', '1W', '1M', '1Y'];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panel2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(mainAxisSize: MainAxisSize.min, children: tfs.map((tf) {
        final active = tf == timeframe;
        return GestureDetector(
          onTap: () => setState(() => timeframe = tf),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: active ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(tf,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.muted,
                  fontSize: 12, fontWeight: FontWeight.w600,
                )),
          ),
        );
      }).toList()),
    );
  }

  Widget _buildLineChart() {
    return LineChart(LineChartData(
      gridData: FlGridData(
        show: true, drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.border, strokeWidth: 0.5),
      ),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: chartSpots,
          isCurved: true, barWidth: 2.5,
          color: AppColors.gold,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [AppColors.gold.withOpacity(0.3), AppColors.gold.withOpacity(0.0)],
            ),
          ),
        ),
      ],
    ));
  }

  TableRow _marketHeaderRow() {
    const style = TextStyle(color: AppColors.muted, fontSize: 11,
        fontWeight: FontWeight.w600, letterSpacing: 0.5);
    return const TableRow(children: [
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('ASSET', style: style)),
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('BID', style: style)),
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('ASK', style: style)),
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('CHANGE', style: style)),
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('HIGH', style: style)),
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('LOW', style: style)),
    ]);
  }

  TableRow _marketDataRow(MarketRow r) {
    final up = r.changePct >= 0;
    const cell = TextStyle(color: AppColors.text, fontSize: 13);
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(r.asset, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(r.bid.toStringAsFixed(2), style: cell)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(r.ask.toStringAsFixed(2), style: cell)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('${up ? "+" : ""}${r.changePct.toStringAsFixed(2)}%',
                style: TextStyle(color: up ? AppColors.green : AppColors.red, fontWeight: FontWeight.w600))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(r.high.toStringAsFixed(2), style: cell)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(r.low.toStringAsFixed(2), style: cell)),
=======
  Widget _buildSavingPlans() {
    return Column(
      children: [
        _savingPlanTile("Retirement Fund", 0.65, "SGD 12,000 / 20,000", Colors.orange),
        _savingPlanTile("New Car", 0.40, "SGD 8,000 / 20,000", Colors.blue),
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
      ],
    );
  }

<<<<<<< HEAD
  // ============== QUICK EXCHANGE ==============
  String qeFrom = 'gold';
  String qeTo = 'silver';
  final qeAmountCtrl = TextEditingController();

  Widget _buildQuickExchange() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _panelBox(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Quick Exchange',
            style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        _qeLabel('From'),
        _qeAssetDropdown(qeFrom, (v) => setState(() => qeFrom = v!)),
        const SizedBox(height: 12),
        _qeLabel('Source Wallet'),
        _qeWalletDropdown(),
        const SizedBox(height: 12),
        _qeLabel('Exchange amount'),
        TextField(
          controller: qeAmountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.text),
          decoration: _qeInputDecoration(hint: '0.00', suffix: 'g'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        _qeLabel('To'),
        _qeAssetDropdown(qeTo, (v) => setState(() => qeTo = v!)),
        const SizedBox(height: 12),
        _qeLabel('Receive amount'),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.panel2,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text('—',
              style: TextStyle(color: AppColors.text, fontSize: 17, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exchange placed')),
              );
            },
            child: const Text('Place Order'),
          ),
        ),
      ]),
    );
  }

  Widget _qeLabel(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w500)),
  );

  Widget _qeAssetDropdown(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.panel2,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.panel,
          style: const TextStyle(color: AppColors.text),
          icon: const Icon(Icons.expand_more, color: AppColors.muted),
          items: const [
            DropdownMenuItem(value: 'gold',     child: Text('Gold')),
            DropdownMenuItem(value: 'silver',   child: Text('Silver')),
            DropdownMenuItem(value: 'platinum', child: Text('Platinum')),
            DropdownMenuItem(value: 'USD',      child: Text('USD')),
            DropdownMenuItem(value: 'SGD',      child: Text('SGD')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _qeWalletDropdown() {
    final opts = wallets.where((w) => w.key.toLowerCase().contains(qeFrom.toLowerCase())).toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.panel2,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Text('Select wallet', style: TextStyle(color: AppColors.muted)),
          dropdownColor: AppColors.panel,
          style: const TextStyle(color: AppColors.text),
          icon: const Icon(Icons.expand_more, color: AppColors.muted),
          items: opts.map((w) => DropdownMenuItem(value: w.key, child: Text(w.displayName))).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  InputDecoration _qeInputDecoration({String? hint, String? suffix}) => InputDecoration(
    hintText: hint, hintStyle: const TextStyle(color: AppColors.muted),
    suffixText: suffix, suffixStyle: const TextStyle(color: AppColors.muted),
    filled: true, fillColor: AppColors.panel2,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.border),
      borderRadius: BorderRadius.circular(6),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.accent),
      borderRadius: BorderRadius.circular(6),
    ),
  );

  // ============== SAVING PLANS GRID ==============
  Widget _buildSavingPlansGrid() {
    final plans = [
      ('Gold',     '12 month plan', 0.65, '650 g / 1000 g',  '21 Apr 2026'),
      ('Silver',   'Ongoing plan',  0.28, '14.20 g / 50.00 g','1 May 2026'),
      ('Platinum', 'Daily plan',    0.12, '120 g / 1000 g',  '14 May 2026'),
    ];
    return LayoutBuilder(builder: (_, c) {
      final cols = c.maxWidth > 1100 ? 3 : c.maxWidth > 700 ? 2 : 1;
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12, crossAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: plans.map((p) => _savingPlanCard(p.$1, p.$2, p.$3, p.$4, p.$5)).toList(),
      );
    });
  }

  Widget _savingPlanCard(String name, String desc, double pct, String progress, String nextRun) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
              child: const Text('Active',
                  style: TextStyle(color: AppColors.green, fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Text('${(pct * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            const Text('Accumulated', style: TextStyle(color: AppColors.muted, fontSize: 12)),
            const Spacer(),
            Text(progress, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct, minHeight: 6,
              backgroundColor: AppColors.panel2, valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
          const Spacer(),
          Row(children: [
            const Text('Next run: ', style: TextStyle(color: AppColors.muted, fontSize: 12)),
            Text(nextRun, style: const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
=======
  Widget _savingPlanTile(String title, double progress, String detail, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("${(progress * 100).toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: color,
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(detail, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageChargesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storage_rounded, color: Colors.redAccent),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Monthly Storage Fee", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("SGD 5.00 due on 1st Oct", style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: btn,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Pay", style: TextStyle(color: Colors.white)),
          ),
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
        ],
      ),
    );
  }
<<<<<<< HEAD

  // ============== shared ==============
  BoxDecoration _panelBox() => BoxDecoration(
    color: AppColors.panel,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
  );

  @override
  void dispose() {
    _walletScroll.dispose();
    qeAmountCtrl.dispose();
    super.dispose();
  }
}
=======
}
>>>>>>> dad7861bff05e73639116e2d7911d08ec2d778c2
