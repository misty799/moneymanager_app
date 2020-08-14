import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/HomeScreen/Home.dart';
import 'package:money_management_app/models/NoteDetails.dart';
import 'package:money_management_app/services/provider.dart';

class TransactionDetails extends StatefulWidget {
  TransactionDetails({this.noteDetails});
  final NoteDetails noteDetails;
  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  TextEditingController _budgetController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Budget'),
          backgroundColor: Colors.lightBlue[900],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: _budgetController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Enter the Amount ',
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  autofocus: true,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                height: 5 * 24.0,
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: _noteController,
                  maxLines: 6,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      contentPadding: EdgeInsets.all(20.0),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                        color: Theme.of(context).primaryColor,
                      )),
                      prefixIcon: Icon(Icons.add_comment,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Row(
                    children: [
                      Text(
                        '${DateFormat.yMMMd().format(selectedDate)}',
                        style: TextStyle(
                            color: Colors.red[400],
                            fontWeight: FontWeight.w800),
                      ),
                      Spacer(),
                      FlatButton(
                          onPressed: () async {
                            _selectDate(context);
                          },
                          child: Text(
                            'choose date',
                            style:
                                TextStyle(color: Colors.blue, fontSize: 18.0),
                          ))
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: FlatButton(
                      onPressed: () async {
                        setState(() {
                          widget.noteDetails.date = selectedDate;
                          widget.noteDetails.budget =
                              double.parse(_budgetController.text);
                          widget.noteDetails.description = _noteController.text;
                        });

                        final uid = await Provider.of(context).getUserId();
                        await Firestore.instance
                            .collection('userData')
                            .document(uid)
                            .collection('NoteDetails')
                            .add(widget.noteDetails.toJson());
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Text(
                        'continue',
                        style: TextStyle(color: Colors.blue, fontSize: 25.0),
                      )))
            ])));
  }
}
