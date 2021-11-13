import 'package:flutter/material.dart';
import "package:intl/intl.dart";

import '../models/transaction.dart';
import "./chart_bar.dart";

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (int i = 0; i < recentTransactions.length; i++) {
        var day = recentTransactions[i];
        if (day.date.day == weekDay.day &&
            day.date.month == weekDay.month &&
            day.date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + double.parse(item["amount"].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupedTransactionValues.map((data) {
          return ChartBar(
              data["day"].toString(),
              double.parse(data["amount"].toString()),
              totalSpending == 0.0
                  ? 0.0
                  : (data["amount"] as double) / totalSpending);
        }).toList(),
      ),
    );
  }
}