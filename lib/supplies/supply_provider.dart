import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupplyProvider extends ChangeNotifier {
  Map<int, Map<String, dynamic>> _constructionSupplies = {};

  Map<int, Map<String, dynamic>> get constructionSupplies =>
      _constructionSupplies;

  Future<void> fetchSupplies() async {
    final response = await Supabase.instance.client
        .from('supply_stock')
        .select('supply:supply_id(supply_name), price, supply_id');

    print(response);

    _constructionSupplies = {
      for (var item in response)
        item['supply_id']: {
          'supply_name': item['supply']['supply_name'],
          'price': (item['price'] as num).toDouble()
        }
    };
    notifyListeners();
  }
}
