import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './module/transaction.dart';

void main() {
  /* WidgetsFlutterBinding.ensureInitialized();
     SystemChrome.setPreferredOrientations([
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown,
    ]); */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Daily Transaction",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactionList = [];
  List<Transaction> get _recentTransactionList {
    int size = 7;
    if (_transactionList.length < 7) size = _transactionList.length;
    return List.generate(size, (index) {
      return _transactionList[index];
    });
  }

  void _addTransaction(String title, double price, DateTime chosenDate) {
    final newTx = Transaction(
      name: title,
      price: price,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _transactionList.insert(0, newTx);
      //_transactionList.add(newTx);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionList.removeWhere((element) => element.id == id);
    });
  }

  bool _showChart = false;

  Widget _fun1(
      MediaQueryData mediaQuery, AppBar appBar, Container txListWeight) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Show Chart",
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
          _showChart
              ? Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.7,
                  child: Chart(_recentTransactionList, 0.15),
                )
              : txListWeight,
        ],
      ),
    );
  }

  Widget _fun2(
      MediaQueryData mediaQuery, AppBar appBar, Container txListWeight) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactionList, 0.12),
        ),
        txListWeight,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              "Daily Transaction",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startNewTransaction(context),
                ),
              ],
            ))
        : AppBar(
            title: const Text(
              "Daily Transaction",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startNewTransaction(context),
              )
            ],
          );
    final txListWeight = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_transactionList, _deleteTransaction),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: isLandscape
            ? _fun1(mediaQuery, appBar, txListWeight)
            : _fun2(mediaQuery, appBar, txListWeight),
        /*Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isLandscape) _fun1(mediaQuery, appBar, txListWeight),
            /* if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.8,
                      child: Chart(_recentTransactionList),
                    )
                  : txListWeight,  */
            if (!isLandscape) _fun2(mediaQuery, appBar, txListWeight),
          ],
        ), */
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startNewTransaction(context),
                  ),
          );
  }
}
