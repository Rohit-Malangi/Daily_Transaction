import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/TxProvider.dart';
import '../widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titlecontroller = TextEditingController();
  final pricecontroller = TextEditingController();
  DateTime _selectedDate;

  void submitData() {
    if (pricecontroller.text.isEmpty) return;
    final entertitle = titlecontroller.text;
    final enterprice = double.parse(pricecontroller.text);
    if (entertitle.isEmpty || enterprice <= 0 || _selectedDate == null) return;
    Provider.of<TxProvider>(context, listen: false).addTransaction(
      entertitle,
      enterprice,
      _selectedDate.add(
        Duration(
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  void _datePeaker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: titlecontroller,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Price"),
                controller: pricecontroller,
                keyboardType: TextInputType.number,
              ),
              Container(
                width: double.infinity,
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No date chosen !'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveFlatButton(handler: _datePeaker),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => submitData(),
                child: Text(
                  "Add Transaction",
                  style: TextStyle(color: Colors.deepPurple.shade400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
