import 'package:expenses/bar%20graph/bar_graph.dart';
import 'package:expenses/data/expense_data.dart';
import 'package:expenses/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({
    super.key,
    required this.startOfWeek,
  });

  //calculate max amount in bar graph
  double calculateMax(ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,
      ){
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpensesummary()[sunday] ??0,
      value.calculateDailyExpensesummary()[monday] ??0,
      value.calculateDailyExpensesummary()[tuesday] ??0,
      value.calculateDailyExpensesummary()[wednesday] ??0,
      value.calculateDailyExpensesummary()[thursday] ??0,
      value.calculateDailyExpensesummary()[friday] ??0,
      value.calculateDailyExpensesummary()[saturday] ??0,
    ];

    // sort from smallest to largest
    values.sort();
    //get largest amount (which is at the end of the sorted list)
    //and increase the cap slightly so the graph looks almost full
    max = values.last * 1.1;

    return max == 0 ? 100 : max ;
  }

  // calculate the week total
  String calculateWeekTotal(ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,){

    List<double> values = [
      value.calculateDailyExpensesummary()[sunday] ??0,
      value.calculateDailyExpensesummary()[monday] ??0,
      value.calculateDailyExpensesummary()[tuesday] ??0,
      value.calculateDailyExpensesummary()[wednesday] ??0,
      value.calculateDailyExpensesummary()[thursday] ??0,
      value.calculateDailyExpensesummary()[friday] ??0,
      value.calculateDailyExpensesummary()[saturday] ??0,
    ];
    double total = 0;
    for( int i=0; i<values.length; i++){
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    //get yyyymmdd for each day of the week
    String sunday = convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday = convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday = convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday = convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday = convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday = convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday = convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
          builder: (context, value, child) =>Column(
            children: [

              //week total
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    const Text(
                      'week Total: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

                    Text('\$${calculateWeekTotal(value, sunday, monday, tuesday, wednesday,
                        thursday, friday, saturday)}')
                  ],
                ),
              ),


              //bar graph
              SizedBox(
               height: 200,
               child: MyBarGraph(
                maxY: calculateMax(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday),
                sunAmount: value.calculateDailyExpensesummary()[sunday] ?? 0,
                monAmount: value.calculateDailyExpensesummary()[monday] ?? 0,
                tueAmount: value.calculateDailyExpensesummary()[tuesday] ?? 0,
                wedAmount: value.calculateDailyExpensesummary()[wednesday] ?? 0,
                thurAmount: value.calculateDailyExpensesummary()[thursday] ?? 0,
                friAmount: value.calculateDailyExpensesummary()[friday] ?? 0,
                satAmount: value.calculateDailyExpensesummary()[saturday] ?? 0,
          ),
        ),
            ],
          ),
    );
  }
}
