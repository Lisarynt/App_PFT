import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/animations/fade_in_slide.dart';
import '../../widgets/animations/bouncy_card.dart';
import '../../widgets/animations/animated_number.dart';

class PeriodReportScreen extends StatefulWidget {
  const PeriodReportScreen({Key? key}) : super(key: key);

  @override
  State<PeriodReportScreen> createState() => _PeriodReportScreenState();
}

class _PeriodReportScreenState extends State<PeriodReportScreen> {
  DateTime _selectedDate = DateTime.now();
  String _periodType = 'month';

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final dateRange = _periodType == 'month'
        ? Helpers.getMonthRange(_selectedDate.year, _selectedDate.month)
        : {
            'start': DateTime(_selectedDate.year, 1, 1),
            'end': DateTime(_selectedDate.year, 12, 31, 23, 59, 59),
          };
    final transactions = transactionProvider.getTransactionsByDateRange(
      dateRange['start']!,
      dateRange['end']!,
    );

    final totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold<double>(0, (sum, t) => sum + t.amount);

    final totalExpense = transactions
        .where((t) => t.type == 'expense')
        .fold<double>(0, (sum, t) => sum + t.amount);

    final balance = totalIncome - totalExpense;

    return Scaffold(
      body: PixelBackgroundApp(
        child: SafeArea(
          child: Column(
            children: [
              _buildPixelHeader(context),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppConstants.spacingL),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                        child: Column(
                          children: [
                            FadeInSlide(
                              delay: 0,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildPixelPeriodButton('Bulanan', 'month', '📅'),
                                  ),
                                  SizedBox(width: AppConstants.spacingM),
                                  Expanded(
                                    child: _buildPixelPeriodButton('Tahunan', 'year', '📆'),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: AppConstants.spacingL),
                            
                            FadeInSlide(
                              delay: 100,
                              child: Row(
                                children: [
                                  BouncyCard(
                                    onTap: _previousPeriod,
                                    child: Container(
                                      padding: EdgeInsets.all(AppConstants.spacingM),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        border: Border.all(
                                          color: AppColors.black,
                                          width: AppConstants.pixelBorderWidthThin,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppConstants.pixelCardRadius,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.black,
                                            offset: Offset(2, 2),
                                            blurRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.chevron_left,
                                        color: AppColors.primary,
                                        size: AppConstants.iconSizeM,
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(width: AppConstants.spacingM),
                                  
                                  Expanded(
                                    child: BouncyCard(
                                      onTap: _selectDate,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: AppConstants.spacingL,
                                        ),
                                        decoration: PixelDecorations.pixelCard(),
                                        child: Text(
                                          _periodType == 'month'
                                              ? '${Helpers.getMonthName(_selectedDate.month)} ${_selectedDate.year}'
                                              : '${_selectedDate.year}',
                                          textAlign: TextAlign.center,
                                          style: PixelTextStyles.body.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: AppConstants.fontSizeL,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(width: AppConstants.spacingM),
                                  
                                  BouncyCard(
                                    onTap: _nextPeriod,
                                    child: Container(
                                      padding: EdgeInsets.all(AppConstants.spacingM),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        border: Border.all(
                                          color: AppColors.black,
                                          width: AppConstants.pixelBorderWidthThin,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppConstants.pixelCardRadius,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.black,
                                            offset: Offset(2, 2),
                                            blurRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: AppColors.primary,
                                        size: AppConstants.iconSizeM,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppConstants.spacingXXL),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                        child: Column(
                          children: [
                            FadeInSlide(
                              delay: 200,
                              child: _buildPixelSummaryCard(
                                'Total Pemasukan',
                                totalIncome,
                                '⬇️',
                                AppColors.income,
                                AppColors.incomeBg,
                              ),
                            ),
                            SizedBox(height: AppConstants.spacingM),
                            FadeInSlide(
                              delay: 300,
                              child: _buildPixelSummaryCard(
                                'Total Pengeluaran',
                                totalExpense,
                                '⬆️',
                                AppColors.expense,
                                AppColors.expenseBg,
                              ),
                            ),
                            SizedBox(height: AppConstants.spacingM),
                            FadeInSlide(
                              delay: 400,
                              child: _buildPixelSummaryCard(
                                'Saldo',
                                balance,
                                '💰',
                                balance >= 0 ? AppColors.success : AppColors.danger,
                                balance >= 0 
                                    ? AppColors.success.withOpacity(0.1)
                                    : AppColors.danger.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppConstants.spacingXXL),

                      if (transactions.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeInSlide(
                                delay: 500,
                                child: Text(
                                  'Grafik Pemasukan vs Pengeluaran',
                                  style: PixelTextStyles.h3,
                                ),
                              ),
                              SizedBox(height: AppConstants.spacingL),
                              FadeInSlide(
                                delay: 600,
                                child: Container(
                                  height: 300,
                                  decoration: PixelDecorations.pixelCard(),
                                  padding: EdgeInsets.all(AppConstants.spacingL),
                                  child: BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: [totalIncome, totalExpense]
                                              .reduce((a, b) => a > b ? a : b) *
                                          1.2,
                                      barGroups: [
                                        BarChartGroupData(
                                          x: 0,
                                          barRods: [
                                            BarChartRodData(
                                              toY: totalIncome,
                                              color: AppColors.income,
                                              width: 40,
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                color: AppColors.black,
                                                width: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 1,
                                          barRods: [
                                            BarChartRodData(
                                              toY: totalExpense,
                                              color: AppColors.expense,
                                              width: 40,
                                              borderRadius: BorderRadius.zero,
                                              borderSide: BorderSide(
                                                color: AppColors.black,
                                                width: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 60,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                Helpers.shortenNumber(value),
                                                style: PixelTextStyles.label,
                                              );
                                            },
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              switch (value.toInt()) {
                                                case 0:
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                      top: AppConstants.spacingS,
                                                    ),
                                                    child: Text(
                                                      'Pemasukan',
                                                      style: PixelTextStyles.label,
                                                    ),
                                                  );
                                                case 1:
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                      top: AppConstants.spacingS,
                                                    ),
                                                    child: Text(
                                                      'Pengeluaran',
                                                      style: PixelTextStyles.label,
                                                    ),
                                                  );
                                                default:
                                                  return const Text('');
                                              }
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
                              ),
                            ],
                          ),
                        ),
                      ] else
                        Padding(
                          padding: EdgeInsets.all(AppConstants.spacingXXL * 2),
                          child: FadeInSlide(
                            delay: 500,
                            child: Container(
                              padding: EdgeInsets.all(AppConstants.spacingXXL),
                              decoration: PixelDecorations.pixelCard(),
                              child: Column(
                                children: [
                                  Text('📊', style: TextStyle(fontSize: 64)),
                                  SizedBox(height: AppConstants.spacingL),
                                  Text(
                                    'Belum Ada Transaksi',
                                    style: PixelTextStyles.h3,
                                  ),
                                  SizedBox(height: AppConstants.spacingS),
                                  Text(
                                    'Belum ada transaksi\ndi periode ini',
                                    style: PixelTextStyles.caption,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: AppConstants.spacingXXL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================
  // HEADER
  // ======================
  Widget _buildPixelHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacingXL),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          BouncyCard(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(AppConstants.spacingS),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.black,
                  width: AppConstants.pixelBorderWidthThin,
                ),
                borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black,
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.primary,
                size: AppConstants.iconSizeM,
              ),
            ),
          ),
          SizedBox(width: AppConstants.spacingM),
          Text('Laporan Periode', style: PixelTextStyles.h2),
        ],
      ),
    );
  }

  // ======================
  // PERIOD BUTTON
  // ======================
  Widget _buildPixelPeriodButton(String label, String type, String emoji) {
    final isSelected = _periodType == type;

    return BouncyCard(
      onTap: () {
        setState(() {
          _periodType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingL),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          border: Border.all(
            color: AppColors.black,
            width: isSelected 
                ? AppConstants.pixelBorderWidth 
                : AppConstants.pixelBorderWidthThin,
          ),
          borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(height: AppConstants.spacingXS),
            Text(
              label,
              textAlign: TextAlign.center,
              style: PixelTextStyles.body.copyWith(
                color: isSelected ? AppColors.white : AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================
  // SUMMARY CARD
  // ======================
  Widget _buildPixelSummaryCard(
    String title,
    double amount,
    String emoji,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacingL),
      decoration: PixelDecorations.pixelCard(),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border.all(
                color: AppColors.black,
                width: AppConstants.pixelBorderWidthThin,
              ),
              borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: TextStyle(fontSize: 28)),
          ),
          SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: PixelTextStyles.label),
                SizedBox(height: AppConstants.spacingXS),
                AnimatedNumber(
                  value: amount,
                  style: PixelTextStyles.h3.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================
  // NAVIGATION FUNCTIONS
  // ======================
  void _previousPeriod() {
    setState(() {
      if (_periodType == 'month') {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
      } else {
        _selectedDate = DateTime(_selectedDate.year - 1);
      }
    });
  }

  void _nextPeriod() {
    setState(() {
      if (_periodType == 'month') {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
      } else {
        _selectedDate = DateTime(_selectedDate.year + 1);
      }
    });
  }

  Future<void> _selectDate() async {
    if (_periodType == 'month') {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: AppColors.white,
                surface: AppColors.white,
                onSurface: AppColors.textDark,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        setState(() {
          _selectedDate = picked;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
              side: BorderSide(
                color: AppColors.black,
                width: AppConstants.pixelBorderWidth,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppConstants.spacingL),
                    child: Text('Pilih Tahun', style: PixelTextStyles.h3),
                  ),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: YearPicker(
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      selectedDate: _selectedDate,
                      onChanged: (DateTime dateTime) {
                        setState(() {
                          _selectedDate = dateTime;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}