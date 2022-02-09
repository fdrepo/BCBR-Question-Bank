import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../state/app_state.dart';
import '../state/quiz_state.dart';
import '../models/mcq.dart';
import 'quiz_actions.dart';
import 'quiz_selectors.dart';

class QuizScreen extends HookWidget {
  const QuizScreen({
    Key? key,
    required this.tag,
  }) : super(key: key);

  final String tag;

  static MaterialPageRoute<dynamic> route(String tag) {
    return MaterialPageRoute<dynamic>(
        builder: (context) => QuizScreen(tag: tag));
  }

  void _loadMcqs(Store<AppState> store) {
    store.dispatch(QuizActions.loadMcqs(tag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tag)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: QuizScreenBody()),
          StoreConnector<AppState, NextPageStatus>(
            onInit: _loadMcqs,
            converter: (store) => getNextPageStatus(store.state),
            builder: _buildBottomSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context, NextPageStatus status) {
    if (status == NextPageStatus.notShown) return const SizedBox.shrink();

    late final String title;
    late final VoidCallback? onTap;
    switch (status) {
      case NextPageStatus.notShown:
        return const SizedBox.shrink();
      case NextPageStatus.nextQuestion:
        title = 'Next Question';
        onTap = () {
          StoreProvider.of<AppState>(context, listen: false)
              .dispatch(const QuizActions.nextMcq());
        };
        break;
      case NextPageStatus.showResult:
        title = 'Show Result';
        onTap = () {
          StoreProvider.of<AppState>(context, listen: false)
              .dispatch(const QuizActions.nextMcq());
        };
        break;
      case NextPageStatus.submit:
        title = 'Submit';
        onTap = () {
          StoreProvider.of<AppState>(context, listen: false)
              .dispatch(const QuizActions.submit());
        };
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(onPressed: onTap, child: Text(title)),
    );
  }
}

class QuizScreenBody extends HookWidget {
  const QuizScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizSnapshot = useStream(
        StoreProvider.of<AppState>(context).onChange.map((s) => s.quiz));

    final quiz = quizSnapshot.data;
    final mcqs = quiz?.mcqs;
    if (quiz == null || mcqs == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentPageIndex = useState(quiz.currentMcqIndex);
    final pageController =
        usePageController(initialPage: currentPageIndex.value);

    if (quiz.status == QuizStatus.complete) {
      final theme = Theme.of(context).textTheme;
      final correctAnswers = quiz.correctlyAnsweredMcqIndices.length;
      final totalQuestions = mcqs.length;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$correctAnswers / $totalQuestions', style: theme.headline4),
            Text('CORRECT', style: theme.headline5),
          ],
        ),
      );
    }

    final currentMcq = quiz.currentMcq;
    if (currentMcq == null || currentPageIndex.value != quiz.currentMcqIndex) {
      currentPageIndex.value = quiz.currentMcqIndex;
      pageController.animateToPage(
        currentPageIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }

    return PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mcqs.length,
      itemBuilder: (context, index) {
        return McqView(mcq: mcqs[index], answerStatus: getAnswerStatus(quiz));
      },
    );
  }
}

class McqView extends StatelessWidget {
  const McqView({Key? key, required this.mcq, required this.answerStatus})
      : super(key: key);

  final MCQ mcq;
  final Map<String, AnswerStatus> answerStatus;

  Widget _leadingIcon(String answer) {
    switch (answerStatus[answer]) {
      case null:
        return const Icon(Icons.circle_outlined);
      case AnswerStatus.selected:
        return const Icon(Icons.circle);
      case AnswerStatus.incorrect:
        return const Icon(Icons.remove_circle_rounded, color: Colors.red);
      case AnswerStatus.correct:
        return const Icon(Icons.check_circle_rounded, color: Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Q${mcq.questionNumber}. ${mcq.question}',
                style: theme.textTheme.headline6,
              ),
            ),
          ),
          for (final answer in mcq.allAnswers)
            Card(
              child: ListTile(
                leading: _leadingIcon(answer),
                title: Text(answer),
                onTap: () => StoreProvider.of<AppState>(context, listen: false)
                    .dispatch(QuizActions.select(answer)),
              ),
            )
        ],
      ),
    );
  }
}
