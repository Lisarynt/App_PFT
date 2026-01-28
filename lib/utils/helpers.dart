import 'package:intl/intl.dart';

class Helpers {
  // Format currency (Rupiah)
  static String formatCurrency(double amount, {String symbol = 'Rp'}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format, 'id_ID').format(date);
  }

  // Format date time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime);
  }

  // Get month name
  static String getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  // Get date range for current month
  static Map<String, DateTime> getCurrentMonthRange() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return {
      'start': firstDay,
      'end': lastDay,
    };
  }

  // Get date range for specific month
  static Map<String, DateTime> getMonthRange(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0, 23, 59, 59);
    return {
      'start': firstDay,
      'end': lastDay,
    };
  }

  // Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  // Get greeting based on time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  // Shorten number (1000 -> 1K, 1000000 -> 1M)
  static String shortenNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  // Get color based on transaction type
  static String getTransactionTypeColor(String type) {
    return type == 'income' ? '#00D09E' : '#FF6B6B';
  }

  // Parse string to double safely
  static double parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '').replaceAll('.', '')) ?? 0;
  }
}