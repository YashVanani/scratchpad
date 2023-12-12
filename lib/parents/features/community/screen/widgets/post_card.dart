import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/parents/features/community/screen/post_detail.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/post_delete_confirm.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
class PostCard extends ConsumerWidget {
  PostCard({
    super.key,
  required this.post,
  required this.userId,
  }
  );
  String userId;
  Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("++POST ID++${post.id}");
    return InkWell(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context) => PostDetailScreen(postId: post.id??'')));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 CircleAvatar(
                  radius: 20,
                  backgroundImage:NetworkImage((post.postBy?.userAvatar)??'')
                      
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start ,
                    children: [
                     Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                         (post.postBy?.username)??'',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          post.postAt?.toDate().toString().substring(0, 10)??'',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: greyTextColor),
                        ),
                      ],
                    ),
                     Text(
                       post.content??'',),
                      const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: post.postImage?.isNotEmpty??false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(post.postImage??''),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         InkWell(
                          onTap: (){
                            if( !(post.likedBy?.contains(userId)??false)){
                              likePost(post, ref);
                            }else{
                              unLikePost(post, ref);
                            }
                          },
                           child: Row(
                            children: [
                              Icon(
                                post.likedBy?.contains(userId)??false? Icons.favorite:Icons.favorite_border,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("${post.likes??0} likes")
                            ],
                                               ),
                         ),
                        InkWell(
                          onTap: ()async {
                           String? res = await generateCurrentPageLink(context,id: post.id??"",title: post.content??"",);
                           print("++RES++$res");
                           Share.share(res??'');
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Share")
                            ],
                          ),
                        ),
                        Visibility(
                          visible: post.postBy?.userId==userId,
                          child: InkWell(
                            onTap: () {
                                  showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PostDeleteConfirm(ref: ref,post: post,);
                              });
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Delete")
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
