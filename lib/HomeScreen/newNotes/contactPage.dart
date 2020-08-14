import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/HomeScreen/newNotes/paymentType.dart';
import 'package:money_management_app/models/NoteDetails.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({this.noteDetails, this.title});
  final String title;
  final NoteDetails noteDetails;
  @override
  _ContactsPageState createState() => _ContactsPageState(this.title);
}

class _ContactsPageState extends State<ContactsPage> {
  _ContactsPageState(this.title);
  String title;
  List<Contact> contacts = [];
  List<Contact> filteredContact = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController _controller = TextEditingController();
  void initState() {
    super.initState();
    getAllContacts();
    searchController.addListener(() {
      filterContacts();
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();

        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }
        var phone = contact.phones.firstWhere((element) {
          return element.value.contains(searchTerm);
        }, orElse: () => null);
        return phone != null;
      });
      setState(() {
        filteredContact = _contacts;
      });
    }
  }

  getAllContacts() async {
    Iterable<Contact> _contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.lightBlue[900],
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addDialog(context);
              },
            )
          ],
        ),
        body: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  labelText: 'Search',
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                          color: Theme.of(context).primaryColor)),
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).primaryColor)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: isSearching == true
                  ? filteredContact.length
                  : contacts.length,
              itemBuilder: (context, index) {
                Contact contact = isSearching == true
                    ? filteredContact[index]
                    : contacts[index];
                String number = "";
                contact.phones.forEach((element) {
                  number = element.value;
                });

                return GestureDetector(
                  child: Card(
                    child: ListTile(
                        title: Text(contact.displayName),
                        subtitle: Text(number),
                        leading: (contact.avatar != null &&
                                contact.avatar.length > 0)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar),
                              )
                            : CircleAvatar(
                                child: Text(contact.initials(),
                                    style: TextStyle(color: Colors.white)),
                              )),
                  ),
                  onTap: () async {
                    widget.noteDetails.name = contact.displayName;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PaymentView(noteDetails: widget.noteDetails)));
                  },
                );
              },
            ),
          )
        ]));
  }

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Person Name '),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: ''),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('add'),
                textColor: Colors.blue,
                onPressed: () {
                  widget.noteDetails.name = _controller.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentView(
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
}
