import 'dart:async';

import 'counter_event.dart';

class CounterBloc {
  int _counter = 0;

  final _counterStateController = StreamController<int>();
  // we input numbers into the sink and it automatically is being output to the stream
  StreamSink<int> get _inCounter => _counterStateController.sink;
  // for state, exposing only a stream which outputs data
  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // for events, exposing only a sink which is an input
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    // Whenever there is a new event, we want to map it to a new state
    _counterEventController.stream.listen(_mapEventToState);
  }
  // takes an event that checks if it is incremented
  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _counter++;
    } else {
      _counter--;
    }
    // add event to the sink
    _inCounter.add(_counter);
  }

  // closing streams to prevent memory leaks
  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }
}
