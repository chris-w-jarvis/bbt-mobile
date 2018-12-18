import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'transformers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bloc extends Transformers {

  Bloc() {
    /*
      weight buttons send the weight as an int, remove weight sends -1
    */
    this.weightChanged.listen(
      (w) {
        // if given a positive value its from weights stream, increment weight on barbell, if not, its from removeWeightBtn stream, remove last weight if there is one
        if (w > 0) weightOnBarbell+=w;
        else {
          weightOnBarbell -= removeLastPlate();
        }
        // balance plates
        _plates = determinePlates(weightOnBarbell-45);
        print(_plates);
      }
    );

    // long press for weight to remove all weights
    this._emptyBarbellBtn.listen((_) { _plates.clear(); weightOnBarbell = 45;});
  }

  /*
    logic to load lift names from shared prefs:
      the lift drop down works by sticking the value selected into the liftName stream
      idea: add a new stream that will be seeded with initial values, merge this with the liftName
      stream that is used when an item is selected in the dropdown, the lifts widget will listen
      to this stream and know whether the value is being changed or if new lifts have been loaded so
      the dropdown list needs to be remade
  */

  //var _weightsStream = <int>[];
  var _plates = {};
  var weightOnBarbell = 0;

  // listens to weight buttons
  final _weights = BehaviorSubject<int>(seedValue: 45);
  // onTap for weight animator
  final _removeWeightBtn = BehaviorSubject<int>();
  // onLongPress for weight animator
  final _emptyBarbellBtn = BehaviorSubject<bool>();

  final _reps = BehaviorSubject<String>();
  final _liftName = BehaviorSubject<Map<String,String>>(seedValue: {'type':'state_change', 'val':'Squat'});


  // update current set
  Function(bool) get emptyBarbell => _emptyBarbellBtn.sink.add;
  Function(int) get removeWeight => _removeWeightBtn.sink.add;
  Function(int) get addWeight => _weights.sink.add;
  Function(String) get changeReps => _reps.sink.add;
  Function(String) get changeLiftName => _liftName.sink.add;
  Stream<int> get weights => _weights;
  Stream<String> get reps => _reps.stream.transform(validateField);
  Stream<String> get liftName => _liftName.stream.transform(validateField);
  Map get getPlates => _plates;

  // combineLatest vs merge: combineLatest doesn't emit until all involved are emitting,
  // merging just merges them into one observable

  // // validate fields (not really but do like example)
  // // can these all be the same validator?
  // // REMEMBER THESE ARE THE ACTUAL STREAMS, streambuilders are listening for changes from these

  /*
    the weight animator will listen for this stream to rerender on any changed, and the weight
    animator will also add -1 to this stream when it is clicked in order to pop the last weight added
  */
  Stream<int> get weightChanged => MergeStream(<Stream<int>>[_weights, _removeWeightBtn]);

  // turn on add set button when all values have been put in
  Stream<bool> get submitValid => Observable.combineLatest3(weights, reps, liftName, (w, r, l) => true);

  int removeLastPlate() {
    if (_plates['2.5'] != null && _plates['2.5'] > 0) {_plates['2.5']--; return 5;}
    if (_plates['5'] != null && _plates['5'] > 0) {_plates['5']--; return 10;}
    if (_plates['10'] != null && _plates['10'] > 0) {_plates['10']--; return 20;}
    if (_plates['25'] != null && _plates['25'] > 0) {_plates['25']--; return 50;}
    if (_plates['45'] != null && _plates['45'] > 0) {_plates['45']--; return 90;}
    // empty barbell
    return 0;
  }

  Map determinePlates(int w) {
    if (w % 5 != 0) throw Exception('weight not divisible by 45');
    var newPlates = {};
    // ~/ is floor
    if (w ~/ 90 > 0) {
      newPlates['45'] = w ~/ 90;
      w = w % 90;
    }
    if (w ~/ 50 > 0) {
      newPlates['25'] = w ~/ 50;
      w = w % 50;
    }
    if (w ~/ 20 > 0) {
      newPlates['10'] = w ~/ 20;
      w = w % 20;
    }
    if (w ~/ 10 > 0) {
      newPlates['5'] = w ~/ 10;
      w = w % 10;
    }
    if (w ~/ 5 > 0) {
      newPlates['2.5'] = w ~/ 5;
      w = w % 5;
    }
    return newPlates;
  }

  

  addSet() {

    print('sending {"weight":"${weightOnBarbell.toString()}","reps":"${_reps.value}","liftname":"${_liftName.value}"} to server');

  }

  // close streams
  dispose() {
    _reps.close();
    _liftName.close();
    _weights.close();
    _removeWeightBtn.close();
    _emptyBarbellBtn.close();
  }
}