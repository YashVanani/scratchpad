import 'package:clarified_mobile/parents/features/community/screen/widgets/post_card.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailScreen extends ConsumerWidget{
  const PostDetailScreen({super.key, required this.postId});
  final String postId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final user = ref.watch(parentProfileProvider);
    return  Scaffold(
        appBar: AppBar(
            title: const Text('Community'),
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
                    return const Center(child: Text('Something went wrong'),);
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

  
   
