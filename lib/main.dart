import 'dart:io';

import 'package:expense_manager/widget/chart.dart';
import 'package:expense_manager/widget/new_transaction.dart';
import 'package:expense_manager/widget/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpenseManager',
      theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.amber,
          fontFamily: 'QuickSand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(fontFamily: 'OpenSans', fontSize: 20)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> user_transactions = [
    /*  Transaction(
      id: 't1',
      title: 'new shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'grocery',
      amount: 15.99,
      date: DateTime.now(),
    ),*/
  ];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
  }
@override
void didChangedAppLifecyclestate(AppLifecycleState state){
    print(state);

}
@override
dispose(){
WidgetsBinding.instance.removeObserver(this);
  super.dispose();
}

  List<Transaction> get _recentTransactions {
    return user_transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);
    setState(() {
      user_transactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      user_transactions.removeWhere((tx) => tx.id == id);
    });
  }
  /*Widget _buildAppbar(){
      return AppBar(
        title: Text('ExpenseHelloManager'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          )
        ],
      );
  }
  Widget _buildCupertinoAppbar(){
    CupertinoNavigationBar(
        middle: Text('ExpenseManger'),
    trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    GestureDetector(
    child: Icon(CupertinoIcons.add),
    onTap: () => _startAddNewTransaction(context),
    )
    ],
    ),
    );
  }*/
 List< Widget> _buildLandscapeContent(AppBar appBar,Widget txListWidget){
   return [Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       Text('Show Chart',style: Theme.of(context).textTheme.title, ),
       Switch.adaptive(
           value: _showChart,
           onChanged: (val) {
             setState(() {
               _showChart = val;
             });
           })
     ],
   ),_showChart
       ? Container(
       height: (MediaQuery.of(context).size.height -
           appBar.preferredSize.height -
           MediaQuery.of(context).padding.top) *
           0.7,
       child: Chart(_recentTransactions))
       : txListWidget];
  }
  List<Widget> _buildPortraitContent(AppBar appBar,Widget txListWidget){
   return [Container(
        height: (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top) *
            0.3,
        child: Chart(_recentTransactions),
    ), txListWidget];
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar =
    Platform.isIOS
        ? //_buildCupertinoAppbar() :_buildAppbar();
   CupertinoNavigationBar(
            middle: Text('ExpenseManger'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
    )
       :  AppBar(
            title: Text('ExpenseManager'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(user_transactions, _deleteTransaction));
    final PageBody = SafeArea(child: SingleChildScrollView(
      child: Column(
        //mainAxisAlignment:MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape) ..._buildLandscapeContent(appBar,txListWidget,),

          if (!isLandscape) ..._buildPortraitContent(appBar,txListWidget,),




        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: PageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: PageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
