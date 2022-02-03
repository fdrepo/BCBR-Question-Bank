import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../app_state.dart';
import '../quiz/quiz_screen.dart';
import 'tags_actions.dart';
import 'tags_selectors.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({Key? key}) : super(key: key);

  void _onInit(Store<AppState> store) {
    store.dispatch(const TagsActions.load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BCBR')),
      body: StoreConnector<AppState, List<String>?>(
        onInit: _onInit,
        converter: (store) => tagsList(store.state),
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<String>? tags) {
    if (tags == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (context, i) {
        final tag = tags[i];
        return Card(
          child: ListTile(
            title: Text('# $tag'),
            onTap: () => Navigator.of(context).push(QuizScreen.route(tag)),
          ),
        );
      },
    );
  }
}
