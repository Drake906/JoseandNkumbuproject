import 'package:expenses/data/hive_database.dart';
import 'package:expenses/datetime/date_time_helper.dart';
import 'package:expenses/models/expense_item.dart';
import 'package:flutter/cupertino.dart';

class ExpenseData extends ChangeNotifier{
  //list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  // prepare data to display
  final db = HiveDataBase();
  void prepareData() {
    //if there exists data, get it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();

    }
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  //get weekday(mon, tues, etc) from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get the date for the start of the week(Sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get todays date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  /*
  convert overall list of expenses into a daily expense summary
  e.g overallExpenseList =
  [
  [food, 2023/04/01, $2],
  [hat, 2023/09/13, $4],
  [drinks,2023/07/14, $10],
  [food, 2023/05/08, $20],
  [food, 2023/09/10, $14],
  [food, 2023/09/12, $12],
  [food, 2023/09/14, $14],
  [food, 2023/09/16, $17],

  ]







  ->

  DailyExpenseSummary =

  [

  [2023/09/16, $10],
  [2023/09/16, $20],
  [2023/09/16, $14],
  [2023/09/16, $12],
  [2023/09/16, $14],
  ]






   */

  Map<String, double> calculateDailyExpensesummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.date);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }
      else{
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}