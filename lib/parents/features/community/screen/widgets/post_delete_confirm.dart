import 'package:clarified_mobile/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PostDeleteConfirm extends StatelessWidget {
  const PostDeleteConfirm({
    super.key,
  });

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
                  Text('Are you sure to delete this post from community?',textAlign: TextAlign.center,),
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
            },child: Text("Cancel",style: TextStyle(color: greyTextColor),)),
            InkWell(onTap: (){
              context.pop();
            },child: Text("Delete",style: TextStyle(color: Colors.red),)),
          ]),
                  ]),
          ),
        );
      },
    );
  }
}
