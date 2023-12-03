import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clarified_mobile/model/user.dart';
import 'package:clarified_mobile/model/school.dart';

class Avatar {
  final String id;
  final String url;
  final String mode;
  final num price;

  const Avatar({
    required this.id,
    required this.url,
    required this.mode,
    required this.price,
  });

  factory Avatar.fromMap(Map<String, dynamic> data) {
    return Avatar(
      id: data["id"],
      url: data["url"],
      mode: data["mode"],
      price: data["price"],
    );
  }
}

final avatarListProvider = StreamProvider.autoDispose(
  (ref) {
    final schoolDoc = ref.watch(schoolDocProvider);

    return schoolDoc.collection("avatars").snapshots().map(
          (ev) => ev.docs
              .where((d) => d.exists)
              .map((e) => Avatar.fromMap(e.data()))
              .toList(),
        );
  },
);

final avatarListManagerProvider =
    AsyncNotifierProvider.autoDispose<AvatarListManager, void>(
  AvatarListManager.new,
);

class AvatarListManager extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {
    // The logic we previously had in our FutureProvider is now in the build method.
  }

  Future<void> applyAvatar({required Avatar avatar}) async {
    final userDoc = ref.read(userDocProvider);
    return userDoc.value!.update({
      "avatar": avatar.id,
      "profileUrl": avatar.url,
    });
  }

  Future<void> purchaseAvatarItem({required Avatar avatar}) async {
    final userDoc = ref.read(userDocProvider);

    return FirebaseFirestore.instance.runTransaction((trx) async {
      trx.update(userDoc.value!, {
        "unlockedAvatars": FieldValue.arrayUnion([avatar.id]),
        "balance.current": FieldValue.increment(-1 * avatar.price),
        "balance.spent": FieldValue.increment(avatar.price),
      }).set(userDoc.value!.collection("balance").doc(), {
        "type": "debit",
        "module": "avatar",
        "amount": avatar.price,
        "avatarId": avatar.id,
      });
    });
  }
}
