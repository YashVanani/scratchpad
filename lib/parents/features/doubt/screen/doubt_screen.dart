import 'package:clarified_mobile/parents/features/doubt/screen/doubt_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class DoubtScreen extends StatefulWidget {
  @override
  _DoubtScreenState createState() => _DoubtScreenState();
}

class _DoubtScreenState extends State<DoubtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Subjects'),
      actions: [
        Text("Grade VII",style: TextStyle(color: Color(0xffEF6820)),),
        SizedBox(width: 10,),
      ],
      ),
      body: ListView(
        children: [
          SubjectCard(),
          SubjectCard(),
          SubjectCard(),
          SubjectCard(),
        ],
      )
    );
  }
}

class SubjectCard extends ConsumerWidget {
  const SubjectCard({
    super.key,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return InkWell(
      onTap: (){
        // GoRouter.of(context).pushNamed('parents-doubt-details');
      Navigator.push(context, MaterialPageRoute(builder: (c)=>DoubtDetailScreen()));
    
        
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 10),
        child: Row(children: [
          SvgPicture.asset('assets/svg/subject.svg',height: 30,width: 30,), 
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("English",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
            Text("16 Chapters",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),)
          ],),
          Spacer(),
          Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 14,) 
        ],),
      ),
    );
  }
}
