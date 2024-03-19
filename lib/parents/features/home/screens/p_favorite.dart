import 'package:clarified_mobile/parents/features/playbook/screen/widgets/playbook_card.dart';
import 'package:clarified_mobile/parents/features/playbook/screen/widgets/playbook_filter.dart';
import 'package:clarified_mobile/parents/features/widgets/p_bottombar.dart';
import 'package:clarified_mobile/parents/models/parents.dart';
import 'package:clarified_mobile/parents/models/playbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final searchPlaybookState = StateProvider((_) => '');

class FavoritePlaybookScreen extends ConsumerStatefulWidget {
  const FavoritePlaybookScreen({super.key});

  @override
  ConsumerState<FavoritePlaybookScreen> createState() => _FavoritePlaybookScreenState();
}

class _FavoritePlaybookScreenState extends ConsumerState<FavoritePlaybookScreen> {

  
 @override
  Widget build(BuildContext context) {
 
    final favoriteActivity = ref.watch(favoriteActivityProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Activity"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // print("${ref.read(previousIndexNavbarProvider.notifier).state} ====");
            // GoRouter.of(context).goNamed('parents=home');
             Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: favoriteActivity.when(data: (d){
                        return ListView.builder(
                          itemCount: d.length,
                          shrinkWrap: true,
                          itemBuilder: (cnt,index){
                          return PlayBookCard(playbook: d[index]);
                        });
                      }, error: (i,j)=>Text(i.toString()), loading: ()=>SizedBox())
      
    );
  }

}
