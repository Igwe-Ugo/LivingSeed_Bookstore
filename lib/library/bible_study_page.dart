import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_media/models/widget.dart';

class BibleStudyPage extends StatelessWidget {
  final BibleStudyMaterial bibleStudy;
  const BibleStudyPage({super.key, required this.bibleStudy});

  @override
  Widget build(BuildContext context) {
    return _bookGridView(context);
  }

  Widget _bookGridView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (bibleStudy != null) {
          GoRouter.of(context).go(
              '',
              extra: bibleStudy);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 130,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: [
            Container(
              height: 170,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  color: Theme.of(context).canvasColor,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(bibleStudy.coverImage))),
            ),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bibleStudy.title,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
