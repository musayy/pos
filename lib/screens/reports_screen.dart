import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/services/database_service.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Map<String, dynamic>> _realReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRealReports();
  }

  Future<void> _fetchRealReports() async {
    final dbService = DatabaseService();
    final salesData = await dbService.fetchSalesData();

    double dailySales = 0;
    double weeklySales = 0;
    double monthlySales = 0;

    for (var sale in salesData) {
      final date = DateTime.parse(sale['date']);
      final amount = sale['totalAmount'] ?? 0.0;

      if (_isToday(date)) {
        dailySales += amount;
      } else if (_isWithinLastWeek(date)) {
        weeklySales += amount;
      } else if (_isWithinLastMonth(date)) {
        monthlySales += amount;
      }
    }

    setState(() {
      _realReports = [
        {'title': 'Daily Sales', 'amount': dailySales, 'date': 'Today'},
        {'title': 'Weekly Sales', 'amount': weeklySales, 'date': 'This Week'},
        {
          'title': 'Monthly Sales',
          'amount': monthlySales,
          'date': 'This Month'
        },
      ];
      _isLoading = false;
    });
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isWithinLastWeek(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now.subtract(Duration(days: 7)));
  }

  bool _isWithinLastMonth(DateTime date) {
    final now = DateTime.now();
    return date.isAfter(now.subtract(Duration(days: 30)));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Reports',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkTheme
                        ? Colors.white
                        : Colors.black)),
          ),
          backgroundColor: themeProvider.isDarkTheme
              ? Colors.black
              : Colors.deepPurpleAccent.shade700,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Reports',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black)),
        ),
        backgroundColor: themeProvider.isDarkTheme
            ? Colors.black
            : Colors.deepPurpleAccent.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.isDarkTheme
              ? LinearGradient(
                  colors: [Colors.black87, Colors.black54],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.deepPurple.shade700,
                    Colors.deepPurpleAccent.shade200
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sales Data Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(child: _buildBarChart(themeProvider)),
            Divider(
              color: themeProvider.isDarkTheme ? Colors.white70 : Colors.grey,
              thickness: 1.2,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Sales Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(child: _buildLineChart(themeProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _realReports.isNotEmpty
              ? _realReports
                      .map((e) => e['amount'] as double)
                      .reduce((a, b) => a > b ? a : b) +
                  5000
              : 60000,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < _realReports.length) {
                    return Text(
                      _realReports[value.toInt()]['title'],
                      style: TextStyle(
                        color: themeProvider.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }
                  return Container();
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      color: themeProvider.isDarkTheme
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 12,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: List.generate(_realReports.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: _realReports[index]['amount'],
                  width: 16,
                  gradient: LinearGradient(
                    colors: themeProvider.isDarkTheme
                        ? [Colors.deepPurpleAccent, Colors.purple]
                        : [Colors.deepPurple, Colors.purpleAccent],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLineChart(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      color: themeProvider.isDarkTheme
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 12,
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < _realReports.length) {
                    return Text(
                      _realReports[value.toInt()]['title'][0],
                      style: TextStyle(
                        color: themeProvider.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }
                  return Container();
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color:
                  themeProvider.isDarkTheme ? Colors.white70 : Colors.black54,
              width: 1,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(_realReports.length, (index) {
                return FlSpot(index.toDouble(), _realReports[index]['amount']);
              }),
              isCurved: true,
              gradient: LinearGradient(
                colors: themeProvider.isDarkTheme
                    ? [Colors.deepPurpleAccent, Colors.purple]
                    : [Colors.deepPurple, Colors.purpleAccent],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: themeProvider.isDarkTheme
                      ? [
                          Colors.deepPurpleAccent.withOpacity(0.3),
                          Colors.purple.withOpacity(0.1)
                        ]
                      : [
                          Colors.deepPurple.withOpacity(0.3),
                          Colors.purpleAccent.withOpacity(0.1)
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
