import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class CurrencyService {
  
  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    try {
      final url = '${AppConstants.currencyApiUrl}${AppConstants.currencyApiKey}/latest/$baseCurrency';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['result'] == 'success') {
          return {
            'base': data['base_code'],
            'date': data['time_last_update_utc'],
            'rates': data['conversion_rates'],
          };
        } else {
          throw Exception('API Error: ${data['error-type']}');
        }
      } else {
        throw Exception('Failed to load exchange rates. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: ${e.toString()}');
    }
  }

  Future<double> convertCurrency(
    double amount,
    String from,
    String to,
  ) async {
    try {
      final data = await getExchangeRates(from);
      final rates = data['rates'] as Map<String, dynamic>;
      
      if (!rates.containsKey(to)) {
        throw Exception('Currency $to not found');
      }
      
      final rate = rates[to];
      return amount * rate;
    } catch (e) {
      throw Exception('Conversion failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> convertWithDetails(
    double amount,
    String from,
    String to,
  ) async {
    try {
      final data = await getExchangeRates(from);
      final rates = data['rates'] as Map<String, dynamic>;
      
      if (!rates.containsKey(to)) {
        throw Exception('Currency $to not found');
      }
      
      final rate = rates[to] as double;
      final convertedAmount = amount * rate;
      
      return {
        'amount': amount,
        'from': from,
        'to': to,
        'rate': rate,
        'result': convertedAmount,
        'date': data['date'],
      };
    } catch (e) {
      throw Exception('Conversion failed: ${e.toString()}');
    }
  }

  Future<List<String>> getSupportedCurrencies() async {
    try {
      final data = await getExchangeRates('USD');
      final rates = data['rates'] as Map<String, dynamic>;
      return rates.keys.toList()..sort();
    } catch (e) {
      throw Exception('Failed to get supported currencies: ${e.toString()}');
    }
  }
}