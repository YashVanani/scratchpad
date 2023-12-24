import 'package:clarified_mobile/parents/features/community/screen/post_detail.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingPageState();

}

class _LoadingPageState extends ConsumerState {
  Future<void> handleLinkData(PendingDynamicLinkData data,BuildContext context) async {
    final Uri? uri = data?.link;
    if(uri != null) {
      final queryParams = uri.queryParameters;
      print(queryParams);
      if(queryParams.length > 0) {
        ref.read(selectedPostId.notifier).state= queryParams['id']??"";
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PostDetailScreen(postId: queryParams['id']??"",)));
     
}
    }
  }
  void fetchLinkData(BuildContext context) async {
    try{
      print("FETCHING LINK DATA");
      var link = await FirebaseDynamicLinks.instance.getInitialLink();
      if(link!=null)
        handleLinkData(link,context);

      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
        final Uri uri = dynamicLinkData.link;
        final queryParams = uri.queryParameters;
        if (queryParams.isNotEmpty) {
          } else {
          print("No Current Links");
         }
      });
    }catch(e){
      print("+++ERROR ${e}");
    }
  }
  @override
  void initState() {
    fetchLinkData(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}