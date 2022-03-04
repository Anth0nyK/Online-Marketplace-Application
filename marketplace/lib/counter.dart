import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterState extends ChangeNotifier {
  int count = 0;

  updateCount() {
    count++;
    notifyListeners();
  }
}

class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterState(),
      child: const CountText(),
    );
  }
}

class CountText extends StatelessWidget {
  const CountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<CounterState>();
    var state2 = Provider.of<CounterState>(context);

    return Text('${state.count}');
  }
}
