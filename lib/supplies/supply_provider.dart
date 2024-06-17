import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupplyProvider extends ChangeNotifier {
  Map<String, double> _constructionSupplies = {};

  Map<String, double> get constructionSupplies => _constructionSupplies;

  Future<void> fetchSupplies() async {
    final response = await Supabase.instance.client
        .from('supply_stock')
        .select('supply:supply_id(supply_name), price');

    _constructionSupplies = {
      for (var item in response)
        item['supply']['supply_name']: (item['price'] as num).toDouble()
    };
    notifyListeners();
  }
}
