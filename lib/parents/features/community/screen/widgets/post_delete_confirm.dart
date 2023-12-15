import 'package:clarified_mobile/consts/colors.dart';
import 'package:clarified_mobile/parents/models/community.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostDeleteConfirm extends StatelessWidget {
   PostDeleteConfirm({
    super.key,
    required this.ref,
    required this.post,
  });
  WidgetRef ref;
  Post post;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return AlertDialog(
          scrollable: true,
          
          iconPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(20.0))),
          backgroundColor: Colors.white,
          content: Container(
            padding: EdgeInsets.symmetric( vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color:  Colors.white,),
            child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                 Center(child:  SvgPicture.asset('assets/svg/delete.svg'),),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${AppLocalizations.of(context)!.are_you_sure_to_delete_this_post_from_community}',textAlign: TextAlign.center,),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            InkWell(onTap: (){
              context.pop();
            },child: Text(AppLocalizations.of(context)!.cancel,style: TextStyle(color: greyTextColor),)),
            InkWell(onTap: (){
               deletePost(post, ref);
              context.pop();
            },child: Text(AppLocalizations.of(context)!.delete,style: TextStyle(color: Colors.red),)),
          ]),
                  ]),
          ),
        );
      },
    );
  }
}
