import 'package:hive/hive.dart';

import '../models/expense_item.dart';

class HiveDataBase{
  //reference our box
  final _myBox = Hive.box("expense_database2");

  //write data
  void saveData(List<ExpenseItem>allExpense){
    /*

    Hive can only store string and date, and not custom objects like expenseItem.
    Lets convert ExpenseItem objects into types that can be stored in our db

    allExpense=
    [
    ExpenseItem{ name / amount / date)
    ..

    ]

    ->

    [

    [name, amount, date],

    ]
     */
    List<List<dynamic>> allExpensesFormatted = [];

    for(var expense in allExpense){
      // convert each expenseItem into a list of storable types (string, date, )
      List<dynamic> expenseFormatted =[
        expense.name,
        expense.amount,
        expense.date,
      ];
      allExpensesFormatted.add(expenseFormatted);
    }

    //finally lets store in our database!
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }
  //read data
List<ExpenseItem> readData() {
    /*
    Data is stored in Hive as a list of string + date
    so lets convert our saved data into ExpenseItem

    savedData =
    [

    [name, amount, date],
    ..

    ]

    ->

    [

    ExpenseItem( name/ amount/ date),
    ..

    ]

     */

  List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
  List<ExpenseItem> allExpenses = [];

  for (int i =0; i < savedExpenses.length; i++) {
    // collect individual expense data
    String name = savedExpenses [i] [0];
    String amount = savedExpenses [i] [1];
    DateTime date = savedExpenses [i] [2];

    //create ExpenseItem
    ExpenseItem expense =
        ExpenseItem(
            name: name,
            amount: amount,
            date: date,
        );

    //add expense to overall list of expenses
    allExpenses.add(expense);
  }
  return allExpenses;
}
}
