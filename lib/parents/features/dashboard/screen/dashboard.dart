import 'package:clarified_mobile/parents/features/playbook/screen/widgets/playbook_card.dart';
import 'package:clarified_mobile/parents/models/dashboard.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget{
  const DashboardScreen({Key? key, required this.dashboardReport}) : super(key: key);
  final DashboardReport dashboardReport;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(reportDashboardProviderParent);
    final playbook = ref.watch(dashboardPlaybookListProvider);
    ref.refresh(dashboardPlaybookListProvider);
     return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.dashboard),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.pop();
              // Add your onPressed code here!
            },
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                (dashboardReport.title?.toJson()[Localizations.localeOf(context).languageCode] ?? '').replaceAll('-', ' ').toUpperCase(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                  dashboardReport.desc?.toJson()[Localizations.localeOf(context).languageCode]??"",),
                  // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
            ),
            const SizedBox(
              height: 20,
            ),
            DefaultTabController(
                length: 2,
                child: Column(children: [
                   TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.flag),
                              SizedBox(
                                width: 5,
                              ),
                              Text(AppLocalizations.of(context)!.dashboard)
                            ]),
                      ),
                      Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sailing),
                              SizedBox(
                                width: 5,
                              ),
                              Text(AppLocalizations.of(context)!.activities)
                            ]),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: TabBarView(children: [
                       
                       dashboard.when(data: (d)=>InAppWebView(initialUrlRequest: URLRequest(url: WebUri((d?.url)??"")),), error: (e,j)=>Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text(AppLocalizations.of(context)!.no_dashboard)]), loading: ()=>Text(''),),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0),
                                child: Text(
                                  AppLocalizations.of(context)!.recommendations,
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                               dashboard.when(data: ( d)=>    Container(
                                height: 200 ,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 00, vertical: 2),
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: d.recommendation?.length??0,
                                  itemBuilder: (context, index) {
                                    Recommendation dashboardReportModel = (d.recommendation[index]);
                                    return Container(
                                      width: 230,
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors.grey.shade300)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.0, vertical: 24),
                                        child: Scrollbar(
                                           thumbVisibility: true,
                                          child: SingleChildScrollView(
                                            
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                   (dashboardReportModel.title?.toJson()[Localizations.localeOf(context).languageCode] ?? ''),
                                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                       dashboardReportModel.text?.toJson()[Localizations.localeOf(context).languageCode] ?? "",
                                                    // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          error: (e,j)=>Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text(AppLocalizations.of(context)!.no_result_found)]),
                            ],
                          ), loading: ()=>Text(''),),
                      
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.activities,
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17),
                                ),
                              ),
                              playbook.when(data: (d)=>ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children:d.map((e) => PlayBookCard(playbook: e)).toList(),
                                    ),
                                    error: (e,j)=>Text(''),
                                    loading: ()=>Center(child: CircularProgressIndicator(),),
                                     ),
                                     SizedBox(height: 30,)
                                
                                 
                            ],
                          ),
                        ),
                      ]))
                ]))
          ]),
        ));
  
  }

}

