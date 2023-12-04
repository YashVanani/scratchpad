import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/community_bottom_bar.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/post_success_pop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            title: const Text('Community'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                GoRouter.of(context).pushNamed("parents-home");
              },
            )),
        bottomNavigationBar: CommunityNavBar(selected: 'parents-create-post'),
        body:  SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              InkWell(
                child: Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo_outlined,size: 90,color: greyTextColor,),
                      const SizedBox(height: 10),
                      const Text('Select files to upload',style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ),
        
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Type Caption...',
                        border: InputBorder.none,
                      
                      ),
                      maxLines: 6,
                      minLines: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.emoji_emotions_outlined,color: greyTextColor,),
                        InkWell(onTap: (){
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const PostSuccessPop();
                            });
                        },
                        child: Icon(Icons.send_outlined,color: greenTextColor,))
                      ],
                    )
                   ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}