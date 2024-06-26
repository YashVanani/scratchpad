import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:clarified_mobile/teachers/model/playbook.dart';
import 'package:clarified_mobile/teachers/model/teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class PlayBookTeacherCard extends ConsumerWidget{
   PlayBookTeacherCard({
    super.key,
    required this.playbook,
  });
  Playbook playbook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  // return Placeholder();
  // }
    return InkWell(
      onTap: () {
     GoRouter.of(context).pushNamed("teachers-playbook-detail",extra: playbook);
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Text(playbook.title?.toJson()[Localizations.localeOf(context).languageCode],
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                      Row(children: [  
                    //     InkWell(
                    //       onTap: (){
                    //         print("++++${playbook.id}");
                    //         if( ref.read(favoriteActivityState.notifier).state.contains(playbook.id)??false){
                              
                    //           print("+++Re=mpved");
                    //            ref.read(favoriteActivityState.notifier).state.remove(playbook.id);
                    //         }else{
                    //           print("+++ADDED");
                    //            ref.read(favoriteActivityState.notifier).state.add(playbook.id??"");
                    //         }
                    //         ref.refresh(updatedFavoriteActivityProvider);
                            
                    //       },
                    //       child: Icon(
                    //   Icons.favorite,
                    //   color:ref.read(favoriteActivityState.notifier).state.contains(playbook.id)??false?Colors.red: Colors.grey,
                    // ),
                    //     ),
                        SizedBox(width: 10,),
                    InkWell(
                      onTap:(){
                           if( ref.read(teacherFavoriteActivityState.notifier).state.contains(playbook.id)??false){
                              
                              print("+++Re=mpved");
                               ref.read(teacherFavoriteActivityState.notifier).state.remove(playbook.id);
                            }else{
                              print("+++ADDED");
                               ref.read(teacherFavoriteActivityState.notifier).state.add(playbook.id??"");
                            }
                            ref.refresh(updatedFavoriteActivityTeacherProvider);
                             ref.refresh(teacherPlaybookProvider);
                          
                      },
                      child:Icon(
                      Icons.star,
                      color:ref.read(teacherFavoriteActivityState.notifier).state.contains(playbook.id)??false?Colors.yellow: Colors.grey,
                    )
                    ),],)
                  ]),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                 playbook.desc?.toJson()[Localizations.localeOf(context).languageCode],maxLines: 7,overflow:TextOverflow.ellipsis,),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Focus area",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                       width: MediaQuery.of(context).size.width*0.59,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        runSpacing: 5,
                        spacing: 5,
                        children: [
                          ...(playbook.focusAreas??[]).take(2).map((e) => Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text(e?.toJson()[Localizations.localeOf(context).languageCode],style: TextStyle(fontSize: 12),))).toList(),
                          ((playbook.focusAreas??[]).length - 2)!=0?Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text('+${(playbook.focusAreas??[]).length - 2}')):SizedBox(),
                      ],),
                    )
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
                          Icon(Icons.crisis_alert,color: playbook.effortLevel?.en=='Easy'?Color(0xff16B364):playbook.effortLevel?.en=='Medium'?Colors.orange:Colors.red,size: 16,),
                          SizedBox(width: 5,),
                          Text(playbook.effortLevel?.toJson()[Localizations.localeOf(context).languageCode]??"Easy",style: TextStyle(color: playbook.effortLevel?.en=='Easy'?Color(0xff16B364):playbook.effortLevel?.en=='Medium'?Colors.orange:Colors.red),),
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

// 
    // WidgetsBinding.instance.addPostFrameCallback((_) async {}); 