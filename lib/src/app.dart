import 'package:flutter/material.dart';
import 'screens/workout_screen/workout_screen.dart';
import './state/provider.dart';
import './state/bloc.dart';

class App extends StatelessWidget {
  build(context) {
    return Provider(
      child: MaterialApp(
        title: '/barbell-tracker/',
        home: Scaffold(
          // how to give the appBar access to the Scaffold in order to do a snackbar?
          appBar: workoutAppBar(),
          body: Builder(
            builder: (context) {
              return WorkoutScreen();
            },
          )
        ),
      )
    );
  }
}

Widget workoutAppBar() {
  return AppBar(
    title: Text('/workout/'),
    actions: <Widget>[appBarBtn('End Workout', endWorkoutCb)],
  );
}

Widget appBarBtn(String text, Function callback) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    child: RaisedButton(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: Text(text)
      ),
      onPressed: callback
    )
  );
}

void endWorkoutCb() {
  print('pressed end workout button, returning to main menu');
}