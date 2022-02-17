import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:redux/redux.dart';

import '../state/app_state.dart';
import '../state/tags_state.dart';
import '../quiz/quiz_screen.dart';
import 'tags_actions.dart';
import 'tags_selectors.dart';

extension on TagsFailure? {
  String message(BuildContext context) {
    switch (this) {
      case null:
        return 'An error occured!';
      case TagsFailure.disconnected:
        return 'No internet connection.';
    }
  }
}

class TagsScreen extends StatelessWidget {
  const TagsScreen({Key? key}) : super(key: key);

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const TagsScreen());
  }

  void _loadTags(Store<AppState> store) {
    store.dispatch(const TagsAction.load());
  }

  void _retryLoadingTags(BuildContext context) {
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(const TagsAction.load());
  }

  void _query(BuildContext context, String query) {
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(TagsAction.query(query));
  }

  void _startSearch(BuildContext context) {
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(const TagsAction.startSearch());
  }

  void _stopSearch(BuildContext context) {
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(const TagsAction.stopSearch());
  }

  void _selectView(BuildContext context, TagsView view) {
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(TagsAction.selectView(view));
  }

  void _navigateToQuiz(BuildContext context, String tag) {
    Navigator.of(context).push<void>(QuizScreen.route(tag));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TagsAppBarOptions>(
      converter: (store) => tagsAppBarOptionsSelector(store.state),
      builder: _buildScreen,
    );
  }

  Widget _buildScreen(BuildContext context, TagsAppBarOptions options) {
    return Scaffold(
      appBar: AppBar(
        leading: options.isSearchEnabled ? const Icon(Icons.search) : null,
        title: _buildAppBarTitle(context, options),
        actions: [
          if (options.isSearchEnabled)
            IconButton(
              onPressed: () => _stopSearch(context),
              icon: const Icon(Icons.close),
            )
          else ...[
            IconButton(
              onPressed: options.canSearch ? () => _startSearch(context) : null,
              icon: const Icon(Icons.search),
            ),
            if (options.view == TagsView.grid)
              IconButton(
                onPressed: () => _selectView(context, TagsView.list),
                icon: const Icon(Icons.list),
              )
            else
              IconButton(
                onPressed: () => _selectView(context, TagsView.grid),
                icon: const Icon(Icons.grid_on),
              ),
          ]
        ],
      ),
      body: StoreConnector<AppState, FilteredTagsView>(
        onInit: _loadTags,
        converter: (store) => filteredTagsViewSelector(store.state),
        builder: _buildBody,
      ),
    );
  }

  Widget _buildAppBarTitle(BuildContext context, TagsAppBarOptions options) {
    if (options.isSearchEnabled) {
      return TextFormField(
        initialValue: options.query,
        onChanged: (q) => _query(context, q),
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Enter query',
          isDense: true,
        ),
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
      );
    } else {
      return const Text('BCBR');
    }
  }

  Widget _buildBody(BuildContext context, FilteredTagsView ftv) {
    if (ftv.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(ftv.failure.message(context)),
            OutlinedButton(
              onPressed: () => _retryLoadingTags(context),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final tags = ftv.tags;

    if (tags == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final width = MediaQuery.of(context).size.width;
    const padding = EdgeInsets.all(8.0);
    const physics = BouncingScrollPhysics();

    switch (ftv.view) {
      case TagsView.list:
        return ListView.builder(
          padding: padding,
          physics: physics,
          itemCount: tags.length,
          itemBuilder: (context, i) => _buildTagCard(context, tags[i]),
        );
      case TagsView.grid:
        return MasonryGridView.count(
          padding: padding,
          physics: physics,
          crossAxisCount: width ~/ 250,
          itemCount: tags.length,
          itemBuilder: (context, i) => _buildTagCard(context, tags[i]),
        );
    }
  }

  Widget _buildTagCard(BuildContext context, String tag) {
    return Card(
      child: ListTile(
        title: Text('# $tag'),
        onTap: () => _navigateToQuiz(context, tag),
      ),
    );
  }
}
