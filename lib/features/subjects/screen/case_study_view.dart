import 'package:clarified_mobile/features/subjects/model/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

class CaseStudyViewer extends ConsumerWidget {
  final String subjectId;
  final String topicId;

  const CaseStudyViewer({
    super.key,
    required this.subjectId,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final caseStudyInfo = ref.watch(
      caseStudyProvider(
        (subjectId: subjectId, topicId: topicId, type: "case-study"),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Case Study"),
      ),
      body: SizedBox.expand(
        child: Markdown(
          data: caseStudyInfo.value?["content"] ?? "",
          extensionSet: md.ExtensionSet(
            md.ExtensionSet.gitHubFlavored.blockSyntaxes,
            <md.InlineSyntax>[
              md.EmojiSyntax(),
              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
            ],
          ),
        ),
      ),
    );
  }
}
