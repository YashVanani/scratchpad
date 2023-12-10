import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/community_bottom_bar.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/community_pop.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/post_card.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CommunityScreen extends ConsumerWidget {
  CommunityScreen({Key? key}) : super(key: key);
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
        bottomNavigationBar:
            const CommunityNavBar(selected: 'parents-community'),
        body: post.when(
            data: (u) => ListView.builder(
                  itemBuilder: (context, index) {
                    return PostCard(post: u[index],userId: user.asData?.value.id??'',);
                  },
                  itemCount: u.length,
                  shrinkWrap: true,
                 
                ),
            error: (e, st) => SizedBox(),
            loading: () => CircularProgressIndicator()));
  }
}
// class CommunityScreen extends StatefulWidget {
//   const CommunityScreen({super.key});

//   @override
//   State<CommunityScreen> createState() => _CommunityScreenState();
// }

// class _CommunityScreenState extends State<CommunityScreen> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return const CommunityPop();
//           });
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: const Text('Community'),
//             centerTitle: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: () {
//                 GoRouter.of(context).pushNamed("parents-home");
//               },
//             )),
//         bottomNavigationBar: CommunityNavBar(selected: 'parents-community'),
//         body: const SingleChildScrollView(
//           child: Column(
//             children: [
//               PostCard(),
//               PostCard(),
//               PostCard(),
//               PostCard(),
//             ],
//           ),
//         ));
//   }
// }


