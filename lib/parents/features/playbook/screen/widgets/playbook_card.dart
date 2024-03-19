import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayBookCard extends ConsumerWidget{
   PlayBookCard({
    super.key,
    required this.playbook,
  });
  Playbook playbook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     var profile = ref.watch(parentProfileProvider);
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.6,
                      child: Text(playbook.title?.toJson()[Localizations.localeOf(context).languageCode] ?? "",
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
                           if( ref.read(favoriteActivityState.notifier).state.contains(playbook.id)??false){
                              
                              print("+++Re=mpved");
                               ref.read(favoriteActivityState.notifier).state.remove(playbook.id);
                            }else{
                              print("+++ADDED");
                               ref.read(favoriteActivityState.notifier).state.add(playbook.id??"");
                            }
                            ref.refresh(updatedFavoriteActivityProvider);
                            
                      },
                      child:Icon(
                      Icons.star,
                      color:ref.read(favoriteActivityState.notifier).state.contains(playbook.id)??false?Colors.yellow: Colors.grey,
                    )
                    ),],)
                  ]),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                 playbook.desc?.toJson()[Localizations.localeOf(context).languageCode] ?? "",maxLines: 7,overflow:TextOverflow.ellipsis,),
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
                      AppLocalizations.of(context)!.focus_area,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                       width: MediaQuery.of(context).size.width*0.49,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        runSpacing: 5,
                        spacing: 5,
                        children: [
                          ...(playbook.focusAreas??[]).take(2).map((e) => Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text(e?.toJson()[Localizations.localeOf(context).languageCode],style: TextStyle(fontSize: 12),))).toList(),
                          ((playbook.focusAreas??[]).length - 2)>0?Container(padding: EdgeInsets.symmetric(horizontal: 7,vertical: 4),margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color(0xffEAECF0)),child: Text('+${(playbook.focusAreas??[]).length - 2}')):SizedBox(),
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
                      AppLocalizations.of(context)!.effort_level,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                          Icon(Icons.crisis_alert,color: playbook.effortLevel=='Easy'?Color(0xff16B364):playbook.effortLevel=='Medium'?Colors.orange:Colors.red,size: 16,),
                          SizedBox(width: 5,),
                          Text(playbook.effortLevel?.toJson()[Localizations.localeOf(context).languageCode]??"Easy",style: TextStyle(color: playbook.effortLevel=='Easy'?Color(0xff16B364):playbook.effortLevel=='Medium'?Colors.orange:Colors.red),),
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
                        Text(AppLocalizations.of(context)!.read_detail,style: TextStyle(color: Colors.black),),
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