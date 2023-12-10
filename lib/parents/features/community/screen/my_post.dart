import 'package:clarified_mobile/parents/features/community/screen/widgets/community_bottom_bar.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/post_card.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyPostScreen extends ConsumerWidget {
  MyPostScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider);
    final user = ref.watch(parentProfileProvider);

    return Scaffold(
        appBar: AppBar(
            title: const Text('Community'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                GoRouter.of(context).pushNamed("parents-home");
              },
            )),
        bottomNavigationBar: const CommunityNavBar(selected: 'parents-my-post'),
        body: post.when(
            data: (u) => ListView.builder(
                  itemBuilder: (context, index) {
                    if (u[index].postBy?.userId == user.asData?.value.id) {
                      return PostCard(
                        post: u[index],
                        userId: user.asData?.value.id ?? '',
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                  itemCount: u.length,
                  shrinkWrap: true,
               
                ),
            error: (e, st) => SizedBox(),
            loading: () => CircularProgressIndicator()));
  }
}
