import 'package:com.cherish.zwt.fridge/controllers/fridge_controller.dart';
import 'package:com.cherish.zwt.fridge/models/food_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:provider/provider.dart';

class MyBarChart extends StatefulWidget {
  const MyBarChart({super.key});

  @override
  _MyBarChartState createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  final List<double> mockData =
      List.generate(130, (index) => Random().nextInt(15) + 5.0);
  late List<FoodCategory> chartData;
  // 当前页码
  int currentPage = 0;
  final int itemsPerPage = 12; // 每页显示的条数
  List<FoodCategory> getChartDataFromProvider(
      FridgeProvider fridgeProvider, String categoryId) {
    return fridgeProvider.foodCategory;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final fridgeProvider = Provider.of<FridgeProvider>(context, listen: false);
    chartData = getChartDataFromProvider(fridgeProvider, '1');
    dev.log("chartData:${chartData[0].toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            child: SizedBox(
              width: 600, // 固定宽度
              height: 500,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  alignment: BarChartAlignment.spaceEvenly,
                  maxY: 20,
                  titlesData: FlTitlesData(
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        getTitlesWidget: (value, meta) {
                          return Center(
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              '${(value.toInt() + 1 + currentPage * itemsPerPage).toString()}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        },
                        reservedSize: 50, // 足够空间避免溢出
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  barGroups: _generateBarGroups(), //each bar item
                ),
              ),
            ),
          ),

          _buildPaginationControls(), // 添加分页控制
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return List.generate(
      itemsPerPage,
      (index) {
        int dataIndex = currentPage * itemsPerPage + index;
        if (dataIndex >= mockData.length) return null;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: mockData[dataIndex], //占据最大高度的值
              color: Colors.black,
              width: 20, // 更小的宽度适合大量数据
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                color: Colors.grey[600],
                toY: 20, //最大高度
              ),
            ),
          ],
        );
      },
    ).where((element) => element != null).toList().cast<BarChartGroupData>();
  }

  Widget _buildPaginationControls() {
    int totalPages = (mockData.length / itemsPerPage).ceil();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: currentPage > 0
                ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                : null,
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Page ${currentPage + 1} of $totalPages'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: currentPage < totalPages - 1
                ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
