class Actions with _$Actions {
  const factory Actions.loadMcqTopicTags() = ActionsLoadMcqTopicTags;
  const factory Actions.loadingMcqTopicTags() = ActionsLoadingMcqTopicTags;
  const factory Actions.loadedMcqTopicTags(Set<String> tags) =
      TagsActionsLoaded;
  const factory Actions.loadingMcqTopicTagsfailure(TagsFailure? failure) =
      ActionsLoadingMcqTopicTagsfailure;

  const factory Actions.selectView(TagsView view) = ActionSelectView;

  const factory Actions.selectMcq(String answer) = ActionsSelect;
  const factory Actions.submitMcq() = ActionsSubmit;
  const factory Actions.nextMcq() = ActionsNextMcq;

  const factory Actions.startSearchTopicTags() = ActionsStartSearchTopicTags;
  const factory Actions.stopSearchTopicTags() = ActionsStopSearchTopicTags;
  const factory Actions.queryTopicTags(String query) = ActionsQueryTopicTags;

  const factory Actions.loadMcqstoQuiz(String tag) = ActionsLoadMcqstoQuiz;
  const factory Actions.loadingMcqstoQuiz() = ActionsLoadingMcqstoQuiz;
  const factory Actions.loadedMcqstoQuiz(String tag, List<MCQ> mcqs) =
      ActionsLoadedMcqstoQuiz;
}
