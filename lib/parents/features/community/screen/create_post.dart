import 'dart:io';

import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/community_bottom_bar.dart';
import 'package:clarified_mobile/parents/features/community/screen/widgets/post_success_pop.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';




class CreatePostScreen extends ConsumerWidget {
  CreatePostScreen({super.key});
  var postImageProvider = StateProvider<XFile?>((ref) => XFile(''));
  var aNumber = StateProvider((_) => 0);
final myVariableProvider = StateProvider((_) => 0);
  TextEditingController captionController = TextEditingController();
  void imageSelecter(context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // postImageProvider.s
    context.read(postImageProvider.notifier).state = image;
    //  context.read(myVariableProvider).value = 42;
    // context.read(postImageProvider).state = image;    // postImage = image;
    // postImage = image;
  }

  Future<String?> uploadImageToFirebase(XFile? postImage) async {
    if (postImage != null) {
      try {
        final String fileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        await FirebaseStorage.instance
            .ref('/community_media')
            .child(fileName)
            .putData(File(postImage!.path).readAsBytesSync());
        final String downloadURL = await FirebaseStorage.instance
            .ref('/community_media')
            .child(fileName)
            .getDownloadURL();
        return downloadURL;
      } catch (e) {
        print('Error uploading image: $e');
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user = ref.watch(parentProfileProvider);
    final postImage = ref.watch(postImageProvider);
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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
               
              InkWell(
                onTap: () {
                  imageSelecter(context);
                  //  ref.read(postImageProvider).state = image;
    
                },
                child: Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: postImage?.path.isEmpty??true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo_outlined,             size: 90,
                              color: greyTextColor,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Select files to upload',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )
                        
                      : Image.file(
                          File(postImage!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
             
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        controller: captionController,
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
                          SizedBox(),
                          InkWell(
                              onTap: () async {
                                String? img = await uploadImageToFirebase(postImage);
                                bool res = await addPost(
                                    Post(
                                        content: captionController.text,
                                        postImage: img,
                                        likedBy: [],
                                        likes: 0,
                                        postAt: Timestamp.now(),
                                        postBy: PostBy(
                                          userId: user.asData?.value.id,
                                          username: user.asData?.value.name,
                                          userAvatar:
                                              user.asData?.value.profileUrl,
                                        )),
                                    ref);
                                if (res)
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const PostSuccessPop();
                                      });
                              },
                              child: Icon(
                                Icons.send_outlined,
                                color: greenTextColor,
                              ))
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
