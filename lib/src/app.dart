import 'package:flutter/material.dart';
import 'screens/workout_screen/workout_screen.dart';
import './state/provider.dart';

class App extends StatelessWidget {
  build(context) {
    return Provider(
      child: MaterialApp(
        title: '/barbell-tracker/',
        home: Scaffold(
          // how to give the appBar access to the Scaffold in order to do a snackbar?
          appBar: workoutAppBar(context),
          body: Builder(
            builder: (context) {
              return WorkoutScreen();
            },
          ),
          backgroundColor: Color.fromRGBO(214, 218, 240, 1.0),
        ),
        theme: ThemeData(
          // Define the default Brightness and Colors
          primaryColor: Color.fromRGBO(214, 218, 240, 1.0),
          accentColor: Color.fromRGBO(214, 218, 240, 1.0),

        )
      )
    );
  }
}

Widget workoutAppBar(BuildContext context) {
  return AppBar(
    title: Text('/workout/', style: TextStyle(color: Colors.red),),
    actions: <Widget>[appBarBtn('>>endworkout', context)],
  );
}

Widget appBarBtn(String text, BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    child: RaisedButton(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        child: Text(text, style: TextStyle(color: Colors.red),)
      ),
      onPressed: () {Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondScreen()),
  );}
    )
  );
}

class SecondScreen extends StatelessWidget {
  build(context) {return Scaffold(backgroundColor: Colors.red,
  body: Builder(
    builder: (context) {
      return Container(color: Colors.blue, height: 200, width: 200);
    }
  )
  );}
}