import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/transaction_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/animations/fade_in_slide.dart';
import '../../widgets/animations/bouncy_card.dart';
import '../../widgets/animations/animated_number.dart';

class CategoryReportScreen extends StatefulWidget {
  const CategoryReportScreen({Key? key}) : super(key: key);

  @override
  State<CategoryReportScreen> createState() => _CategoryReportScreenState();
}

class _CategoryReportScreenState extends State<CategoryReportScreen> {
  String _reportType = 'expense'; // expense or income

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    
    // Get spending/income by category
    final categoryData = _reportType == 'expense'
        ? transactionProvider.getSpendingByCategory()
        : transactionProvider.getIncomeByCategory();

    // Calculate total
    final total = categoryData.values.fold<double>(0, (sum, amount) => sum + amount);

    // Sort by amount (descending)
    final sortedEntries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      body: PixelBackgroundApp(
        child: SafeArea(
          child: Column(
            children: [
              // PIXEL HEADER
              _buildPixelHeader(context),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: AppConstants.spacingL),
                      
                      // TYPE SELECTOR
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                        child: FadeInSlide(
                          delay: 0,
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildPixelTypeButton('Pengeluaran', 'expense', '⬆️'),
                              ),
                              SizedBox(width: AppConstants.spacingM),
                              Expanded(
                                child: _buildPixelTypeButton('Pemasukan', 'income', '⬇️'),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppConstants.spacingXL),

                      // TOTAL CARD
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                        child: FadeInSlide(
                          delay: 100,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppConstants.spacingXL),
                            decoration: PixelDecorations.pixelCard(
                              bgColor: _reportType == 'expense' 
                                  ? AppColors.expenseBg
                                  : AppColors.incomeBg,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _reportType == 'expense' ? '⬆️' : '⬇️',
                                  style: TextStyle(fontSize: 40),
                                ),
                                SizedBox(height: AppConstants.spacingS),
                                Text(
                                  _reportType == 'expense' 
                                      ? 'Total Pengeluaran'
                                      : 'Total Pemasukan',
                                  style: PixelTextStyles.caption,
                                ),
                                SizedBox(height: AppConstants.spacingS),
                                AnimatedNumber(
                                  value: total,
                                  style: PixelTextStyles.h2.copyWith(
                                    color: _reportType == 'expense' 
                                        ? AppColors.expense
                                        : AppColors.income,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppConstants.spacingXXL),

                      // PIE CHART
                      if (categoryData.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                          child: FadeInSlide(
                            delay: 200,
                            child: SizedBox(
                              height: 280,
                              child: Container(
                                decoration: PixelDecorations.pixelCard(),
                                padding: EdgeInsets.all(AppConstants.spacingL),
                                child: PieChart(
                                  PieChartData(
                                    sections: _buildPieChartSections(sortedEntries, total),
                                    sectionsSpace: 3,
                                    centerSpaceRadius: 60,
                                    borderData: FlBorderData(show: false),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppConstants.spacingXXL),
                      ],

                      // CATEGORY LIST
                      if (categoryData.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(AppConstants.spacingXXL * 2),
                          child: FadeInSlide(
                            delay: 200,
                            child: Container(
                              padding: EdgeInsets.all(AppConstants.spacingXXL),
                              decoration: PixelDecorations.pixelCard(),
                              child: Column(
                                children: [
                                  Text('📊', style: TextStyle(fontSize: 64)),
                                  SizedBox(height: AppConstants.spacingL),
                                  Text(
                                    'Belum Ada Data',
                                    style: PixelTextStyles.h3,
                                  ),
                                  SizedBox(height: AppConstants.spacingS),
                                  Text(
                                    'Mulai tambah transaksi untuk\nmelihat laporan kategori',
                                    style: PixelTextStyles.caption,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeInSlide(
                                delay: 300,
                                child: Text(
                                  'Detail per Kategori',
                                  style: PixelTextStyles.h3,
                                ),
                              ),
                              SizedBox(height: AppConstants.spacingL),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sortedEntries.length,
                                itemBuilder: (context, index) {
                                  final entry = sortedEntries[index];
                                  final percentage = (entry.value / total) * 100;
                                  final color = _getCategoryColor(index);

                                  return FadeInSlide(
                                    delay: 400 + (index * 50),
                                    child: _buildPixelCategoryCard(
                                      entry.key,
                                      entry.value,
                                      percentage,
                                      color,
                                    ),
                                  );
                                },
                              ),
                            ],
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
  // PIXEL HEADER
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
          Text('Laporan Kategori', style: PixelTextStyles.h2),
        ],
      ),
    );
  }

  // ======================
  // PIXEL TYPE BUTTON
  // ======================
  Widget _buildPixelTypeButton(String label, String type, String emoji) {
    final isSelected = _reportType == type;
    final color = type == 'income' ? AppColors.income : AppColors.expense;

    return BouncyCard(
      onTap: () {
        setState(() {
          _reportType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppConstants.spacingL),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.white,
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
  // PIE CHART SECTIONS
  // ======================
  List<PieChartSectionData> _buildPieChartSections(
    List<MapEntry<String, double>> entries,
    double total,
  ) {
    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final percentage = (data.value / total) * 100;
      final color = _getCategoryColor(index);

      return PieChartSectionData(
        value: data.value,
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

  // ======================
  // PIXEL CATEGORY CARD
  // ======================
  Widget _buildPixelCategoryCard(
    String category,
    double amount,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Container(
        padding: EdgeInsets.all(AppConstants.spacingL),
        decoration: PixelDecorations.pixelCard(),
        child: Row(
          children: [
            // EMOJI ICON
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                border: Border.all(
                  color: AppColors.black,
                  width: AppConstants.pixelBorderWidthThin,
                ),
                borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
              ),
              alignment: Alignment.center,
              child: Text(
                TransactionCategories.categoryIcons[category] ?? '📦',
                style: TextStyle(fontSize: 28),
              ),
            ),
            SizedBox(width: AppConstants.spacingM),
            
            // CATEGORY INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: PixelTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.fontSizeL,
                    ),
                  ),
                  SizedBox(height: AppConstants.spacingXS),
                  Text(
                    '${percentage.toStringAsFixed(1)}% dari total',
                    style: PixelTextStyles.label,
                  ),
                ],
              ),
            ),
            
            // AMOUNT
            Text(
              Helpers.formatCurrency(amount),
              style: PixelTextStyles.body.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: AppConstants.fontSizeL,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================
  // CATEGORY COLOR
  // ======================
  Color _getCategoryColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
      AppColors.danger,
      const Color(0xFF00BCD4),
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
    ];
    return colors[index % colors.length];
  }
}