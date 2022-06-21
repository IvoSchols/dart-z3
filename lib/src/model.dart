import 'generated_bindings.dart';

import 'object.dart';
import 'context.dart';

class Model extends Object {
  late Z3_model _model;

  Model(NativeZ3Library lookup, Context context) : super(lookup, context);
}
