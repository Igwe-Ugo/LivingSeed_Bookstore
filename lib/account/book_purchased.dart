import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/widget.dart';

class BookPurchased extends StatelessWidget {
  final Users user;
  const BookPurchased({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).pop();
            },
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            )),
        title: const Text(
          'Books Purchased',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: user.bookPurchased.length,
        itemBuilder: (context, index) {
          return user != null && user.bookPurchased.isNotEmpty
              ? _booksPurchasedItems(context, user.bookPurchased[index])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                      SizedBox(
                        height: 30,
                      ),
                      Icon(
                        Icons.history_edu_outlined,
                        size: 100,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Transactions made! Every Transaction history appears here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ]);
        },
      ),
    );
  }
}

Container _booksPurchasedItems(
    BuildContext context, PurchasedBooksItems bookPurchased) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: MediaQuery.of(context).size.width,
    child: Card(
      elevation: 0,
      child: InkWell(
        onTap: () => ReadBook(bookUrl: bookPurchased.readBookPath),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Image.asset(
                  bookPurchased.coverImage,
                  height: 70,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookPurchased.bookTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    bookPurchased.bookAuthor,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ReadBook extends StatelessWidget {
  final String bookUrl;
  const ReadBook({super.key, required this.bookUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.asset(bookUrl),
    );
  }
}
