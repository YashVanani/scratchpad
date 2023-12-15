import 'package:clarified_mobile/parents/features/community/screen/widgets/post_card.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostDetailScreen extends ConsumerWidget{
  const PostDetailScreen({super.key, required this.postId});
  final String postId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final user = ref.watch(parentProfileProvider);
    return  Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.community),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
               Navigator.pop(context);
              },
            )),
            body: Column(
              children: [
                FutureBuilder<Post?>(future: getPostById(postId,ref), builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.hasError){
                    return Center(child: Text(AppLocalizations.of(context)!.something_went_wrong),);
                  }
                  if(snapshot.hasData){
                  return PostCard(
                        post: snapshot.data!,
                        userId: user.asData?.value.id ?? '',
                      );
                  }
                  return SizedBox();
                })
                   
              ],
            ),
            );
 
  }

}

  
   
