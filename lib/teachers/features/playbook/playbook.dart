import 'package:clarified_mobile/parents/features/playbook/screen/widgets/playbook_card.dart';
import 'package:clarified_mobile/parents/features/playbook/screen/widgets/playbook_filter.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/teachers/features/playbook/widgets/playbook_card.dart';
import 'package:clarified_mobile/teachers/features/widgets/t_bottombar.dart';
import 'package:clarified_mobile/teachers/model/playbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlaybookTeacherScreen extends ConsumerStatefulWidget {
  const PlaybookTeacherScreen({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlaybookTeacherScreenState();

}

class _PlaybookTeacherScreenState extends ConsumerState<PlaybookTeacherScreen> {
  @override
  Widget build(BuildContext context) {
  


    final playbook = ref.watch(teacherPlaybookProvider);
    final category = ref.watch(teacherPlaybookCategoryProvider);
    final selectedCategory = ref.watch(teacherSelectedCategoryProvider);
    final domain = ref.watch(teacherPlaybookDomainProvider);
    final developmentStage = ref.watch(teacherPlaybookDevelopStageProvider);
    final filter = ref.watch(teacherFilterProvider);
    final searchPlayBook = ref.watch(teacherPlaybookSearchProvider);
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.playbook_screen),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            GoRouter.of(context).goNamed('parents=home');
            // Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        hintText: AppLocalizations.of(context)!.search_strategy,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(teacherSearchPlaybookState.notifier).state = value;
                        ref.refresh(teacherPlaybookSearchProvider);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      var res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PlayBookFilter(
                              developmentalStage: developmentStage.asData?.value ?? ["All"],
                              domain: domain.asData?.value ?? ['All'],
                            );
                          });

                      if (res != null) {
                        ref.read(teacherFilterProvider.notifier).state = {'domain': res[0], 'developmentalStage': res[1], 'effort': res[2]};
                        ref.refresh(teacherPlaybookCategoryProvider);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: const Icon(
                        Icons.format_list_bulleted_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            category.when(
                data: (e) {
                  print("+++CATEGORY LOADED${filter['domain']} ${e.academics?.length}");
                  List<String> list = [];
                  if(filter['domain']==null || filter['domain']=='All'){
                    list = (e.academics??[]);
                    list.addAll(e.sew??[]);
                    list.addAll(e.classroomClimate??[]);
                      list.add("All");
                   list= list.toSet().toList();
                  }
                  if(filter['domain']=='Academics'){
                    list = (e.academics??[]);
                    list.add("All");
                   list= list.toSet().toList();
                  }
                  if(filter['domain']=='Life Skills'){
                     list = (e.LifeSkills??[]);
                    list.add("All");
                   list= list.toSet().toList();
                  }
                  if(filter['domain']=='Behaviour'){
                     list = (e.Behaviour??[]);
                    list.add("All");
                   list= list.toSet().toList();
                  }
                   if(filter['domain']=='SEW'){
                    list = (e.sew??[]);
                    list.add("All");
                   list= list.toSet().toList();
                  }
                 
                   if(filter['domain']=='Classroom Climate'){
                    list = (e.classroomClimate??[]);
                    list.add("All");
                   list= list.toSet().toList();
                  }
                  list.sort((a, b) => a.compareTo(b));
                  return Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width + 20,
                    color: const Color(0xffF2F4F7),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                ref.read(selectedCategoryProvider.notifier).state = list[index];
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: list[index] == selectedCategory ? const Color(0xff04686E) : Colors.black, width: 1),
                                    color: list[index] == selectedCategory ? const Color(0xff04686E) : Colors.white),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text(
                                  list[index],
                                  style: TextStyle(color: list[index] == selectedCategory ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: list.length,
                    ),
                  );
                },
                error: (e, st) => const SizedBox(),
                loading: () => const CircularProgressIndicator()),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: ref.watch(teacherSearchPlaybookState.notifier).state.isNotEmpty,
              child: Column(
                children: [
                  ...searchPlayBook.when(
                      data: (u) => u.length == 0
                          ? [
                              const Center(
                                child: Text("No Playbook found"),
                              )
                            ]
                          : u.map((e) {
                              if (filter['domain'] == null) {
                                return (e.focusAreas?.contains(selectedCategory)??false  || selectedCategory == 'All')
                                    ? PlayBookTeacherCard(
                                        playbook: e,
                                      )
                                    : const SizedBox();
                              } else {
                                return (e.focusAreas?.contains(selectedCategory)??false  || selectedCategory == 'All') &&
                                        (e.domain == filter['domain'] || filter['domain'] == 'All') &&
                                        (e.stages == filter['developmentalStage'] || filter['developmentalStage'] == 'All') &&
                                        (e.effortLevel == filter['effort'] || filter['effort'] == 'All')
                                    ? PlayBookTeacherCard(
                                        playbook: e,
                                      )
                                    : const SizedBox();
                              }

                            }).toList(),
                      error: (e, st) => [const SizedBox()],
                      loading: () => [const SizedBox()]),
                ],
              ),
            ),
            Visibility(
              visible: ref.watch(teacherSearchPlaybookState.notifier).state.isEmpty,
              child: ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: [
                ...playbook.when(
                    data: (u) => u.map((e) {
                      print("+++SELECTED CATEGORY ${selectedCategory} ${e.focusAreas?.contains(selectedCategory)}");
                      e.focusAreas?.map((e) => print(e));
                          if (filter['domain'] == null || filter['domain'] == 'All') {
                            return ((e.focusAreas?.contains(selectedCategory)??true) || selectedCategory == 'All')
                                ? PlayBookTeacherCard(
                                    playbook: e,
                                  )
                                : const SizedBox();
                          } else {
                            return ((e.focusAreas?.contains(selectedCategory)??false ) || selectedCategory == 'All') ||
                                    (e.domain == filter['domain'] || filter['domain'] == 'All') &&
                                    (e.stages == filter['developmentalStage'] || filter['developmentalStage'] == 'All') &&
                                    (e.effortLevel == filter['effort'] || filter['effort'] == 'All')
                                ? PlayBookTeacherCard(
                                    playbook: e,
                                  )
                                : const SizedBox();
                          }

                          return const SizedBox();
                        }).toList(),
                    error: (e, st) => [Text(st.toString())],
                    loading: () => [const CircularProgressIndicator()])
              ]),
            )
          ],
        ),
      ),
      bottomNavigationBar: const TeachersBottomBar(
        selected: 'parents-playbook',
      ),
    );
  }
  }
