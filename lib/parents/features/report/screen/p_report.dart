import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/consts/commonStyle.dart';
import 'package:clarified_mobile/consts/imageRes.dart';
import 'package:clarified_mobile/features/shared/widgets/app_buttombar.dart';
import 'package:clarified_mobile/parents/features/widgets/p_bottombar.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ParentsReport extends ConsumerWidget{
  ParentsReport({super.key});
   @override
  Widget build(BuildContext context, WidgetRef ref) {
 return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              // Navigator.pop(context);
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
            FutureBuilder(future: getReportMenuType(ref), builder: (context,snapshot)=>_sectionTab(
              menu: snapshot.data??[],
              callback: (tag) =>{},
            )),
           
            
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
        selected: 'parents-report',
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
                InkWell(
                  onTap: () {
                    GoRouter.of(context).pushNamed('parents-dashboard');
                  },
                  child: Padding(
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

class _sectionTab extends ConsumerWidget{
 final List<MenuType> menu;
  final void Function(String currentTag) callback;

  const _sectionTab({
    super.key,
    required this.menu,
    required this.callback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMenu = ref.watch(myCurrentReportType);
    final dashboard = ref.watch(reportDashboardProvider);
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        height:60,
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
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: menu
                .map(
                  (e) => InkWell(
                    onTap: () {
                      ref.read(myCurrentReportType.notifier).state = e;
                      
                    }// widget.callback(e.tag);
                    ,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration:  selectedMenu?.value == e.value
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
                        e.label??'',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedMenu?.value == e.value ? Colors.white : const Color(0xFF045E63),
                          fontSize: 12,
                          fontFamily: 'Lexend',
                          fontWeight: selectedMenu?.value == e.value ? FontWeight.normal : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
        ),
      ),
    );
 ;
  }
}
