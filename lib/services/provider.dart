import 'package:flutter/material.dart';
import 'package:money_management_app/services/authservice.dart';

class Provider extends InheritedWidget {
  Provider({this.auth, this.child});
  final Auth auth;
  final Widget child;
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static Auth of(BuildContext context) {
    Provider provider = context.dependOnInheritedWidgetOfExactType();
    return provider.auth;
  }
}
