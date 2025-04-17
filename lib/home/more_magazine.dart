import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/router.dart';
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MoreMagazine extends StatelessWidget {
  const MoreMagazine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            )),
        title: const Text(
          'All Magazines',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<MagazineProvider>(
        builder: (context, magazineProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: magazineProvider.magazines.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two books per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7, // Adjust book card size
              ),
              itemBuilder: (context, index) {
                return _buildBookItem(
                    context, magazineProvider.magazines[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, MagazineModel magazine) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go(
          '${LivingSeedBookStoreRouter.homePath}/${LivingSeedBookStoreRouter.aboutMagazinePath}',
          extra: magazine),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  height: 500,
                  magazine.coverImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    magazine.magazineTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    magazine.subTitle,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₦ ${magazine.price.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
