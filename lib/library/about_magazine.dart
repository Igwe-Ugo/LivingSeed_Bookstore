import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';

class AboutMagazine extends StatelessWidget {
  final MagazineModel magazine;

  const AboutMagazine({super.key, required this.magazine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      icon: const Icon(
                        Iconsax.arrow_left_2,
                        size: 17,
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        magazine.magazineTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Playfair'),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 130,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(magazine.coverImage),
                            )),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        NotificationProvider notificationId = NotificationProvider();

                  NotificationProvider.showNotification(
                      id: notificationId.getNextId(),
                      title: 'Magazine Added to cart',
                      body:
                          "The Magazine with the name ${magazine.magazineTitle} has been added to your cart"
                              .substring(0, 5));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        minimumSize: const Size(10, 60),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '₦ ${magazine.price.toString()}',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '|',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                          SizedBox(width: 20),
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Add to Cart',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18.0,
                                  color: Colors.white),
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(magazine.magazineTitle,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(magazine.subTitle,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).disabledColor)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(magazine.issue,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).disabledColor)),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                      color: Theme.of(context).disabledColor.withOpacity(0.4),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(magazine.publisher,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    Text(magazine.issue,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Editor's Desk",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        )),
                    Text(magazine.editorsDesk.editor,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Contents",
                        style: Theme.of(context).textTheme.titleLarge),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: magazine.contents.length,
                      itemBuilder: (context, index) {
                        var chapters = magazine.contents[index];
                        return Container(
                          margin: const EdgeInsets.all(7),
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13.0, horizontal: 10),
                              child: ListTile(
                                isThreeLine: true,
                                horizontalTitleGap: 0,
                                minLeadingWidth: 25,
                                contentPadding: EdgeInsets.all(0),
                                leading:
                                    Text(chapters.chapterNumber.toString()),
                                title: Text(chapters.chapterTitle,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(chapters.chapterAuthor),
                              )),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
