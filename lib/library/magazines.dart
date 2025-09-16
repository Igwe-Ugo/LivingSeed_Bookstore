// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livingseed_bookstore/common/router.dart';
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

class Magazines extends StatelessWidget {
  const Magazines({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MagazineProvider>(
        builder: (context, magazineProvider, child) {
      return Column(
        children: magazineProvider.magazines
            .map((mag) => buildMagazine(context, magazine: mag))
            .toList(),
      );
    });
  }

  Widget buildMagazine(BuildContext context,
      {required MagazineModel magazine}) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => GoRouter.of(context).go(
                  '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutMagazinePath}'),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 100,
                          width: 80,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(magazine.coverImage))),
                        ),
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
                              magazine.magazineTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              magazine.issue,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.0),
                            ),
                            Text(
                              'N${magazine.price.toString()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12.0),
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
