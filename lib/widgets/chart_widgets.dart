import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';

class CustomPieChart extends StatelessWidget {
  final Map<String, double> data;
  final List<Color> colors;

  const CustomPieChart({
    Key? key,
    required this.data,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<double>(0, (sum, value) => sum + value);
    
    if (total == 0) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingXL),
          decoration: PixelDecorations.pixelCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📊', style: TextStyle(fontSize: 48)),
              SizedBox(height: AppConstants.spacingM),
              Text(
                'Tidak ada data',
                style: PixelTextStyles.body,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: PixelDecorations.pixelCard(),
      padding: EdgeInsets.all(AppConstants.spacingL),
      child: PieChart(
        PieChartData(
          sections: _buildSections(total),
          sectionsSpace: 3,
          centerSpaceRadius: 60,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(double total) {
    int index = 0;
    return data.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final color = colors[index % colors.length];
      index++;

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 80,
        titleStyle: PixelTextStyles.body.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        color: color,
      );
    }).toList();
  }
}

class CustomBarChart extends StatelessWidget {
  final Map<String, double> data;
  final Color barColor;
  final String? title;

  const CustomBarChart({
    Key? key,
    required this.data,
    required this.barColor,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingXL),
          decoration: PixelDecorations.pixelCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📊', style: TextStyle(fontSize: 48)),
              SizedBox(height: AppConstants.spacingM),
              Text(
                'Tidak ada data',
                style: PixelTextStyles.body,
              ),
            ],
          ),
        ),
      );
    }

    final maxY = data.values.reduce((a, b) => a > b ? a : b) * 1.2;

    return Container(
      decoration: PixelDecorations.pixelCard(),
      padding: EdgeInsets.all(AppConstants.spacingL),
      child: Column(
        children: [
          if (title != null) ...[
            Text(title!, style: PixelTextStyles.h3),
            SizedBox(height: AppConstants.spacingL),
          ],
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barGroups: _buildBarGroups(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: PixelTextStyles.label,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.keys.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: AppConstants.spacingS),
                            child: Text(
                              data.keys.elementAt(index),
                              style: PixelTextStyles.label,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppColors.black,
                    width: AppConstants.pixelBorderWidthThin,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.divider,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    int index = 0;
    return data.entries.map((entry) {
      final barData = BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: barColor,
            width: 20,
            borderRadius: BorderRadius.zero, // Pixel style - no rounded corners
            borderSide: BorderSide(
              color: AppColors.black,
              width: 2,
            ),
          ),
        ],
      );
      index++;
      return barData;
    }).toList();
  }
}

class CustomLineChart extends StatelessWidget {
  final Map<String, double> data;
  final Color lineColor;
  final String? title;

  const CustomLineChart({
    Key? key,
    required this.data,
    required this.lineColor,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingXL),
          decoration: PixelDecorations.pixelCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📈', style: TextStyle(fontSize: 48)),
              SizedBox(height: AppConstants.spacingM),
              Text(
                'Tidak ada data',
                style: PixelTextStyles.body,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: PixelDecorations.pixelCard(),
      padding: EdgeInsets.all(AppConstants.spacingL),
      child: Column(
        children: [
          if (title != null) ...[
            Text(title!, style: PixelTextStyles.h3),
            SizedBox(height: AppConstants.spacingL),
          ],
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _buildSpots(),
                    isCurved: false, // Pixel style - straight lines
                    color: lineColor,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotSquarePainter(
                          size: 8,
                          color: lineColor,
                          strokeWidth: 2,
                          strokeColor: AppColors.black,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withOpacity(0.2),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: PixelTextStyles.label,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.keys.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: AppConstants.spacingS),
                            child: Text(
                              data.keys.elementAt(index),
                              style: PixelTextStyles.label,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppColors.black,
                    width: AppConstants.pixelBorderWidthThin,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.divider,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    int index = 0;
    return data.entries.map((entry) {
      final spot = FlSpot(index.toDouble(), entry.value);
      index++;
      return spot;
    }).toList();
  }
}