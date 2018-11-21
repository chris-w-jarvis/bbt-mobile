import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'transformers.dart';

class Bloc extends Transformers {

  Bloc() {
    // listen to weight buttons
    this._weights.listen(
      (data) => this._currentWeights.add(data),
    );

    /*
      weight buttons send the weight as an int, remove weight sends -1
    */
    this.weightChanged.listen(
      (d) => d > 0 ? weightOnBarbell+=d : (_currentWeights.length > 1 ? weightOnBarbell-=_currentWeights.removeLast() : null)
    );
  }

  var _currentWeights = <int>[];
  var weightOnBarbell = 0;

  // listens to weight buttons
  final _weights = BehaviorSubject<int>(seedValue: 45);
  // onTap for weight animator
  final _removeWeightBtn = BehaviorSubject<int>();

  final _reps = BehaviorSubject<String>();
  final _liftName = BehaviorSubject<String>(seedValue: 'Squat');


  // update current set
  Function(int) get removeWeight => _removeWeightBtn.sink.add;
  Function(int) get addWeight => _weights.sink.add;
  Function(String) get changeReps => _reps.sink.add;
  Function(String) get changeLiftName => _liftName.sink.add;
  Stream<int> get weights => _weights;
  Stream<String> get reps => _reps.stream.transform(validateField);
  Stream<String> get liftName => _liftName.stream.transform(validateField);

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

  addSet() {

    int totalWeight = _currentWeights.reduce((a, b) => a+b);
    print('$totalWeight');
    // probably don't need this object
    print('sending {"weight":"${totalWeight.toString()}","reps":"$reps","liftname":"$liftName"} to server');

  }

  // close streams
  dispose() {
    _reps.close();
    _liftName.close();
    _weights.close();
    _removeWeightBtn.close();
  }
}