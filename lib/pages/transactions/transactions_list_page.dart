import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/transaction_provider.dart';
import '../../models/transaction_model.dart';
import '../../utils/constants.dart';
import '../../widgets/transaction_card.dart';
import '../../widgets/animations/fade_in_slide.dart';
import '../../widgets/animations/bouncy_card.dart';
import '../../widgets/animations/pixel_fab.dart';
import 'add_transaction_page.dart';
import 'edit_transaction_page.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  String _filterType = 'all'; // all, income, expense

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    final List<TransactionModel> filteredTransactions =
        _filterType == 'all'
            ? transactionProvider.transactions
            : transactionProvider.transactions
                .where((t) => t.type == _filterType)
                .toList();

    return Scaffold(
      body: PixelBackgroundApp(
        child: SafeArea(
          child: Column(
            children: [
              _buildPixelHeader(context),
              
              SizedBox(height: AppConstants.spacingL),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                child: FadeInSlide(
                  delay: 100,
                  child: Row(
                    children: [
                      _buildPixelFilterChip('Semua', 'all', '📋'),
                      SizedBox(width: AppConstants.spacingS),
                      _buildPixelFilterChip('Pemasukan', 'income', '⬇️'),
                      SizedBox(width: AppConstants.spacingS),
                      _buildPixelFilterChip('Pengeluaran', 'expense', '⬆️'),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: AppConstants.spacingL),
              
              Expanded(
                child: filteredTransactions.isEmpty
                    ? _buildPixelEmptyState()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingXL,
                        ),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return FadeInSlide(
                            delay: index * 50,
                            child: TransactionCard(
                              transaction: transaction,
                              onTap: () {},
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTransactionScreen(
                                      transaction: transaction,
                                    ),
                                  ),
                                );
                              },
                              onDelete: () {
                                _showPixelDeleteDialog(
                                  context,
                                  transaction,
                                  transactionProvider,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
              
              SizedBox(height: 80), 
            ],
          ),
        ),
      ),
      floatingActionButton: PixelFAB(
        backgroundColor: AppColors.expense,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTransactionScreen(),
            ),
          );
        },
      ),
    );
  }

  // ======================
  // HEADER
  // ======================
  Widget _buildPixelHeader(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    
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
          if (canPop) ...[
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
          ],
          Text(
            'Daftar Transaksi',
            style: PixelTextStyles.h2,
          ),
        ],
      ),
    );
  }

  // ======================
  // FILTER CHIP
  // ======================
  Widget _buildPixelFilterChip(String label, String value, String emoji) {
    final isSelected = _filterType == value;
    
    return Expanded(
      child: BouncyCard(
        onTap: () {
          setState(() {
            _filterType = value;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppConstants.spacingM,
            horizontal: AppConstants.spacingS,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            border: Border.all(
              color: AppColors.black,
              width: AppConstants.pixelBorderWidthThin,
            ),
            borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.black,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(width: AppConstants.spacingXS),
              Flexible(
                child: Text(
                  label,
                  style: PixelTextStyles.caption.copyWith(
                    color: isSelected ? AppColors.white : AppColors.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: AppConstants.fontSizeXS,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================
  // EMPTY STATE
  // ======================
  Widget _buildPixelEmptyState() {
    return Center(
      child: FadeInSlide(
        delay: 0,
        child: Container(
          margin: EdgeInsets.all(AppConstants.spacingXXL),
          padding: EdgeInsets.all(AppConstants.spacingXXL),
          decoration: PixelDecorations.pixelCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '📭',
                style: TextStyle(fontSize: 64),
              ),
              SizedBox(height: AppConstants.spacingL),
              Text(
                'Belum Ada Transaksi',
                style: PixelTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.spacingS),
              Text(
                'Tekan tombol + untuk\nmenambah transaksi',
                style: PixelTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================
  // DELETE DIALOG
  // ======================
  void _showPixelDeleteDialog(
    BuildContext context,
    TransactionModel transaction,
    TransactionProvider transactionProvider,
  ) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          side: BorderSide(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidth,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingXL),
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
              Text(
                '⚠️',
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(height: AppConstants.spacingL),
              Text(
                'Hapus Transaksi?',
                style: PixelTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.spacingM),
              Text(
                'Transaksi yang dihapus tidak\nbisa dikembalikan lagi',
                style: PixelTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppConstants.spacingXL),
              Row(
                children: [
                  Expanded(
                    child: BouncyCard(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppConstants.spacingM,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(
                            color: AppColors.black,
                            width: AppConstants.pixelBorderWidthThin,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.pixelButtonRadius,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Batal',
                          style: PixelTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: BouncyCard(
                      onTap: () async {
                        Navigator.pop(context);
                        await transactionProvider.deleteTransaction(
                          transaction.id!,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppConstants.spacingM,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          border: Border.all(
                            color: AppColors.black,
                            width: AppConstants.pixelBorderWidthThin,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.pixelButtonRadius,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.3),
                              offset: Offset(3, 3),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Hapus',
                          style: PixelTextStyles.body.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}