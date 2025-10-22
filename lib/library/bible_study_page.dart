import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_media/common/widget.dart';
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
              '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutBibleStudyPath}',
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
            ImageFileAuth(fileImage: bibleStudy.coverImage, imageHeight: 170, imageWidth: double.infinity),
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
