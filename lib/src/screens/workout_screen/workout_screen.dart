import 'package:flutter/material.dart';
import './weights_buttons.dart';
import '../../state/bloc.dart';
import '../../state/provider.dart';

class WorkoutScreen extends StatelessWidget {
  build(context) {

    final bloc = Provider.of(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeigth = MediaQuery.of(context).size.height;
    return ListView(
      children: <Widget>[
        weightAnimation(screenWidth, screenHeigth, context, bloc),
        liftAndRepsRow(bloc),
        repsPresets(bloc, screenWidth),
        Container(color: Color.fromRGBO(238, 242, 255, 1.0), width: screenWidth, height: 2),
        weightButtonsRow(screenWidth, screenHeigth, bloc),
        notesRow(bloc),
        addSetButton(bloc)
      ],
    );
  }
}

Widget repsPresets(Bloc bloc, double screenWidth) {
  return Row(
    mainAxisAlignment:MainAxisAlignment.end,
    children: <Widget>[
      repPreset(bloc, '1', screenWidth),
      repPreset(bloc, '3', screenWidth),
      repPreset(bloc, '5', screenWidth),
      repPreset(bloc, '8', screenWidth),
      repPreset(bloc, '12', screenWidth)
    ],
  );
}

Widget repPreset(Bloc bloc, String reps, double screenWidth) {
  return Container(
    padding: EdgeInsets.all(8.0),
    margin: EdgeInsets.only(left: screenWidth/40, right: screenWidth/40),
    decoration: BoxDecoration(
      color: Color.fromRGBO(214, 218, 240, 1.0)
    ),
    child: StreamBuilder(
      stream: bloc.reps,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () => bloc.changeReps(reps),
          child: Text(reps),
        );
      },
    ),
  );
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
    decoration: BoxDecoration(
      color: Color.fromRGBO(238, 242, 255, 1.0)
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
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 242, 255, 1.0)
        ),
        child: TextField(
          keyboardType: TextInputType.numberWithOptions(),
          decoration: InputDecoration(
            hintText: 'reps',
            errorText: snapshot.error
          ),
          onChanged: bloc.changeReps,
          controller: TextEditingController(text: snapshot.hasData ? snapshot.data : ''),
        ),
      );
    }
  );
}

Widget weightAnimation(double screenWidth, double screenHeight, BuildContext context, Bloc bloc) {
  // Rerender on all events from bloc.weightChanged
  return StreamBuilder(
    stream: bloc.weightChanged,
    builder: (context, snapshot) {
      return GestureDetector(
        onTap: () => bloc.removeWeight(-1),
        onLongPress: () => bloc.emptyBarbell(true),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(214, 218, 240, 1.0)
          ),
          padding: EdgeInsets.all(16.0),
          // -32 is to center it against the padding
          child: barbellAnimationFrame(bloc.weightOnBarbell, bloc.getPlates, screenWidth-32, screenHeight-32)
        )
      );
    },
  );
}

Widget barbellAnimationFrame(int weight, Map plates, double screenWidth, double screenHeight) {

  // if (weight > 500) return Image.asset('assets/lightweight.png', height: screenHeight*.25, width: screenWidth,);
  if (weight > 500) {
    return Stack(
      overflow: Overflow.clip,
      children: <Widget>[
        Image.asset('assets/lightweight.png', height: screenHeight*.25, width: screenWidth,),
        Positioned(
          child: Text('$weight'),
          top: 0,
          left: 0,
        )
      ]
    );
  }

  List<Widget> stackChildren = <Widget>[
    Positioned(
      child: Text('$weight'),
      top: 10,
      left: screenWidth*.5,
    ),
    Image.asset('assets/45.jpg', height: screenHeight*.25, width: screenWidth,)
  ];
  
  List<Widget> renderedPlates = renderPlates(plates, screenWidth, screenHeight);
  for (Widget w in renderedPlates) {
    stackChildren.add(w);
  }

  return Stack(
    overflow: Overflow.clip,
    children: stackChildren
  );
}

