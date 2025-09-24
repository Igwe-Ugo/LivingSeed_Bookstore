import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../common/widget.dart';
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
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(
            Iconsax.arrow_left_2,
            size: 17,
          ),
        ),
        title: const Text(
          'Books Purchased',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: user.bookPurchased.isNotEmpty
          ? ListView.builder(
              itemCount: user.bookPurchased.length,
              itemBuilder: (context, index) {
                return _booksPurchasedItems(context, user.bookPurchased[index]);
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.book_outlined,
                    size: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No books purchased!\nEvery purchased book appears here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget _booksPurchasedItems(
    BuildContext context, PurchasedBooksItems bookPurchased) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: MediaQuery.of(context).size.width,
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {

          //Navigate to the ReadBook page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PdfReaderScreen(bookPurchased: bookPurchased),
            ),
          );
        },
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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookPurchased.bookTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bookPurchased.bookAuthor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class PdfReaderScreen extends StatefulWidget {
  final PurchasedBooksItems bookPurchased;
  const PdfReaderScreen({super.key, required this.bookPurchased});

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  bool _showFab = true;
  bool _showThumbnails = false;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  void _toggleFabVisibility(bool visible) {
    if (_showFab != visible) {
      setState(() {
        _showFab = !_showFab;
      });
    }
  }

  void _toggleThumbnails(){
    setState(() {
      _showThumbnails = !_showThumbnails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            ),
          ),
          title: Text(
            widget.bookPurchased.bookTitle,
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.view_sidebar_outlined),
                onPressed: () => _toggleThumbnails(),),
                IconButton(
              onPressed: () {
                if (widget.bookPurchased != null) {
                  GoRouter.of(context).go(
                      '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.booksPurchasedPath}/${LivingSeedMediaRouter.writeReviewPath}',
                      extra: widget.bookPurchased);
                }
              },
              icon: const Icon(Iconsax.edit_2),
            ),
          ],
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: _showFab ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            FloatingActionButton(
              heroTag: "ZoomIn",
              mini: true,
              child: const Icon(Icons.zoom_in),
              onPressed: () {
                _pdfViewerController.zoomLevel =
                    (_pdfViewerController.zoomLevel + 0.25).clamp(1.0, 5.0);
              },
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "ZoomOut",
              mini: true,
              child: const Icon(Icons.zoom_out),
              onPressed: () {
                _pdfViewerController.zoomLevel =
                    (_pdfViewerController.zoomLevel - 0.25).clamp(1.0, 5.0);
              },
            ),
          ]),
        ),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward ||
                notification.direction == ScrollDirection.reverse) {
              _toggleFabVisibility(false);
            } else if (notification.direction == ScrollDirection.idle) {
              _toggleFabVisibility(true);
            }
            return true;
          },
          child: Stack(
            children: [
              SfPdfViewer.asset(
                  widget.bookPurchased.readBookPath,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                ),

              // sidebar with thumbnails
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: 0,
                left: _showThumbnails ? 0 : -MediaQuery.of(context).size.width,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      // close button
                      AppBar(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        elevation: 0,
                        leading: IconButton(onPressed: _toggleThumbnails, icon: const Icon(Icons.close, color: Colors.white,)),
                        title: const Text("Thumbnails", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Playfair"),),
                      ),

                      // thumbsnails list
                      /* Expanded(
                        child: Builder(
                          builder: (context) {
                            final totalPages = _pdfViewerController.pageCount;
                            if (totalPages == 0) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return PdfThumbnailGrid(pdfPath: widget.bookPurchased.readBookPath);
                          },
                        ),
                      ), */
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      );
  }
}
