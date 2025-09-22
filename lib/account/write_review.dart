import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/models/widget.dart';

class WriteReview extends StatefulWidget {
  final PurchasedBooksItems bookPurchased;
  const WriteReview({super.key, required this.bookPurchased});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  List<bool> stars = [true, true, true, true, false];
  bool showWriteReviewTextField = false;
  void _onStarPressed(int index) {
    setState(() {
      for (int i = 0; i <= index; i++) {
        stars[i] = !stars[index];
      }
      if (!stars[index]) {
        for (int i = index + 1; i < stars.length; i++) {
          stars[i] = false;
        }
      }
      showWriteReviewTextField = stars.any((star) => star);
    });
  }

  List<String> titleChoices = [
    'Character Development',
    'Plot & Storyline',
    'Writing Style',
    'Pacing & flow',
    'Originality & Creativity',
    'Dialogue',
    'Humor & wit',
    'Character Relationships',
  ];
  String? selectedValue;

  void setSelectedValue(String? value) {
    setState(() => selectedValue = value);
    debugPrint(value);
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
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Submit Review',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        image: DecorationImage(
                            image: AssetImage(widget.bookPurchased.coverImage),
                            fit: BoxFit.fill)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Writing a review...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () => _onStarPressed(index),
                        icon: Icon(
                          Iconsax.star1,
                          color: stars[index]
                              ? Colors.orange.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.2),
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('What do you like the most?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                  InlineChoice<String>.single(
                    clearable: true,
                    value: selectedValue,
                    onChanged: setSelectedValue,
                    itemCount: titleChoices.length,
                    itemBuilder: (state, i) {
                      return ChoiceChip(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.7)),
                        selected: state.selected(titleChoices[i]),
                        onSelected: state.onSelected(titleChoices[i]),
                        label: Text(
                          titleChoices[i],
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Your thoughts about the book?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).disabledColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      maxLines: 7,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText:
                            'Tell others what you like (or don\'t like) about this book',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.5),
                          fontSize: 14,
                          fontFamily: 'Satoshi',
                        ),
                      ),
                    ),
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
