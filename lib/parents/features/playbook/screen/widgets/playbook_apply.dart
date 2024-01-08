import 'package:clarified_mobile/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayBookApply extends ConsumerStatefulWidget {
  PlayBookApply({super.key, required this.classId});

  List<String> classId;
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>_PlayBookApplyState();

}

class _PlayBookApplyState extends ConsumerState<PlayBookApply> {
  DateTime? selectedDate = null;
  String? selectedClass = null;
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return AlertDialog(
          scrollable: true,
          iconPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: Colors.white,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Color(0xffF2F4F7),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Apply Strategy',
                        style: TextStyle(color: greenTextColor),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: const Color.fromARGB(255, 129, 111, 111),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Class",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: DropdownButton(
                  underline: SizedBox(),
                  hint: Text("Select Class"),
                  isExpanded: true,
                  items: widget.classId.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (v) {
                    state(() {
                      selectedClass = v.toString();
                    });
                  },
                  value: selectedClass,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Select Start Date",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365 * 3)));

                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    child: Row(
                      children: [
                        Text(selectedDate == null
                            ? "DD-MM-YYYY"
                            : "${selectedDate?.day}-${selectedDate?.month}-${selectedDate?.year}"),
                        Spacer(),
                        Icon(
                          Icons.calendar_month,
                          color: greenTextColor,
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
             
               Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    child:TextField(
                      maxLines: 5,
                      minLines: 2,
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your message",
                      ),
                    )),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // state(() {
                        //   selectedEffortLevel ='All';
                        //   selectedDevelopmentalStage='All';
                        //   selectedDomain='All';
                        // });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: Color(0xffFECDCA).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Color(0xffF04438), width: 1)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.filter_alt,
                              color: Color(0xffF04438),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Reset",
                              style: TextStyle(
                                  color: Color(0xffF04438),
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: greenTextColor,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: greenTextColor, width: 1)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sort_sharp,
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Apply",
                              style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
// class PlayBookApply extends StatelessWidget {
//   PlayBookApply({
//     super.key,
//     required this.classId
//   });
//   String? selectedClass = null;
//   List<String> classId;
//   DateTime? selectedDate= null;
//   @override
//   Widget build(BuildContext context) {
    
//     return StatefulBuilder(
//       builder: (context, state) {
//         return AlertDialog(
//           scrollable: true,
          
//           iconPadding: EdgeInsets.zero,
//           contentPadding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(
//                   Radius.circular(20.0))),
//           backgroundColor: Colors.white,
//           content: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                       color:  Colors.white,),
//             child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight:
//                               Radius.circular(20)),
//                       color: Color(0xffF2F4F7),
//                     ),
//                     child: Row(
//                         mainAxisAlignment:
//                             MainAxisAlignment
//                                 .spaceBetween,
//                         children: [
//                           Text(
//                             'Apply Strategy',
//                             style: TextStyle(
//                                 color: greenTextColor),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Icon(
//                               Icons.close,
//                               color: const Color.fromARGB(
//                                   255, 129, 111, 111),
//                             ),
//                           ),
//                         ]),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
                  
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0),
//                     child: Text(
//                       "Class",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(
//                         horizontal: 16),
//                     padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
//                     decoration: BoxDecoration(
//                       borderRadius:
//                           BorderRadius.circular(10),
//                       border: Border.all(
//                           color: Colors.grey.shade400,
//                           width: 1),
//                     ),
//                     child: DropdownButton(
//                       underline: SizedBox(),
//                       isExpanded: true,
//                       items: classId
//                           .map((e) {
//                         return DropdownMenuItem(
//                           child: Text(e),
//                           value: e,
//                         );
//                       }).toList(),
//                       onChanged: (v) {
//                         state(() {
//                           selectedClass = v.toString();
//                         });
//                       },
//                        value: selectedClass,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0),
//                     child: Text(
//                       "Select Start Date",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                    InkWell(
//                       onTap: ()async{
//                          final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate:  DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 365*3))
//     );

//     if (picked != null && picked != selectedDate) {
//       state(){
//   selectedDate = picked;
//       }
      
      
//     }
//                       },
//                      child: Container(
//                       margin: EdgeInsets.symmetric(
//                           horizontal: 16),
//                       padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
//                       decoration: BoxDecoration(
//                         borderRadius:
//                             BorderRadius.circular(10),
//                         border: Border.all(
//                             color: Colors.grey.shade400,
//                             width: 1),
//                       ),
//                       child: Row(children: [
//                         Text(selectedDate==null?"DD-MM-YYYY":"${selectedDate?.day}-${selectedDate?.month}-${selectedDate?.year}"),
//                         Spacer(),
//                         Icon(Icons.calendar_month,color: greenTextColor,)
//                       ],) ),
//                    ),
                  
//                   Padding(
//                      padding: EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                           onTap: (){
//                             // state(() {
//                         //   selectedEffortLevel ='All';
//                         //   selectedDevelopmentalStage='All';
//                         //   selectedDomain='All';
//                         // });
//                           },
//                           child: Container(
                           
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10),
//                             decoration: BoxDecoration(
//                               color: Color(0xffFECDCA).withOpacity(0.2),
//                                 borderRadius:
//                                     BorderRadius.circular(
//                                         10),
//                                 border: Border.all(
//                                     color: Color(0xffF04438),
//                                     width: 1)),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.filter_alt,color: Color(0xffF04438),),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text("Reset",style: TextStyle(color:  Color(0xffF04438),fontWeight: FontWeight.w500),)
//                               ],
//                             ),
                          
//                           ),
//                         ),
                  
//                            InkWell(
//                             onTap: () {
//                               Navigator.pop(context,);
//                             },
//                           child: Container(
                          
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10),
//                             decoration: BoxDecoration(
//                               color:greenTextColor,
//                                 borderRadius:
//                                     BorderRadius.circular(
//                                         10),
//                                 border: Border.all(
//                                     color:greenTextColor,
//                                     width: 1)),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.sort_sharp,color:whiteColor,),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text("Apply",style: TextStyle(color: whiteColor,fontWeight: FontWeight.w500),)
//                               ],
//                             ),
                          
//                           ),
//                         )
                     
//                       ],
//                     ),
//                   )
//                 ]),
//           ),
//         );
//       },
//     );
//   }
// }
