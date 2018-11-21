import 'dart:async';
import 'bloc.dart';

class Transformers {
  final validateField = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) {
      if (text.length > 16) {
        sink.addError('too long');
      } else {
        sink.add(text);
      }
    }
  );
}