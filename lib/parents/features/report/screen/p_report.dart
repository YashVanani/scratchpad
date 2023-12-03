import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/consts/commonStyle.dart';
import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:clarified_mobile/features/shared/widgets/app_buttombar.dart';
import 'package:clarified_mobile/parents/features/widgets/p_bottombar.dart';
import 'package:flutter/material.dart';

class ParentsReport extends StatefulWidget {
  const ParentsReport({super.key});

  @override
  State<ParentsReport> createState() => _ParentsReportState();
}

class _ParentsReportState extends State<ParentsReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, size: 20)),
        centerTitle: true,
        title: Text(
          "Reports",
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTab(
              menu: const [
                (label: "Social Wellbeing", tag: "section"),
                (label: "Emotional Wellbeing", tag: "section-all"),
              ],
              callback: (tag) => setState(() {
                // leaderGraph = tag == 'section';
              }),
            ),
            const Divider(color: whiteTextColor, thickness: 1.5),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("List of available dashboards", style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14)),
                      SizedBox(height: 15),
                      availbleDashboards(context,Color(0xFF81F2BC),Color(0xFF48B990),ImageRes.manImage),
                      SizedBox(height: 15),
                      availbleDashboards(context,Color(0xFFDB71F1),Color(0xFFA651ED),ImageRes.childersImage),
                      SizedBox(height: 15),
                      availbleDashboards(context,Color(0xFF81BBF2),Color(0xFF4882B9),ImageRes.frameImage),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const ParentsBottomBar(
        selected: 'reports',
      ),
    );
  }

  availbleDashboards(BuildContext context,Color oneColor,Color twoColor,String image) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [
            oneColor,
            twoColor,
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 0, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Social Awareness", style: CommonStyle.lexendMediumStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 16, color: textMainColor)),
                  Icon(
                    Icons.star,
                    color: whiteColor,
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.",
              style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 12, color: textMainColor),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: yellowColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'OPEN',
                            style: CommonStyle.lexendMediumStyle.copyWith(fontSize: 14),
                          ),
                          SizedBox(width: 7),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Image.asset(image, height: 80)],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _sectionTab extends StatefulWidget {
  final List<({String label, String tag})> menu;
  final void Function(String currentTag) callback;

  const _sectionTab({
    super.key,
    required this.menu,
    required this.callback,
  });

  @override
  State<_sectionTab> createState() => _sectionTabState();
}

class _sectionTabState extends State<_sectionTab> {
  String selectedTag = "";

  @override
  void initState() {
    super.initState();
    selectedTag = widget.menu.firstOrNull?.tag ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: ShapeDecoration(
          color: secondTextColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
              color: whiteTextColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.menu
              .map(
                (e) => Expanded(
                  child: InkWell(
                    onTap: () => setState(() {
                      selectedTag = e.tag;
                      widget.callback(e.tag);
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: selectedTag == e.tag
                          ? ShapeDecoration(
                              color: tabBarColor,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFF045E63),
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            )
                          : null,
                      child: Text(
                        e.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedTag == e.tag ? Colors.white : const Color(0xFF045E63),
                          fontSize: 12,
                          fontFamily: 'Lexend',
                          fontWeight: selectedTag == e.tag ? FontWeight.normal : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
