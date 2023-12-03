import 'package:cached_network_image/cached_network_image.dart';
import 'package:clarified_mobile/model/clazz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherBug extends ConsumerWidget {
  final String teacherId;
  const TeacherBug({
    super.key,
    required this.teacherId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final teacherData = ref.watch(teacherInfo(teacherId));

    return teacherData.when(
      data: (teacher) {
        final assetImg = Image.asset(
          teacher?.gender == 'male'
              ? "assets/defalut_profile_male.png"
              : "assets/default_profile_female.png",
        );
        return SizedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: teacher?.profileUrl == null ||
                          Uri.tryParse(teacher!.profileUrl) == null
                      ? assetImg
                      : CachedNetworkImage(
                          key: Key(teacherId),
                          cacheKey: teacherId,
                          imageUrl: teacher.profileUrl,
                          placeholder: (ctx, u) => assetImg,
                          errorWidget: (url, err, st) => assetImg,
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  teacher?.name ?? 'Unknown Teacher',
                  style: const TextStyle(
                    color: Color(0xFF1D2939),
                    fontSize: 12,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (e, st) {
        print([e, st]);
        return const SizedBox();
      },
      loading: () => const SizedBox(),
    );
  }
}
