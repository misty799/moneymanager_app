import 'package:flutter/material.dart';
import 'package:money_management_app/HomeScreen/newNotes/contactPage.dart';
import 'package:money_management_app/models/NoteDetails.dart';

class TransactionType extends StatefulWidget {
  TransactionType({this.noteDetails});
  final NoteDetails noteDetails;
  @override
  _TransactionTypeState createState() => _TransactionTypeState();
}

class _TransactionTypeState extends State<TransactionType> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[900],
          title: Text('Transanction Type'),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildButton1('Paid to'),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'or',
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              buildButton2('Received from'),
            ])));
  }

  Widget buildButton1(String text) {
    return Container(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      height: 40.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.greenAccent,
        color: Colors.lightBlue[700],
        elevation: 7.0,
        child: GestureDetector(
          onTap: () {
            widget.noteDetails.transactionType = text;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactsPage(
                          noteDetails: widget.noteDetails,
                          title: 'Paid To',
                        )));
          },
          child: Center(
            child: Text(
              'Paid / Credited',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton2(String text) {
    return Container(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      height: 40.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.greenAccent,
        color: Colors.lightBlue[700],
        elevation: 7.0,
        child: GestureDetector(
          onTap: () {
            widget.noteDetails.transactionType = text;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactsPage(
                          noteDetails: widget.noteDetails,
                          title: 'Received from',
                        )));
          },
          child: Center(
            child: Text(
              'Received / Debited',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
