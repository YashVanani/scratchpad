import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/parents/features/community/screen/post_detail.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/post_delete_confirm.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostCard extends ConsumerWidget {
  
  PostCard({
    super.key,
    required this.post,
    required this.userId,
  });
  String userId;
  Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    final selectedPost = ref.watch(selectPostProvider);
    return InkWell(
      onTap: () {
        // if(GoRouter.of(context).)

        if (GoRouterState.of(context).uri.toString() != '/post-detail') {
          ref.read(selectedPostId.notifier).state=post.id??'';
          ref.refresh(selectPostProvider);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PostDetailScreen(postId: post.id ?? '')));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                post.user?.userType == 'student'
                    ? FutureBuilder(
                        future: getPostStudent(
                            post.user?.userId ?? "", 'student', ref),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    (snapshot.data?.profileUrl) ?? ''));
                          }
                          return SizedBox();
                        })
                    : post.user?.userType == 'parent'?FutureBuilder(
                        future: getPostParent(
                            post.user?.userId ?? "", 'parent', ref),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    (snapshot.data?.profileUrl) ?? ''));
                          }
                          return SizedBox();
                        }):post.user?.userType == 'teacher'?FutureBuilder(
                        future: getPostTeacher(
                            post.user?.userId ?? "", 'parent', ref),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    (snapshot.data?.profileUrl) ?? ''));
                          }
                          return SizedBox();
                        }):SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            post.user?.userType == 'student'
                    ? FutureBuilder(
                        future: getPostStudent(
                            post.user?.userId ?? "", 'student', ref),
                        builder: (context, snapshot) {

                          if (snapshot.hasData) {
                            return CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    (snapshot.data?.profileUrl) ?? ''));
                          }
                          return SizedBox();
                        })
                    : post.user?.userType == 'parent'?FutureBuilder(
                        future: getPostParent(
                            post.user?.userId ?? "", 'parent', ref),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              (snapshot.data?.name) ?? '',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            );
                          }
                          return SizedBox();
                        }):post.user?.userType == 'teacher'?FutureBuilder(
                        future: getPostTeacher(
                            post.user?.userId ?? "", 'parent', ref),
                        builder: (context, snapshot) {
                          if(snapshot.hasError){
                            print(snapshot.error.toString());
                          }
                          if (snapshot.hasData) {
                            return Text(
                              (snapshot.data?.name) ?? '',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            );
                          }
                          return SizedBox();
                        }):SizedBox(),
                           
                            Text(
                              post.postedAt
                                      ?.toDate()
                                      .toString()
                                      .substring(0, 10) ??
                                  '',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: greyTextColor),
                            ),
                          ],
                        ),
                        Text(
                          post.content ?? '',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: post.mediaUrl?.isNotEmpty ?? false,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(post.mediaUrl ?? ''),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (!(post.likedBy?.contains(userId) ??
                                    false)) {
                                  likePost(post, ref);
                                } else {
                                  unLikePost(post, ref);
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    post.likedBy?.contains(userId) ?? false
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      "${(post.likedBy?.length) ?? 0} ${AppLocalizations.of(context)!.likes}")
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String? res = await generateCurrentPageLink(
                                  context,
                                  id: post.id ?? "",
                                  title: post.content ?? "",
                                );
                                print("++RES++$res");
                                Share.share(res ?? '');
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${AppLocalizations.of(context)!.share}")
                                ],
                              ),
                            ),
                            Visibility(
                              visible: post.user?.userId == userId,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PostDeleteConfirm(
                                          ref: ref,
                                          post: post,
                                        );
                                      });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        "${AppLocalizations.of(context)!.delete}")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 0.3,
              color: greyTextColor,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
