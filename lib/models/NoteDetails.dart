import 'package:cloud_firestore/cloud_firestore.dart';

class NoteDetails {
  String name;
  DateTime date;
  String paymentType;
  String transactionType;
  double budget;
  String description;
  String documentId;
  NoteDetails(this.name, this.budget, this.date, this.description,
      this.paymentType, this.transactionType);
  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'transactionType': transactionType,
        'paymentType': paymentType,
        'budget': budget,
        'description': description
      };
  NoteDetails.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        date = snapshot['date'].toDate(),
        paymentType = snapshot['paymentType'],
        budget = snapshot['budget'],
        description = snapshot['description'],
        transactionType = snapshot['transactionType'],
        documentId = snapshot.documentID;
}
