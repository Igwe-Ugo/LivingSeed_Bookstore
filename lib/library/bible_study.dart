// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class BibleStudy extends StatelessWidget {
  const BibleStudy({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<BibleStudyProvider>(context, listen: false)
          .bibleStudyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading books"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No books found"));
        }
        List<BibleStudyMaterial> bibleStudy = snapshot.data!;
        return Column(
          children: bibleStudy
              .map((bibleStudy) =>
                  buildBibleStudy(context, bibleStudy: bibleStudy))
              .toList(),
        );
      },
    );
  }

  Widget buildBibleStudy(BuildContext context,
      {required BibleStudyMaterial bibleStudy}) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => GoRouter.of(context).go(
              '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutBibleStudyPath}',
              extra: bibleStudy),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: ImageFileAuth(fileImage: bibleStudy.coverImage, imageHeight: 100, imageWidth: 80),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bibleStudy.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              bibleStudy.subTitle,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'N${bibleStudy.amount.toString()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                            ),
                          ],
                        ),
                      ),
                    ],
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
