import 'package:fd_bcbr/csv_mcq_data_repo.dart';
import 'package:fd_bcbr/mcq_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

final mcqsProvider = StateNotifierProvider<MCQProvider, MCQState>((ref) {
  return MCQProvider();
});

class HomeScreen extends StatelessWidget {
  final repo = CsvMcqDataRepo();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    repo.getMCQs();
    return Scaffold(
      appBar: AppBar(title: const Text("List of Chapters")),
      body: const MCQList(),
    );
  }
}

class MCQList extends ConsumerWidget {
  const MCQList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mcqsState = ref.watch(mcqsProvider);

    if (mcqsState is MCQLoadedList) {
      final tags = mcqsState.tags;
      return ListView.builder(
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return ListTile(
            title: Text('#$tag'),
          );
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class MCQScreen extends StatelessWidget {
  const MCQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
