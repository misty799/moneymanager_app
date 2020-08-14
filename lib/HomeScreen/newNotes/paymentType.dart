import 'package:flutter/material.dart';
import 'package:money_management_app/HomeScreen/newNotes/transactionDetails.dart';
import 'package:money_management_app/models/NoteDetails.dart';

class PaymentView extends StatefulWidget {
  PaymentView({this.noteDetails});
  final NoteDetails noteDetails;
  @override
  _State createState() => _State();
}

class _State extends State<PaymentView> {
  TextEditingController _controller = TextEditingController();

  Container myChips(String chipName) {
    return Container(
      child: RaisedButton(
          color: Color(0xffededed),
          child: Text(
            chipName,
            style: TextStyle(
              color: new Color(0xff6200ee),
            ),
          ),
          onPressed: () {
            widget.noteDetails.paymentType = chipName;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransactionDetails(
                          noteDetails: widget.noteDetails,
                        )));
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[900],
          title: Text("Payment Method"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  addDialog(context);
                  //
                }),
          ],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30.0),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'Popular Payment Methods',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600),
                ),
              )),
              SizedBox(height: 10.0),
              methods(),
            ],
          ),
        ));
  }

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Payment Method '),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: ''),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('add'),
                textColor: Colors.blue,
                onPressed: () {
                  widget.noteDetails.paymentType = _controller.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionDetails(
                                noteDetails: widget.noteDetails,
                              )));
                },
              ),
              FlatButton(
                child: Text('cancel'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget methods() {
    return Container(
        padding: EdgeInsets.only(left: 45.0, right: 25.0),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 10.0,
          runSpacing: 5.0,
          children: <Widget>[
            myChips("SBI"),
            myChips("HDFC"),
            myChips("AXIS"),
            myChips("ICIC"),
            myChips("Paytm"),
            myChips("PhonePee"),
            myChips("CBI"),
            myChips("PNB"),
            myChips("GooglePay"),
            myChips("Canara"),
            myChips("Corporation"),
            myChips("YES"),
            myChips("BOI"),
            myChips("KOTAK"),
            myChips("Indian"),
          ],
        ));
  }
}
