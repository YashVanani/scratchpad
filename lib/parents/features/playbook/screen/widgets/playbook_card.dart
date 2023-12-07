import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayBookCard extends StatelessWidget {
  PlayBookCard({
    super.key,
    required this.playbook,
  });
  Playbook playbook;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
     GoRouter.of(context).pushNamed("parents-playbook-detail",extra: playbook);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Color(0xffF2F4F7),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(playbook.title ?? "",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Icon(
                      Icons.star,
                      color:playbook.isActive??false?Colors.yellow: Colors.grey,
                    ),
                  ]),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                 playbook.desc ?? "",maxLines: 7,overflow:TextOverflow.ellipsis,),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Focus area",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        ...(playbook.focusAreas??[]).take(2).map((e) => Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text(e,style: TextStyle(fontSize: 12),))).toList(),
                        ((playbook.focusAreas??[]).length - 2)!=0?Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text('+${(playbook.focusAreas??[]).length - 2}')):SizedBox(),
                    ],)
                  ],
                )),
                Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16, ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Effort level:",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                          Icon(Icons.crisis_alert,color: playbook.effortLevel=='Easy'?Color(0xff16B364):playbook.effortLevel=='Medium'?Colors.orange:Colors.red,size: 16,),
                          SizedBox(width: 5,),
                          Text(playbook.effortLevel??"Easy",style: TextStyle(color: playbook.effortLevel=='Easy'?Color(0xff16B364):playbook.effortLevel=='Medium'?Colors.orange:Colors.red),),
                          ],)
                  ],
                )),
                SizedBox(height:12,),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black,width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow,color: Colors.white,),
                        SizedBox(width: 5,),
                        Text("READ DETAIL",style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
