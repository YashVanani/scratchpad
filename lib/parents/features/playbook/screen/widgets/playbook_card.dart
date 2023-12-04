import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayBookCard extends StatelessWidget {
  const PlayBookCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
     GoRouter.of(context).pushNamed("parents-playbook-detail");
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
                    Text('Windows & Mirrors'),
                    Icon(
                      Icons.star,
                      color: Colors.grey,
                    ),
                  ]),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                  "It is a simple tool that can be used to both help students reflect on author, speaker, or character reflects their experiences or provides a window into people from different background."),
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
                        ...['SEL','Growth Mindset','Learning'].take(2).map((e) => Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text(e,style: TextStyle(fontSize: 12),))).toList(),
                        Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text('+${['SEL','Growth Mindset','Learning'].length - 2}')),
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
                          Icon(Icons.crisis_alert,color: Color(0xff16B364),size: 16,),
                          SizedBox(width: 5,),
                          Text("Easy",style: TextStyle(color: Color(0xff16B364)),),
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
