import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/models/NoteDetails.dart';
import 'package:money_management_app/services/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({this.noteDetails});
  final NoteDetails noteDetails;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: getTransactionDetails(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading');
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data.documents[index];

                    NoteDetails note = NoteDetails.fromSnapshot(document);
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Row(children: <Widget>[
                                      Text(
                                        note.name == null ? 'null' : note.name,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[800]),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Rs.${(note.budget == null) ? "n/a" : note.budget.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 17.0),
                                      )
                                    ]),
                                  ),
                                  Row(children: <Widget>[
                                    Text(note.date==null?'':
                                      DateFormat.yMMMd()
                                          .format(note.date)
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.pink[300]),
                                    ),
                                    Spacer(),
                                    FlatButton(
                                      child: Text(
                                        'view more',
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blueGrey),
                                      ),
                                      onPressed: () {
                                        tripEditModalBottomSheet(note);
                                      },
                                    )
                                  ]),
                                ],
                              )),
                        ));
                  });
            }));
  }

  void tripEditModalBottomSheet(NoteDetails note) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.60,
              child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Text('Transaction Details',
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.orange)),
                      Spacer(),
                      IconButton(
                          icon: Icon(Icons.cancel,
                              color: Colors.orange, size: 25.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ]),
                    SizedBox(height: 10.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Rs.${(note.budget == null) ? "n/a" : note.budget.toStringAsFixed(2)}",
                            style:
                                TextStyle(color: Colors.green, fontSize: 20.0),
                          )
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          note.transactionType == null
                              ? ''
                              : note.transactionType,
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[900]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          note.name == null ? '' : note.name,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          note.paymentType == null ? '' : note.paymentType,
                          style:
                              TextStyle(fontSize: 15, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(children: <Widget>[
                      Spacer(),
                      Text(
                        'Date Of Transaction',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Spacer(),
                      Text(
                        '${note.date==null?'':DateFormat.yMMMd().format(note.date).toString()}',
                        style:
                            TextStyle(fontSize: 15.0, color: Colors.pink[300]),
                      ),
                      Spacer()
                    ]),
                    SizedBox(height: 10.0),
                    notesCard(note),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('delete'),
                            color: Colors.orange,
                            textColor: Colors.white,
                            onPressed: () async {
                              var uid = await Provider.of(context).getUserId();
                              Firestore.instance
                                  .collection('userData')
                                  .document(uid)
                                  .collection('NoteDetails')
                                  .document(note.documentId)
                                  .delete();
                              Navigator.of(context).pop();
                            },
                          )
                        ])
                  ])));
        });
  }


  Widget notesCard(NoteDetails noteDetails) {
    return Card(
      color: Colors.blue[300],
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
            child: Row(
              children: <Widget>[
                Text("Description",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(noteDetails.description == null ? '' : noteDetails.description)
              ],
            ),
          )
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getTransactionDetails(BuildContext context) async* {
    final uid = await Provider.of(context).getUserId();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('NoteDetails')
        .snapshots();
  }
}
