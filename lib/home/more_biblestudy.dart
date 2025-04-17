import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/router.dart';
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class MoreBibleStudy extends StatelessWidget {
  const MoreBibleStudy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            )),
        title: const Text(
          'All Bible Study Materials',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<BibleStudyMaterial>>(
        future: Provider.of<BibleStudyProvider>(context, listen: false)
            .bibleStudyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading books"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No books available"));
          }

          List<BibleStudyMaterial> bibleStudy = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              itemCount: bibleStudy.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two books per row
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.7, // Adjust book card size
              ),
              itemBuilder: (context, index) {
                return _buildBookItem(context, bibleStudy[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookItem(BuildContext context, BibleStudyMaterial bibleStudy) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).go(
          '${LivingSeedBookStoreRouter.homePath}/${LivingSeedBookStoreRouter.aboutBibleStudyPath}',
          extra: bibleStudy),
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
                  bibleStudy.coverImage,
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
                    bibleStudy.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    bibleStudy.subTitle,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₦ ${bibleStudy.amount.toString()}',
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
