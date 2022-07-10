import 'package:equatable/equatable.dart';
import 'package:recipe_search/helpers/update_dynamic.dart';

class Range extends Equatable {
  final int min;
  final int max;

  const Range({
    required this.min,
    required this.max,
  }) : assert(0 <= min && min <= max);

  factory Range.defaultRange() {
    return const Range(min: 0, max: 10000);
  }

  factory Range.copyWith(
    Range old, {
    int? min,
    int? max,
  }) {
    if (min != null && min < 0) {
      throw ArgumentError("invalid min value $min");
    }
    if (max != null && max < 0) {
      throw ArgumentError("invalid max value $max");
    }
    if (min != null && max != null && min > max) {
      throw ArgumentError("invalid min-max values $min $max");
    }
    if (min != null && min > old.max) {
      throw ArgumentError("cannot update min to $min");
    }
    if (max != null && max < old.min) {
      throw ArgumentError("cannot update max to $max");
    }
    return Range(
      min: update(old.min, min),
      max: update(old.max, max),
    );
  }

  @override
  List<Object?> get props => [min, max];
}
