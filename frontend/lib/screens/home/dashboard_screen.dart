import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/transaction_service.dart';
import '../../services/auth_service.dart';
import '../../screens/transactions/add_transaction_screen.dart';
import '../../screens/transactions/transaction_history_screen.dart';
import '../../screens/settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  Key _dashboardKey = UniqueKey();
  String _timeFilter = 'Month';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleFilterChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _timeFilter = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = DashboardContent(
          key: _dashboardKey,
          timeFilter: _timeFilter,
          onFilterChanged: _handleFilterChanged,
        );
        break;
      case 1:
        page = TransactionHistoryScreen();
        break;
      case 2:
        page = SettingsScreen();
        break;
      default:
        page = DashboardContent(
          key: _dashboardKey,
          timeFilter: _timeFilter,
          onFilterChanged: _handleFilterChanged,
        );
    }

    return Scaffold(
      body: page,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: const Color(0xFFFFFFFF),
          selectedItemColor: const Color(0xFF137FEC),
          unselectedItemColor: const Color(0xFF64748B),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF137FEC),
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AddTransactionScreen.routeName).then((_) {
                  setState(() {
                    _dashboardKey = UniqueKey();
                  });
                });
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class DashboardContent extends StatefulWidget {
  final String timeFilter;
  final ValueChanged<String?> onFilterChanged;

  const DashboardContent({
    super.key,
    required this.timeFilter,
    required this.onFilterChanged,
  });

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  Map<String, dynamic> _summary = {
    'earnings': 0.0,
    'expenditures': 0.0,
    'savings': 0.0,
  };
  Map<String, double> _categorySpending = {};
  bool _isLoading = true;
  bool _showPieChart = false;
  final TransactionService _transactionService = TransactionService();
  final AuthService _authService = AuthService();
  double _monthlyBudget = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant DashboardContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timeFilter != oldWidget.timeFilter) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final summary = await _transactionService.fetchSummary(
        widget.timeFilter.toLowerCase(),
      );
      final categorySpending = await _transactionService
          .fetchCategorySpending();
      final user = await _authService.fetchUserProfile();
      setState(() {
        _summary = summary;
        _categorySpending = categorySpending;
        _monthlyBudget = user.monthlyBudget;
      });
    } catch (e) {
      // debugPrint('Error fetching dashboard data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF137FEC);
    const backgroundLight = Color(0xFFF6F7F8);
    const surfaceWhite = Color(0xFFFFFFFF);
    const textDark = Color(0xFF1E293B);
    const textMedium = Color(0xFF64748B);
    const textLight = Color(0xFF94A3B8);
    const borderColor = Color(0xFFE2E8F0);
    const successColor = Color(0xFF10B981);
    const dangerColor = Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: surfaceWhite,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: borderColor, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: widget.timeFilter,
                                items: ['Week', 'Month'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textDark,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: widget.onFilterChanged,
                                icon: const Icon(
                                  Icons.expand_more,
                                  color: textLight,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Summary Cards
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildSummaryCardNew(
                                  title: 'Total Income',
                                  amount:
                                      '₹${(_summary['earnings'] as num).toStringAsFixed(0)}',
                                  icon: Icons.arrow_downward,
                                  backgroundColor: const Color(0xFFF0FDF4),
                                  iconColor: successColor,
                                  textColor: textDark,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSummaryCardNew(
                                  title: 'Total Spent',
                                  amount:
                                      '₹${(_summary['expenditures'] as num).toStringAsFixed(0)}',
                                  icon: Icons.arrow_upward,
                                  backgroundColor: const Color(0xFFFEF2F2),
                                  iconColor: dangerColor,
                                  textColor: textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildSavingsCard(
                            amount:
                                '₹${(_summary['savings'] as num).toStringAsFixed(0)}',
                            status: 'On track',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Chart Card
                      Container(
                        decoration: BoxDecoration(
                          color: surfaceWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _showPieChart
                                          ? 'Category Breakdown'
                                          : 'Budget vs Spent',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Daily comparison for this ${widget.timeFilter.toLowerCase()}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: textMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    _showPieChart
                                        ? Icons.bar_chart
                                        : Icons.pie_chart,
                                    color: primaryBlue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showPieChart = !_showPieChart;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (!_showPieChart)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: primaryBlue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Budget',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: dangerColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Spent',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 300,
                              child: _monthlyBudget <= 0
                                  ? _buildSetBudgetPrompt(primaryBlue)
                                  : (_summary['earnings'] == 0 &&
                                        _summary['expenditures'] == 0 &&
                                        _summary['savings'] == 0)
                                  ? _buildLogTransactionPrompt(primaryBlue)
                                  : _showPieChart
                                  ? _buildCategoryPieChart()
                                  : _buildBudgetChart(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCardNew({
    required String title,
    required String amount,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    String? trend,
    Color? trendColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 20)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          if (trend != null && trendColor != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.trending_up, size: 14, color: trendColor),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: trendColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSavingsCard({required String amount, required String status}) {
    const primaryBlue = Color(0xFF137FEC);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryBlue, Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.savings, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Total Savings',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC7D2E0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFC7D2E0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetChart() {
    final expenses = (_summary['expenditures'] as num).toDouble();
    final budget = _monthlyBudget;
    final maxY = (budget > expenses ? budget : expenses) * 1.2;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY > 0 ? maxY : 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String label;
              switch (group.x) {
                case 0:
                  label = 'Budget';
                  break;
                case 1:
                  label = 'Spent';
                  break;
                default:
                  label = '';
              }
              return BarTooltipItem(
                '$label\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '₹${rod.toY.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                );
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('Budget', style: style);
                    break;
                  case 1:
                    text = const Text('Spent', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(meta: meta, child: text);
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: expenses,
                color: expenses > budget ? Colors.red : Colors.green,
                width: 25,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: budget,
                color: Colors.blue,
                width: 25,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetBudgetPrompt(Color primaryBlue) {
    const textMedium = Color(0xFF64748B);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet, size: 48, color: textMedium),
          const SizedBox(height: 16),
          const Text(
            'Set a budget to see insights',
            style: TextStyle(fontSize: 16, color: textMedium),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SettingsScreen.routeName).then((
                  _,
                ) {
                  _fetchData();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Set Budget',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogTransactionPrompt(Color primaryBlue) {
    const textMedium = Color(0xFF64748B);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 48, color: textMedium),
          const SizedBox(height: 16),
          const Text(
            'Log your first transaction',
            style: TextStyle(fontSize: 16, color: textMedium),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AddTransactionScreen.routeName).then((_) {
                  _fetchData();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Log Transaction',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPieChart() {
    if (_categorySpending.isEmpty) {
      return Center(child: Text('No expenses to display'));
    }

    final double total = _categorySpending.values.reduce((a, b) => a + b);
    int index = 0;
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
    ];

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _categorySpending.entries.map((entry) {
                final isLarge = entry.value / total > 0.1;
                final color = colors[index % colors.length];
                index++;
                return PieChartSectionData(
                  color: color,
                  value: entry.value,
                  title: '${(entry.value / total * 100).toStringAsFixed(0)}%',
                  radius: isLarge ? 50 : 40,
                  titleStyle: TextStyle(
                    fontSize: isLarge ? 16 : 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _categorySpending.entries.map((entry) {
              final color =
                  colors[_categorySpending.keys.toList().indexOf(entry.key) %
                      colors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
