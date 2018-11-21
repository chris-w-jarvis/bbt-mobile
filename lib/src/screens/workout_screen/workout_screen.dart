import 'package:flutter/material.dart';
import './weights_buttons.dart';
import '../../state/bloc.dart';
import '../../state/provider.dart';

class WorkoutScreen extends StatelessWidget {
  build(context) {

    final bloc = Provider.of(context);

    var screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        liftAndRepsRow(bloc),
        weightAnimation(screenWidth, context, bloc),
        weightButtonsRow(screenWidth, bloc),
        //notesRow(bloc),
        addSetButton(bloc)
      ],
    );
  }
}

Widget liftAndRepsRow(Bloc bloc) {

  var initialLifts = <String>[
    'Squat',
    'Deadlift',
    'Bench',
    'OHP',
    'Pull-up'
  ];

  return Container(
    child: Row(
      children: <Widget>[
        // give liftDropdown initial state
        // make it go in the middle
        Expanded(child: Center(child: liftDropdown(initialLifts, bloc))),
        Expanded(child: Center(child: repsMenu(bloc)))
      ],
    ),
  );
}

Widget liftDropdown(List<String> lifts, Bloc bloc) {

  var liftsList = List<DropdownMenuItem<String>>();
  lifts.forEach(
    (lift) => liftsList.add(
        new DropdownMenuItem<String>(
        value: lift,
        child: Text(lift)
     )
    )
  );

  // add this issue on github?
  // var liftsList = lifts.map(
  //   (lift) => new DropdownMenuItem<String>(
  //     value: lift,
  //     child: Text(lift)
  //   )
  // );
  return StreamBuilder(
    stream: bloc.liftName,
    builder: (context, snapshot) {
      return DropdownButton<String>(
        value: snapshot.hasData ? snapshot.data : lifts[0],
        items: liftsList,
        onChanged: (String newVal) {
          print('change state to be lift:$newVal');
          bloc.changeLiftName(newVal);
        },
      );
    }
  );
}

Widget repsMenu(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.reps,
    builder: (context, snapshot) {
      return Container(
        child: TextField(
          keyboardType: TextInputType.numberWithOptions(),
          decoration: InputDecoration(
            hintText: 'reps',
            errorText: snapshot.error
          ),
          onChanged: bloc.changeReps
        ),
      );
    }
  );
}

Widget weightAnimation(double screenWidth, BuildContext context, Bloc bloc) {
  // return GestureDetector(
  //   onTap: () {
  //     final snackBar = SnackBar(content: Text("PULL OFF A WEIGHT"));
  //     Scaffold.of(context).showSnackBar(snackBar);
  //     int currWeight = int.parse(bloc.weight.value);
  //   },
  //   child: Container(
  //     padding: EdgeInsets.all(16.0),
  //     child: Image.network('https://media.istockphoto.com/photos/concrete-wall-picture-id177414827?k=6&m=177414827&s=612x612&w=0&h=R_05Wjq5TRbhs1xnDvF_lOG14RzzLoO0A5EH1nl_oNk=',
  //       width: screenWidth,
  //       height: 250.0,
  //     ),
  //   )
  // );

  // Rerender on all events from bloc.weightChanged

  return StreamBuilder(
    stream: bloc.weightChanged,
    builder: (context, snapshot) {
      // return RaisedButton(
      //   child: !snapshot.hasData ? Text('45') : Text(bloc.weightOnBarbell.toString()),
      //   //child: Text("not implemented"),
      //   onPressed: () => bloc.removeWeight(-1.0),
      // );
      return Center(child: barbellAnimationFrame(bloc.weightOnBarbell, screenWidth));
    },
  );
}

Widget barbellAnimationFrame(int weight, double screenWidth) {
  final plates = determinePlates(weight-45);
  print(plates);

  /*
    How to render this?
      basic: on render for each plate render a 90 degree rotated rectangle on each side
      based on value of plate
        Stack with a box background (to define the viewport) that contains barbell image
        each plate is added with a width and height in proportion to screen width
      advanced: animate each plate coming on and off (no plans for this at this time)
  */
  return Stack(
    children: [
      buildBarbellBackgroud(screenWidth),

    ],
  );
}

Widget buildBarbellBackgroud(double screenWidth) {
  
}
  
determinePlates(int w) {
  var plates = {};
  if (w % 5 != 0) throw Exception('weight not divisible by 45');
  if (w ~/ 90 > 0) {
    plates['45'] = w ~/ 90;
    w = w % 90;
  }
  if (w ~/ 50 > 0) {
    plates['25'] = w ~/ 50;
    w = w % 50;
  }
  if (w ~/ 20 > 0) {
    plates['10'] = w ~/ 20;
    w = w % 20;
  }
  if (w ~/ 10 > 0) {
    plates['5'] = w ~/ 10;
    w = w % 10;
  }
  if (w ~/ 5 > 0) {
    plates['2.5'] = w ~/ 5;
    w = w % 5;
  }
  return plates;
}



Widget weightButtonsRow(double screenWidth, Bloc bloc) {
  
  Weights weights = new Weights(screenWidth, bloc);
  var weightButtons = weights.getWeights;

  return Container(
    padding: EdgeInsets.all(16.0),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[weightButtons['fortyfive']],),
          ),
        ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[weightButtons['twentyfive'], weightButtons['twoandhalf']],),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[weightButtons['ten'], weightButtons['five']],)
          ),
      ],
    ),
  );
}

Widget notesRow(Bloc bloc) {
  return TextField(
    decoration: InputDecoration(
      hintText: 'Notes, eg a modifier like "front" or "hack"'
    ),
    onChanged: (val) {print('notes row: $val');},
  );
}

Widget addSetButton(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.submitValid,
    builder: (context, snapshot) {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text('Add Set'),
          onPressed: !snapshot.hasData ? null : bloc.addSet,
        ),
      );
    },
  );
}