import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'transformers.dart';

class Bloc extends Transformers {

  Bloc() {
    weights.listen(
      (d) => _plates.add(d)
    );
    /*
      weight buttons send the weight as an int, remove weight sends -1
    */
    this.weightChanged.listen(
      (w) {
        // if given a positive value its from weights stream, increment weight on barbell, if not, its from removeWeightBtn stream, remove last weight if there is one
        if (w > 0) weightOnBarbell+=w;
        else {
          if (_plates.length > 1) weightOnBarbell -= _plates.removeLast();
        }
      }
    );

    // // long press for weight to remove all weights
    // this._emptyBarbellBtn.listen((_) { _currentWeights.clear(); weightOnBarbell = 45;});
  }

  var _plates = <int>[];
  var weightOnBarbell = 0;

  // listens to weight buttons
  final _weights = BehaviorSubject<int>(seedValue: 45);
  // onTap for weight animator
  final _removeWeightBtn = BehaviorSubject<int>();
  // // onLongPress for weight animator
  // final _emptyBarbellBtn = BehaviorSubject<bool>();

  final _reps = BehaviorSubject<String>();
  final _liftName = BehaviorSubject<String>(seedValue: 'Squat');


  // update current set
  // Function(bool) get emptyBarbell => _emptyBarbellBtn.sink.add;
  Function(int) get removeWeight => _removeWeightBtn.sink.add;
  Function(int) get addWeight => _weights.sink.add;
  Function(String) get changeReps => _reps.sink.add;
  Function(String) get changeLiftName => _liftName.sink.add;
  Stream<int> get weights => _weights;
  Stream<String> get reps => _reps.stream.transform(validateField);
  Stream<String> get liftName => _liftName.stream.transform(validateField);
  //Map get getPlates => _plates;

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

  // int removeLastPlate() {
  //   if (_plates['2.5'] != null && _plates['2.5'] > 0) {_plates['2.5']--; return 5;}
  //   if (_plates['5'] != null && _plates['5'] > 0) {_plates['5']--; return 10;}
  //   if (_plates['10'] != null && _plates['10'] > 0) {_plates['10']--; return 20;}
  //   if (_plates['25'] != null && _plates['25'] > 0) {_plates['25']--; return 50;}
  //   if (_plates['45'] != null && _plates['45'] > 0) {_plates['45']--; return 90;}
  //   // empty barbell
  //   return 0;
  // }

  

  addSet() {

    int totalWeight = _plates.reduce((a, b) => a+b);
    // probably don't need this object
    print('sending {"weight":"${totalWeight.toString()}","reps":"${_reps.value}","liftname":"${_liftName.value}"} to server');

  }

  // close streams
  dispose() {
    _reps.close();
    _liftName.close();
    _weights.close();
    _removeWeightBtn.close();
    // _emptyBarbellBtn.close();
  }
}