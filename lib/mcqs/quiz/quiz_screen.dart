import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'
    show usePageController, HookWidget;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../app_state.dart';
import '../../models/mcq.dart';
import 'quiz_actions.dart';
import 'quiz_selector.dart';

class QuizScreen extends HookWidget {
  const QuizScreen({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final String tag;

  static MaterialPageRoute<dynamic> route(String tag) {
    return MaterialPageRoute(builder: (context) => QuizScreen(tag: tag));
  }

  void _onInit(Store<AppState> store) {
    store.dispatch(QuizActions.loadMcqs(tag));
  }

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    return Scaffold(
      appBar: AppBar(title: Text(tag)),
      body: StoreConnector<AppState, List<MCQ>?>(
        onInit: _onInit,
        converter: (store) => mcqs(store.state),
        builder: (context, mcqs) => _buildBody(context, mcqs, pageController),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<MCQ>? mcqs,
    PageController pageController,
  ) {
    if (mcqs == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PageView(
      controller: pageController,
      children: mcqs.map((mcq) => McqView(mcq: mcq)).toList(),
    );
  }
}

class McqView extends StatelessWidget {
  const McqView({Key? key, required this.mcq}) : super(key: key);

  final MCQ mcq;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(mcq.question, style: theme.textTheme.headline5),
        for (final answer in mcq.allAnswers)
          ListTile(
            leading: const Icon(Icons.circle_outlined),
            title: Text(answer),
          )
      ],
    );
  }
}
