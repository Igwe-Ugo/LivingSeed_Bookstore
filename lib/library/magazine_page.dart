import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';

class MagazinePage extends StatelessWidget {
  final MagazineModel aboutMagazine;
  const MagazinePage({super.key, required this.aboutMagazine});

  @override
  Widget build(BuildContext context) {
    return _bookGridView(context);
  }

  Widget _bookGridView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (aboutMagazine != null) {
          GoRouter.of(context).go(
              '${LivingSeedRouter.libraryPath}/${LivingSeedRouter.aboutMagazinePath}',
              extra: aboutMagazine);
        } else {
          // Handle the case where aboutMagazine is null, if necessary
          // For example, show a message or do nothing
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 130,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          children: [
            ImageFileAuth(
                fileImage: aboutMagazine.coverImage,
                imageHeight: 170,
                imageWidth: double.infinity),
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aboutMagazine.magazineTitle,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    aboutMagazine.issue,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
