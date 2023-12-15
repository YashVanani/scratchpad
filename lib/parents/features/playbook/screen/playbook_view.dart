import 'package:clarified_mobile/parents/features/playbook/screen/widgets/playbook_card.dart';
import 'package:clarified_mobile/parents/features/playbook/screen/widgets/playbook_filter.dart';
import 'package:clarified_mobile/parents/features/widgets/p_bottombar.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final searchPlaybookState = StateProvider((_) => '');

class PlaybookScreen extends ConsumerStatefulWidget {
  const PlaybookScreen({super.key});

  @override
  ConsumerState<PlaybookScreen> createState() => _PlaybookScreenState();
}

class _PlaybookScreenState extends ConsumerState<PlaybookScreen> {

  
 @override
  Widget build(BuildContext context) {
 


    final playbook = ref.watch(playbookProvider);
    final category = ref.watch(playbookCategoryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final domain = ref.watch(playbookDomainProvider);
    final developmentStage = ref.watch(playbookDevelopStageProvider);
    final filter = ref.watch(filterProvider);
    final searchPlayBook = ref.watch(playbookSearchProvider);
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.playbook_screen),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            print("${ref.read(previousIndexNavbarProvider.notifier).state} ====");
            GoRouter.of(context).goNamed('parents=home');
            // Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
            ),
            SizedBox(
              height: 20,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        hintText: AppLocalizations.of(context)!.search_strategy,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(searchPlaybookState.notifier).state = value;
                        ref.refresh(playbookSearchProvider);
                      },
                    ),
                  ),
                  SizedBox(
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
                        ref.read(filterProvider.notifier).state = {'domain': res[0], 'developmentalStage': res[1], 'effort': res[2]};
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Icon(
                        Icons.format_list_bulleted_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            category.when(
                data: (e) {
                  if (!e.contains('All')) {
                    e.add("All");
                  }
                  e.sort((a, b) => a.compareTo(b));
                  return Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width + 20,
                    color: Color(0xffF2F4F7),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                ref.read(selectedCategoryProvider.notifier).state = e[index];
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: e[index] == selectedCategory ? Color(0xff04686E) : Colors.black, width: 1),
                                    color: e[index] == selectedCategory ? Color(0xff04686E) : Colors.white),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text(
                                  e[index],
                                  style: TextStyle(color: e[index] == selectedCategory ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: e.length,
                    ),
                  );
                },
                error: (e, st) => SizedBox(),
                loading: () => CircularProgressIndicator()),
            SizedBox(
              height: 10,
            ),
            Visibility(
              child: Column(
                children: [
                  ...searchPlayBook.when(
                      data: (u) => u.length == 0
                          ? [
                              Center(
                                child: Text("No Playbook found"),
                              )
                            ]
                          : u.map((e) {
                              if (filter['domain'] == null) {
                                return (e.categories == selectedCategory || selectedCategory == 'All')
                                    ? PlayBookCard(
                                        playbook: e,
                                      )
                                    : SizedBox();
                              } else {
                                return (e.categories == selectedCategory || selectedCategory == 'All') &&
                                        (e.domain == filter['domain'] || filter['domain'] == 'All') &&
                                        (e.stages == filter['developmentalStage'] || filter['developmentalStage'] == 'All') &&
                                        (e.effortLevel == filter['effort'] || filter['effort'] == 'All')
                                    ? PlayBookCard(
                                        playbook: e,
                                      )
                                    : SizedBox();
                              }

                              return SizedBox();
                            }).toList(),
                      error: (e, st) => [SizedBox()],
                      loading: () => [SizedBox()]),
                ],
              ),
              visible: ref.watch(searchPlaybookState.notifier).state.isNotEmpty,
            ),
            Visibility(
              visible: ref.watch(searchPlaybookState.notifier).state.isEmpty,
              child: ListView(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), children: [
                ...playbook.when(
                    data: (u) => u.map((e) {
                          if (filter['domain'] == null) {
                            return (e.categories == selectedCategory || selectedCategory == 'All')
                                ? PlayBookCard(
                                    playbook: e,
                                  )
                                : SizedBox();
                          } else {
                            return (e.categories == selectedCategory || selectedCategory == 'All') &&
                                    (e.domain == filter['domain'] || filter['domain'] == 'All') &&
                                    (e.stages == filter['developmentalStage'] || filter['developmentalStage'] == 'All') &&
                                    (e.effortLevel == filter['effort'] || filter['effort'] == 'All')
                                ? PlayBookCard(
                                    playbook: e,
                                  )
                                : SizedBox();
                          }

                          return SizedBox();
                        }).toList(),
                    error: (e, st) => [SizedBox()],
                    loading: () => [CircularProgressIndicator()])
              ]),
            )
          ],
        ),
      ),
      bottomNavigationBar: const ParentsBottomBar(
        selected: 'parents-playbook',
      ),
    );
  }

}