List<Widget> renderPlates(Map plates, double screenWidth, double screenHeight) {
  var firstPlateInnerDist = screenWidth * .225;
  List<Widget> res = <Widget>[];
  if (plates['45'] != null) {
    for (int i = 0; i < plates['45']; i++) {
      res.add(Positioned(
        child: Container(height: screenHeight*.225, width: screenWidth*.05,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.0125,
        left: firstPlateInnerDist-(i * screenWidth*.05),
      ));
      res.add(Positioned(
        child: Container(height: screenHeight*.225, width: screenWidth*.05,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.0125,
        right: firstPlateInnerDist-(i * screenWidth*.05),
      ));
    }
    firstPlateInnerDist-=(plates['45'] * screenWidth*.05);
  }
  if (plates['25'] != null) {
    for (int i = 0; i < plates['25']; i++) {
      res.add(Positioned(
        child: Container(height: screenHeight*.15, width: screenWidth*.05,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.05,
        left: firstPlateInnerDist-(i * screenWidth*.05),
      ));
      res.add(Positioned(
        child: Container(height: screenHeight*.15, width: screenWidth*.05,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.05,
        right: firstPlateInnerDist-(i * screenWidth*.05),
      ));
    }
    firstPlateInnerDist-=(plates['25'] * screenWidth*.05);
  }
  if (plates['10'] != null) {
    if (plates['45'] != null || plates['25'] != null) firstPlateInnerDist+=screenWidth*.01;
    for (int i = 0; i < plates['10']; i++) {
      res.add(Positioned(
        child: Container(height: screenHeight*.12, width: screenWidth*.04,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.065,
        left: firstPlateInnerDist-(i * screenWidth*.04),
      ));
      res.add(Positioned(
        child: Container(height: screenHeight*.12, width: screenWidth*.04,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.065,
        right: firstPlateInnerDist-(i * screenWidth*.04),
      ));
    }
    firstPlateInnerDist-=(plates['10'] * screenWidth*.04);
  }
  if (plates['5'] != null) {
    if (plates['10'] != null) firstPlateInnerDist+=screenWidth*.01;
    else if (plates['45'] != null || plates['25'] != null) firstPlateInnerDist+=screenWidth*.02;
    for (int i = 0; i < plates['5']; i++) {
      res.add(Positioned(
        child: Container(height: screenHeight*.08, width: screenWidth*.03,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.085,
        left: firstPlateInnerDist-(i * screenWidth*.03),
      ));
      res.add(Positioned(
        child: Container(height: screenHeight*.08, width: screenWidth*.03,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.085,
        right: firstPlateInnerDist-(i * screenWidth*.03),
      ));
    }
    firstPlateInnerDist-=(plates['5'] * screenWidth*.04);
  }
  if (plates['2.5'] != null) {
    if (plates['10'] != null || plates['5'] != null) firstPlateInnerDist+=screenWidth*.01;
    else if (plates['45'] != null || plates['25'] != null) firstPlateInnerDist+=screenWidth*.02;
    for (int i = 0; i < plates['2.5']; i++) {
      res.add(Positioned(
        child: Container(height: screenHeight*.04, width: screenWidth*.03,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.105,
        left: firstPlateInnerDist-(i * screenWidth*.03),
      ));
      res.add(Positioned(
        child: Container(height: screenHeight*.04, width: screenWidth*.03,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(width: 1.0, color: Colors.black38),
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          ),
        ),
        top: screenHeight*.105,
        right: firstPlateInnerDist-(i * screenWidth*.03),
      ));
    }
  }
  return res;
}



Widget weightButtonsRow(double screenWidth, double screenHeight, Bloc bloc) {
  
  Weights weights = new Weights(screenWidth, screenHeight, bloc);
  var weightButtons = weights.getWeights;

  return Container(
    decoration: BoxDecoration(
      color: Color.fromRGBO(214, 218, 240, 1.0)
    ),
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
  return Container(
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Notes, eg a modifier like "front" or "hack"'
      ),
      onChanged: (val) {print('notes row: $val');},
    ),
    decoration: BoxDecoration(
      color: Color.fromRGBO(238, 242, 255, 1.0)
    )
  );
}

Widget addSetButton(Bloc bloc) {
  return StreamBuilder(
    stream: bloc.submitValid,
    builder: (context, snapshot) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 242, 255, 1.0)
        ),
        padding: EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text('/Add Set/', style: TextStyle(color: Colors.red)),
          color: Color.fromRGBO(214, 218, 240, 1.0),
          onPressed: !snapshot.hasData ? null : bloc.addSet,
        ),
      );
    },
  );
}