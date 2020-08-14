import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_management_app/HomeScreen/Home.dart';
import 'package:money_management_app/HomeScreen/HomeView.dart';
import 'package:money_management_app/HomeScreen/newNotes/contactPage.dart';
import 'package:money_management_app/HomeScreen/newNotes/transactionType.dart';
import 'package:money_management_app/models/NoteDetails.dart';
import 'package:money_management_app/services/authservice.dart';
import 'package:money_management_app/services/provider.dart';
import 'package:money_management_app/signUp/SignIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        auth: Auth(),
        child: MaterialApp(
            title: 'Notekeeper Application',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.blue, backgroundColor: Colors.amber),
            home: HomeController(),
            routes: <String, WidgetBuilder>{
              '/signIn': (BuildContext context) => SignInPage(),
              '/home': (BuildContext context) => HomeF(),
              '/homepage': (BuildContext context) => HomePage(
                    noteDetails:
                        NoteDetails(null, null, null, null, null, null),
                  ),
              '/page': (BuildContext context) => TransactionType(
                    noteDetails:
                        NoteDetails(null, null, null, null, null, null),
                  ),
              '/contactpage': (BuildContext context) => ContactsPage(
                    noteDetails:
                        NoteDetails(null, null, null, null, null, null),
                    title: null,
                  )
            }));
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context);

    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn ? Home() : SignInPage();
          }
          return CircularProgressIndicator();
        });
  }
}
