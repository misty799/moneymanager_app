import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/HomeScreen/HomeView.dart';
import 'package:money_management_app/HomeScreen/newNotes/transactionType.dart';
import 'package:money_management_app/models/NoteDetails.dart';
import 'package:money_management_app/services/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'newNotes/contactPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.lightBlue[800],
          title: Text(
            'All Transactions',
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  final PermissionStatus permissionStatus =
                      await _getPermission();
                  if (permissionStatus == PermissionStatus.granted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactsPage(
                                  noteDetails: NoteDetails(
                                      null, null, null, null, null, null),
                                  title: null,
                                )));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text('Permissions error'),
                              content: Text('Please enable contacts access '
                                  'permission in system settings'),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text('OK'),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            ));
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionType(
                              noteDetails: NoteDetails(
                                  null, null, null, null, null, null))));
                })
          ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 120.0,
              width: MediaQuery.of(context).size.width,
              child: UserAccountsDrawerHeader(
                accountName: userNameInfo(),
                accountEmail: userEmailInfo(),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.lightBlue[900],
              ),
              title: Text(
                "LOGOUT",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
              onTap: () {
                Provider.of(context).signOut();
                Navigator.of(context).pushReplacementNamed('/signIn');
              },
            ),
          ],
        ),
      ),
      body: HomePage(
        noteDetails: NoteDetails(null, null, null, null, null, null),
      ),
    ));
  }

  Widget userNameInfo() {
    return FutureBuilder(
        future: Provider.of(context).getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(
              snapshot.data.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget userEmailInfo() {
    return FutureBuilder(
        future: Provider.of(context).getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(
              snapshot.data.email,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }
}
