import 'package:clarified_mobile/parents/features/community/screen/widgets/community_bottom_bar.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyPostScreen extends StatefulWidget {
  const MyPostScreen({super.key});

  @override
  State<MyPostScreen> createState() => _MyPostScreenState();
}

class _MyPostScreenState extends State<MyPostScreen> {
  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: CommunityNavBar(selected: 'parents-my-post'),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              PostCard(),
              PostCard(),
              PostCard(),
              PostCard(),
            ],
          ),
        ));
  }
}