import 'package:clarified_mobile/model/clazz.dart';
import 'package:clarified_mobile/teachers/model/lesson_plan.dart';
import 'package:clarified_mobile/teachers/model/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateLessonScreen extends ConsumerStatefulWidget {
  const CreateLessonScreen({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateLessonScreenState();

}

class _CreateLessonScreenState extends ConsumerState<CreateLessonScreen> {
  
  @override
  Widget build(BuildContext context) {
    
    final profile = ref.watch(teacherProfileProvider);
    final subject = ref.watch(subjectListLessonProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create Lesson Plan"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Class",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              profile.when(data: (d)=> Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: DropdownButton(
                  underline: SizedBox(),
                  hint: Text("Select Class"),
                  isExpanded: true,
                  items: d.classIds.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                       ref.read(selectedClassIdLessonState.notifier).state = (v??"");
                       ref.refresh(classroomSubjectLessonProvider);
                        ref.refresh(subjectListLessonProvider);
                    });
                   
                  },
                  value:  ref.read(selectedClassIdLessonState.notifier).state.isEmpty?null:ref.read(selectedClassIdLessonState.notifier).state,
                ),
              ),
              error: (e,j)=>Text(""), loading: ()=>Text("")),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Subject",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 8,
              ),
               subject.when(data: (d)=> Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: DropdownButton(
                  underline: SizedBox(),
                  hint: Text("Select Subject"),
                  isExpanded: true,
                  items:d.isNotEmpty? d.map((e) => e.name).toSet().toList().map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList():null,
                  onChanged: (v) {
                    setState(() {
                       ref.read(selectedsubjectIdLessonState.notifier).state = (v??"");
                        ref.refresh(subjectListLessonProvider);
                    });
                   
                  },
                  value:  ref.read(selectedsubjectIdLessonState.notifier).state.isEmpty?null:ref.read(selectedsubjectIdLessonState.notifier).state,
                ),
              ),
              error: (e,j)=>Container(
                 margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: DropdownButton(
                    underline: SizedBox(),
                    hint: Text("Select Subject"),
                    isExpanded: true,
                    items: [],
                    onChanged: (vv){},
                     ),
              ), loading: ()=>Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: Container(
                   margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                  child: DropdownButton(
                    underline: SizedBox(),
                    hint: Text("Select Subject"),
                    isExpanded: true,
                    items: [],
                    onChanged: (vv){},
                     ),
                ),
              ),
             ),
              SizedBox(
                height: 20,
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Topic",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 8,
              ),
               subject.when(data: (d){
                if(d.isNotEmpty && ref.read(selectedsubjectIdLessonState.notifier).state.isNotEmpty){
                  return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: DropdownButton(
                  underline: SizedBox(),
                  hint: Text("Select Topic"),
                  isExpanded: true,
                  items:d.isNotEmpty? d.firstWhere((element) => element.name==ref.read(selectedsubjectIdLessonState.notifier).state)?.topics.map((e) => e.name).toSet().toList().map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList():[],
                  onChanged: (v) {
                    // setState(() {
                    //    ref.read(selectedsubjectIdLessonState.notifier).state = (v??"");
                    //     ref.refresh(subjectListLessonProvider);
                    // });
                   
                  },
                  // value:  ref.read(selectedsubjectIdLessonState.notifier).state.isEmpty?null:ref.read(selectedsubjectIdLessonState.notifier).state,
                ),
              );
                }else{
                  return Container(
                     margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                    child: DropdownButton(
                    underline: SizedBox(),
                    hint: Text("Select Topic"),
                    isExpanded: true,
                    items: [],
                    onChanged: (vv){},
                     ),
                  );
                }
               },
              error: (e,j)=>Container(
                 margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
                child: DropdownButton(
                  underline: SizedBox(),
                  hint: Text("Select Topics"),
                  isExpanded: true,
                  items: [],
                  onChanged: (vv){},
                   ),
              ), loading: ()=>Text("")
             ),
        ],
      ),
    );
  }
}