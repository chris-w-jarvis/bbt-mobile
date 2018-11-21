// this is just a data structure
// current workout ds is just a list of these
class SetObj {
  String weight;
  String reps;
  String liftName;

  SetObj(this.liftName, this.weight, this.reps);

  toJson() {
    return '{liftName:$liftName, weight:$weight, reps:$reps}';
  }
}