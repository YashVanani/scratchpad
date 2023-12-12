import 'package:clarified_mobile/parents/features/community/screen/post_detail.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void> handleLinkData(PendingDynamicLinkData data,BuildContext context) async {
    final Uri? uri = data?.link;
    if(uri != null) {
      final queryParams = uri.queryParameters;
      print(queryParams);
      if(queryParams.length > 0) {
        
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