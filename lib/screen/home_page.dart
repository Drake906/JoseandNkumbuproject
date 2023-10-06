import 'package:expenses/components/expense_summary.dart';
import 'package:expenses/components/expense_tile.dart';
import 'package:expenses/data/expense_data.dart';
import 'package:expenses/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // text controller
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }
  //add new expenses
  void addNewExpense(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                  hintText: 'Expense name'
              ),
            ),

            Row( children: [
              //dollars
              Expanded(
                child: TextField(
                  controller: newExpenseDollarController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'dollars'
                  ),
                ),
              ),

              //cents
              Expanded(
                child:TextField(
                  controller: newExpenseCentsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'cents'
                  ),
                ),
              ),
            ],

            ),

          ],
        ),
        actions: [
          //save button
          MaterialButton(
              onPressed: save,
              child: Text('save')
          ),

          //cancel button
          MaterialButton(
              onPressed: cancel,
              child: Text('cancel'))
        ],
      ),
    );
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }


  //save
  void save(){
    //only save expense if all fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseDollarController.text.isNotEmpty &&
        newExpenseCentsController.text.isNotEmpty) {
      // put dollars and scents together
      String amount =
          '${newExpenseDollarController.text}.${newExpenseCentsController.text}';

      // create expense item
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        date: DateTime.now(),
      );
      //add the new expense
      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel(){
    Navigator.pop(context);
    clear();
  }

  //clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context){
    return Consumer<ExpenseData>(
      builder: (context, value, child)=>Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),

        ),
        body: ListView(children: [
          //weekly summary
          ExpenseSummary(startOfWeek: value.startOfWeekDate()),

          const SizedBox(height:20 ),
          //expense list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.getAllExpenseList().length,
            itemBuilder: (context, index) => ExpenseTile(
              name: value.getAllExpenseList()[index].name,
              amount: value.getAllExpenseList()[index].amount,
              dateTime: value.getAllExpenseList()[index].date,
              deleteTapped: (p0) => deleteExpense(value.getAllExpenseList()[index]),
            ),
          ),
        ]),
      ),
    );
  }
}