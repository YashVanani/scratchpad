import 'package:clarified_mobile/features/subjects/model/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StudyMaterial extends ConsumerWidget {
  final String subjectId;
  final String topicId;

  const StudyMaterial({
    super.key,
    required this.subjectId,
    required this.topicId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final materials = ref.watch(
      caseStudyProvider(
        (subjectId: subjectId, topicId: topicId, type: "materials"),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Material"),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SPPicker(
            items: [
              (
                label: "Videos",
                onClicked: () => launchWithType(
                      context,
                      materials.value?["entries"] ?? [],
                      "video",
                    ),
              ),
              (
                label: "NCERT Solutions",
                onClicked: () => launchWithType(
                      context,
                      materials.value?["entries"] ?? [],
                      "ncert",
                    )
              ),
              (label: "Revision", onClicked: () => print("Revision")),
              (label: "Templates", onClicked: () => print("Templates")),
            ],
          ),
        ),
      ),
    );
  }

  Future launchWithType(BuildContext ctx, List<dynamic> entries, String type) {
    return Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (ctx) => ListMaterials(
          title: "Videos",
          items: List<Map<String, dynamic>>.from(
            entries?.where((d) => d["type"] == type).toList() ?? [],
          ),
        ),
      ),
    );
  }
}

class SPPicker extends StatelessWidget {
  final List<({String label, Function onClicked})> items;

  const SPPicker({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return InkWell(
          onTap: () => item.onClicked(),
          child: Container(
            height: 56,
            padding: const EdgeInsets.only(
              top: 16,
              left: 24,
              right: 16,
              bottom: 16,
            ),
            decoration: ShapeDecoration(
              color: const Color(0xFFFCFCFD),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFF68B1B6),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF68B2B7),
                  blurRadius: 0,
                  offset: Offset(0, 3),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            color: Color(0xFF045E63),
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.chevron_right_rounded)
              ],
            ),
          ),
        );
      },
    );
  }
}

class ListMaterials extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const ListMaterials({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(color: Colors.grey);
        },
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return item["type"] == "video"
              ? generateVideoTile(item)
              : item["type"] == "ncert"
                  ? generateNCERTTile(item)
                  : const SizedBox();
        },
      ),
    );
  }

  ListTile generateNCERTTile(Map<String, dynamic> item) {
    return ListTile(
      leading: Image.asset("assets/pdf_icon.png"),
      trailing: IconButton(
        onPressed: () => launchUrlString(item["url"]),
        icon: const Icon(Icons.download_sharp),
      ),
      title: Text(
        item["name"] ?? "-",
      ),
    );
  }

  ListTile generateVideoTile(Map<String, dynamic> item) {
    return ListTile(
      leading: Image.asset("assets/video_img.png"),
      trailing: IconButton(
        onPressed: () => launchUrlString(item["url"]),
        icon: const Icon(Icons.video_collection),
      ),
      title: Text(
        item["name"] ?? "-",
      ),
      subtitle: Text(item["dur"] ?? "0:00"),
    );
  }
}
