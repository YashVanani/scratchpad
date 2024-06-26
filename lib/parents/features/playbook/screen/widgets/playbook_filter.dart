import 'package:clarified_mobile/consts/colors.dart';
import 'package:flutter/material.dart';

class PlayBookFilter extends StatelessWidget {
  PlayBookFilter({
    super.key,
    required this.domain,
    required this.developmentalStage,
  });
  List<String> domain;
  List<String> developmentalStage;
  String selectedDomain = 'All';
  String selectedDevelopmentalStage = 'All';
  String selectedEffortLevel = 'All';
  @override
  Widget build(BuildContext context) {
    if(!domain.contains('All')){
      domain.add('All');
    }
    if(!developmentalStage.contains('All')){
      developmentalStage.add('All');
    }
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color:  Colors.white,),
            child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight:
                              Radius.circular(20)),
                      color: Color(0xffF2F4F7),
                    ),
                    child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Text(
                            'Filter',
                            style: TextStyle(
                                color: greenTextColor),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: const Color.fromARGB(
                                  255, 129, 111, 111),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0),
                    child: Text(
                      "Domain",
                      style: TextStyle(
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1),
                    ),
                    child: DropdownButton(
                      underline: SizedBox(),
                      isExpanded: true,
                      items:domain.map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (v) {
                        state(() {
                          selectedDomain = v.toString();
                        });
                      },
                      value: selectedDomain,
                    ),
                  ),
                SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0),
                    child: Text(
                      "Developmental Stage",
                      style: TextStyle(
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1),
                    ),
                    child: DropdownButton(
                      underline: SizedBox(),
                      isExpanded: true,
                      items: developmentalStage.map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (v) {
                        state(() {
                          selectedDevelopmentalStage = v.toString();
                        });
                      },
                      value: selectedDevelopmentalStage,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0),
                    child: Text(
                      "Effort Level",
                      style: TextStyle(
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1),
                    ),
                    child: DropdownButton(
                      underline: SizedBox(),
                      isExpanded: true,
                      items: ['All', 'Easy', 'Medium', 'Highest']
                          .map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (v) {
                        state(() {
                          selectedEffortLevel = v.toString();
                        });
                      },
                      value: selectedEffortLevel,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                     padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            state(() {
                          selectedEffortLevel ='All';
                          selectedDevelopmentalStage='All';
                          selectedDomain='All';
                        });
                          },
                          child: Container(
                           
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xffFECDCA).withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                                border: Border.all(
                                    color: Color(0xffF04438),
                                    width: 1)),
                            child: Row(
                              children: [
                                Icon(Icons.filter_alt,color: Color(0xffF04438),),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Reset",style: TextStyle(color:  Color(0xffF04438),fontWeight: FontWeight.w500),)
                              ],
                            ),
                          
                          ),
                        ),
                  
                           InkWell(
                            onTap: () {
                              Navigator.pop(context,[selectedDomain,selectedDevelopmentalStage,selectedEffortLevel]);
                            },
                          child: Container(
                          
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10),
                            decoration: BoxDecoration(
                              color:greenTextColor,
                                borderRadius:
                                    BorderRadius.circular(
                                        10),
                                border: Border.all(
                                    color:greenTextColor,
                                    width: 1)),
                            child: Row(
                              children: [
                                Icon(Icons.sort_sharp,color:whiteColor,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Apply",style: TextStyle(color: whiteColor,fontWeight: FontWeight.w500),)
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
