import 'package:clarified_mobile/teachers/features/playbook/widgets/playbook_card.dart';
import 'package:clarified_mobile/teachers/model/myspace.dart';
import 'package:clarified_mobile/teachers/model/playbook.dart';
import 'package:clarified_mobile/teachers/model/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyActivityScreen extends ConsumerStatefulWidget {
  const MyActivityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyActivityScreenState();
}

class _MyActivityScreenState extends ConsumerState<MyActivityScreen> {
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final favoriteActivity = ref.refresh(teacherFavoriteActivityProvider);
    final appliedActivity = ref.refresh(teacherAppliedActivityProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final favoriteActivity = ref.read(teacherFavoriteActivityProvider);
    final appliedActivity = ref.read(teacherAppliedActivityProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xffF2F4F7),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () {
                  setState(() {
                    ref.read(myActivityTabProvider.notifier).state = true;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: ref.read(myActivityTabProvider.notifier).state
                      ? BoxDecoration(
                          color: Color(0xff04686E),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )
                      : BoxDecoration(
                          // color: Color(0xffD0D5DD),
                          border: Border.all(color: Color(0xffD0D5DD)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                  child: Text(
                    "Favorite Activities",
                    style: TextStyle(
                        color: ref.read(myActivityTabProvider.notifier).state
                            ? Colors.white
                            : Color(0xff667085)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    ref.read(myActivityTabProvider.notifier).state = false;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: !ref.read(myActivityTabProvider.notifier).state
                      ? BoxDecoration(
                          color: Color(0xff04686E),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )
                      : BoxDecoration(
                          // color: Color(0xffD0D5DD),
                          border: Border.all(color: Color(0xffD0D5DD)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                  child: Text(
                    "Applied Activities",
                    style: TextStyle(
                        color: !ref.read(myActivityTabProvider.notifier).state
                            ? Colors.white
                            : Color(0xff667085)),
                  ),
                ),
              )
            ]),
          ),
          Visibility(visible: ref.read(myActivityTabProvider.notifier).state,child: favoriteActivity.when(data: (d)=>ListView.builder(physics: NeverScrollableScrollPhysics(),itemCount: d.length,shrinkWrap: true,itemBuilder: (context,index)=>PlayBookTeacherCard(playbook: d[index]),), error: (e,j)=>SizedBox(), loading: ()=>SizedBox())),
          Visibility(visible: !ref.read(myActivityTabProvider.notifier).state,child: appliedActivity.when(data: (d)=>ListView.builder(physics: NeverScrollableScrollPhysics(),itemCount: d.length,shrinkWrap: true,itemBuilder: (context,index)=>PlayBookTeacherCard(playbook: d[index]),), error: (e,j)=>SizedBox(), loading: ()=>SizedBox())),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}
