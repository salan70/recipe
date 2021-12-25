import 'package:flutter/material.dart';
import '';

class MyProvider with ChangeNotifier {
  List<String> _items = ["item1", "item2", "item3"];
  String _selectedItem = "item1";

  List<String> get items => _items;

  String get selected => _selectedItem;

  void setSelectedItem(String s) {
    _selectedItem = s;
    notifyListeners();
  }
}

class MyDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MyProvider(),
        child: Consumer<MyProvider>(
          builder: (_, provider, __) {
            return DropdownButton<String>(
              value: provider._selectedItem,
              onChanged: (String newValue) {
                provider.setSelectedItem(newValue);
              },
              items:
                  provider.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          },
        ));
  }
}
