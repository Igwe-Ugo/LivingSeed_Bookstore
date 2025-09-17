import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/widget.dart';
import 'package:livingseed_media/library/widget.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/widget.dart';
import 'package:provider/provider.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final TextEditingController _searchController = TextEditingController();
  List<AboutBooks> books = [];
  List<AboutBooks> filteredBooks = [];
  List<BibleStudyMaterial> bibleStudy = [];
  List<BibleStudyMaterial> filteredBibleStudy = [];
  List<MagazineModel> magazines = [];
  List<MagazineModel> filteredMagazine = [];
  List<String> choices = [
    'All',
    'Books',
    'Bible study guide',
    'Magazines',
  ];

  List<IconData> iconChoices = [
    Icons.all_inbox_outlined,
    Iconsax.book_1,
    Iconsax.book,
    Iconsax.document,
    Iconsax.document_1,
  ];

  String? selectedValue;

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
    debugPrint(value);
  }

  @override
  void initState() {
    super.initState();
    _loadMaterials();
    _searchController.addListener(_filterMaterials);
  }

  void _filterMaterials() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      // Filter books
      filteredBooks = books
          .where((book) =>
              book.bookTitle.toLowerCase().contains(query) ||
              book.author.toLowerCase().contains(query))
          .toList();

      // Filter Bible study materials
      filteredBibleStudy = bibleStudy
          .where((biblestudy) => biblestudy.title.toLowerCase().contains(query))
          .toList();

      // filter magazine
      filteredMagazine = magazines
          .where((mag) => mag.magazineTitle.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _loadMaterials() async {
    books = await Provider.of<BookProvider>(context, listen: false)
        .booksFuture!; // load books from json
    bibleStudy = await Provider.of<BibleStudyProvider>(context, listen: false)
        .bibleStudyFuture!;
    magazines = await Provider.of<MagazineProvider>(context, listen: false)
        .magazineFuture!;
    setState(() {
      filteredBooks = books; // initially, all books are displayed
      filteredBibleStudy = bibleStudy;
      filteredMagazine = magazines;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMaterials);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/LSeed-Logo-1.png',
                      scale: 5,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Bookstore',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextInput(
              label: 'Search for title, authors, topics...',
              controller: _searchController,
              icon: Iconsax.book_1,
              isTitleNotNecessary: true,
              maxLine: 1,
              validator: () {},
            ),
            if (_searchController.text.isEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Categories',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ),
              InlineChoice<String>.single(
                clearable: true,
                value: selectedValue,
                onChanged: setSelectedValue,
                itemCount: choices.length,
                itemBuilder: (state, i) {
                  return ChoiceChip(
                    avatar: Icon(iconChoices[i],
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                    side: const BorderSide(style: BorderStyle.none),
                    selected: state.selected(choices[i]),
                    onSelected: state.onSelected(choices[i]),
                    label: Text(
                      choices[i],
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                    ),
                  );
                },
                listBuilder: ChoiceList.createWrapped(
                  spacing: 5,
                  runSpacing: 5,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (selectedValue == 'All')
                const AllBooks()
              else if (selectedValue == 'Books')
                const Books()
              else if (selectedValue == 'Bible study guide')
                const BibleStudy()
              else if (selectedValue == 'Magazines')
                const Magazines()
              else
                const AllBooks()
            ],
            if (_searchController.text.isNotEmpty) ...[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: filteredBooks.isEmpty &&
                        filteredBibleStudy.isEmpty &&
                        filteredMagazine.isEmpty
                    ? Column(
                        children: const [
                          SizedBox(height: 20),
                          Icon(Iconsax.document_filter, size: 70),
                          SizedBox(height: 30),
                          Text(
                            "Sorry, No matching books or Bible study material found!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )
                    : ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ...filteredBooks
                              .map((book) => _bookSearch(context, book)),
                          ...filteredBibleStudy.map(
                              (study) => _bibleStudySearch(context, study)),
                          ...filteredMagazine
                              .map((mag) => _magazineSearch(context, mag))
                        ],
                      ),
              ),
            ]
          ],
        ),
      ),
    ));
  }
}

Column _bookSearch(BuildContext context, AboutBooks book) {
  return Column(
    children: [
      InkWell(
        onTap: () => GoRouter.of(context).go(
            '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutBookPath}',
            extra: book),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Image.asset(
                      book.coverImage,
                    ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.bookTitle,
                            maxLines: 2,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            book.author,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14.0),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'N${book.amount.toString()}',
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
      const Divider(
        thickness: 0.4,
      )
    ],
  );
}

Widget _bibleStudySearch(BuildContext context, BibleStudyMaterial study) {
  return Column(
    children: [
      InkWell(
        onTap: () => GoRouter.of(context).go(
          '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutBibleStudyPath}',
          extra: study,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Image.asset(
                      study.coverImage,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        study.title,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Text(
                        study.subTitle,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14.0),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'N${study.amount.toString()}',
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
      const Divider(thickness: 0.4),
    ],
  );
}

Widget _magazineSearch(BuildContext context, MagazineModel magazine) {
  return Column(
    children: [
      InkWell(
        onTap: () => GoRouter.of(context).go(
          '${LivingSeedMediaRouter.libraryPath}/${LivingSeedMediaRouter.aboutMagazinePath}',
          extra: magazine,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Image.asset(
                      magazine.coverImage,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        magazine.magazineTitle,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Text(
                        magazine.subTitle,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14.0),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'N${magazine.price.toString()}',
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
      const Divider(thickness: 0.4),
    ],
  );
}
