import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/teachers/features/lesson/create_lession.dart';
import 'package:clarified_mobile/teachers/features/myActivities/myActivities.dart';
import 'package:clarified_mobile/teachers/features/myspace/widgets/add_task.dart';
import 'package:clarified_mobile/teachers/features/widgets/t_bottombar.dart';
import 'package:clarified_mobile/teachers/model/myspace.dart';
import 'package:clarified_mobile/teachers/model/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MySpaceScreen extends ConsumerStatefulWidget {
  const MySpaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MySpaceScreenState();
}

class _MySpaceScreenState extends ConsumerState<MySpaceScreen> {
  @override
  Widget build(BuildContext context) {
    
    final teacher = ref.watch(teacherProfileProvider);
    var calender = ref.watch(calenderProvider);
    final taskList = ref.watch(taskListProvider);
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar:AppBar(
          toolbarHeight: 0,
          bottom:  TabBar(
          isScrollable: true,
          labelColor: greenTextColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: greenTextColor,
          tabs: [
            Tab(
                child: Text(
              AppLocalizations.of(context)!.remender_and_notes,
            )),
            Tab(
                child: Text(
              AppLocalizations.of(context)!.lesson_plan,
            )),
            Tab(
                child: Text(
              AppLocalizations.of(context)!.assignment,
            )),
            Tab(
                child: Text(
              AppLocalizations.of(context)!.my_activity,
            )),
          ],
        ),
      
        ), 
         body: TabBarView(children: [
            SizedBox(
                height: MediaQuery.of(context).size.height*0.72+120,
              child: Column(
        
                mainAxisSize: MainAxisSize.min,
                            children: [
                SizedBox(
                            height: MediaQuery.of(context).size.height*0.72,
                            child: Column(
                            
              children: [
                SizedBox(height: 10,),
                CalendarTimeline(
                  showYears: false,
                  initialDate:  ref.read(teacherCalenderDateProvider.notifier).state,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  onDateSelected: (date) {
                    ref.read(teacherCalenderDateProvider.notifier).state = date;
                    ref.read(taskListProvider.notifier).state.clear();
                    calender = ref.refresh(calenderProvider);
                    setState(() {
                      
                    });
                    // print(date)
                  },
                  leftMargin: 10,
                  monthColor: Colors.blueGrey,
                  dayColor: Colors.teal[200],
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: greenTextColor,
                  dotsColor: Colors.white,
                ),
                calender.when(
                    data: (d) {
                      print("DATA ${d}");
                      if(taskList.isEmpty){
                        return SizedBox(
                          height: MediaQuery.of(context).size.height*0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/svg/noresult.svg'),
                              Text(AppLocalizations.of(context)!.no_result_found,style: TextStyle(color: Colors.red),)
                            ],
                          ),
                        );
                      }else{
                        return 
                    ListView.builder(
                      itemCount: taskList.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Row(
                          
                          children: [
                           (taskList[index].playbookId!=null&&(taskList[index].playbookId?.isNotEmpty??true))?SvgPicture.asset('assets/svg/playbookReminder.svg',width: 48,height: 48,): SvgPicture.asset('assets/svg/taskReminder.svg',width: 48,height: 48,),
                            
                      SizedBox(width:10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(taskList[index].title??"",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                              Row(children: [
                               Text(taskList[index].className??"",
                      style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                      ),),
                      SizedBox(width: 5,),
                      Text("•",
                      style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                      ),),
                      
                      SizedBox(width: 5,),
                      Text(DateFormat('jm').format(taskList[index].date??DateTime.now())??"",
                      style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w400,
                      ),),
                              ],)
                            ],)
                          ],
                        ),
                      );
                    });
                      }
                    },
                    error: (e, s) => Text(s.toString()),
                    loading: () => CircularProgressIndicator())
              ],
                            ),
                          ),
              Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async{
                                await showDialog(context: context, builder: (context){
                                  return AddTaskDialog(classId: teacher.asData?.value.classIds??[], );
                                });
                                // if (loginFormKey.currentState?.validate() ==
                                //     true) {
                                //   attemptLogin();
                                // }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF04686E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x0C101828),
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: 
                                   
                                    Text(
                                      // 'LOGIN',
                                      "ADD Task",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w400,
                                        height: 0.09,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                   
                      
                            ],
                          ),
            ),
        Container(color: Colors.red,
          height: MediaQuery.of(context).size.height*0.72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
                 Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () async{
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateLessonScreen()));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF04686E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x0C101828),
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: 
                                   
                                    Text(
                                      // 'LOGIN',
                                      "+ CREATE LESSON PLAN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w400,
                                        height: 0.09,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                   
             
            ],
          ),),
        Container(color: Colors.yellow,
          height: MediaQuery.of(context).size.height*0.72,),
        MyActivityScreen(),
                  
        ]),
        bottomNavigationBar: const TeachersBottomBar(
          selected: 'teachers-my-space',
        ),
      ),
    );
  }
}
