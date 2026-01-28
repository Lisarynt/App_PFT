import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/animations/bouncy_card.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? AppColors.income : AppColors.expense;
    final bgColor = isIncome ? AppColors.incomeBg : AppColors.expenseBg;
    final emoji = TransactionCategories.categoryIcons[transaction.category] ?? '📦';
    final arrow = isIncome ? '⬇️' : '⬆️';

    return Padding(
      padding: EdgeInsets.only(bottom: AppConstants.spacingM),
      child: BouncyCard(
        onTap: onTap ?? () {},
        child: Container(
          padding: EdgeInsets.all(AppConstants.spacingL),
          decoration: PixelDecorations.pixelCard(),
          child: Row(
            children: [
              // EMOJI ICON WITH PIXEL BORDER
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
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: 28),
                ),
              ),
              
              SizedBox(width: AppConstants.spacingM),
              
              // TRANSACTION INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category,
                      style: PixelTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.fontSizeL,
                      ),
                    ),
                    SizedBox(height: AppConstants.spacingXS),
                    Text(
                      transaction.description,
                      style: PixelTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppConstants.spacingXS),
                    Text(
                      Helpers.formatDate(transaction.date),
                      style: PixelTextStyles.label,
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: AppConstants.spacingS),
              
              // AMOUNT AND ACTIONS
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // AMOUNT WITH ARROW
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(arrow, style: TextStyle(fontSize: 14)),
                      SizedBox(width: AppConstants.spacingXS),
                      Text(
                        Helpers.formatCurrency(transaction.amount),
                        style: PixelTextStyles.body.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: AppConstants.fontSizeM,
                        ),
                      ),
                    ],
                  ),
                  
                  // POPUP MENU
                  if (onEdit != null || onDelete != null) ...[
                    SizedBox(height: AppConstants.spacingXS),
                    _buildPixelPopupMenu(context),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPixelPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          border: Border.all(
            color: AppColors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.more_horiz,
          color: AppColors.textDark,
          size: 16,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
        side: BorderSide(
          color: AppColors.black,
          width: AppConstants.pixelBorderWidthThin,
        ),
      ),
      onSelected: (value) {
        if (value == 'edit' && onEdit != null) {
          onEdit!();
        } else if (value == 'delete' && onDelete != null) {
          onDelete!();
        }
      },
      itemBuilder: (context) => [
        if (onEdit != null)
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 18, color: AppColors.primary),
                SizedBox(width: AppConstants.spacingS),
                Text('Edit', style: PixelTextStyles.body),
              ],
            ),
          ),
        if (onDelete != null)
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 18, color: AppColors.danger),
                SizedBox(width: AppConstants.spacingS),
                Text(
                  'Hapus',
                  style: PixelTextStyles.body.copyWith(color: AppColors.danger),
                ),
              ],
            ),
          ),
      ],
    );
  }
}