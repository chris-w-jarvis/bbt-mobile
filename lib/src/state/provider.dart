// provides an instance of the bloc to give to other widgets
import 'package:flutter/material.dart';
import 'bloc.dart';

class Provider extends InheritedWidget {

  // weird syntax, not calling the function
  Provider({Key key, Widget child}) : super(key:key, child:child);

  final bloc = new Bloc();

  // inheriting widgets will call this
  // widget can look up any number of levels in the context tree
  // look up the chain until it finds a widget of type Provider (return access to it)
  static Bloc of(BuildContext context) {
    // as is basically casting the type (so that its see that the bloc property exists on it)
    // .bloc is just the bloc instance in this class
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).bloc;
  }

  bool updateShouldNotify(_) {
    // _ means idc about this arg
    return true;
  }
}