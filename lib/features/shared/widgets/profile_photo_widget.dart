import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePhotoWidget extends StatelessWidget {
  const ProfilePhotoWidget({
    super.key,
    required this.photoUrl,
    required this.gender,
  });

  final String? photoUrl;
  final String gender;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: CachedNetworkImage(
            imageUrl: photoUrl ?? "",
            errorWidget: (url, err, st) {
              return Image.asset(
                gender == 'male'
                    ? "assets/defalut_profile_male.png"
                    : "assets/default_profile_female.png",
              );
            }),
      ),
    );
  }
}
