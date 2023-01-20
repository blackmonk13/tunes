import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tunes/components/context_utils.dart';

class FindSongs extends StatelessWidget {
  const FindSongs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      transitionBackgroundColor: context.colorScheme.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: context.screenHeight * .15,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: const [
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 24.0,),
                        hintText: "Find Songs",
                        prefixIcon: Icon(Icons.search)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
