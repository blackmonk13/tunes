import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class FindSongs extends StatelessWidget {
  const FindSongs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: const [
            Positioned.fill(
              child: CustomScrollView(
                slivers: <Widget>[],
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      right: 28.0,
                    ),
                    hintText: "Search",
                    suffixIconConstraints: BoxConstraints.tightFor(
                      width: 24,
                      height: 24,
                    ),
                    suffixIcon: HeroIcon(
                      HeroIcons.magnifyingGlass,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
