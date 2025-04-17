import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class WriteReview extends StatefulWidget {
  const WriteReview({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      icon: const Icon(
                        Iconsax.arrow_left_2,
                        size: 17,
                      )),
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
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                    ),
                    child: Container(
                      width: 130,
                      height: 200,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/becoming_like_jesus.png'),
                              fit: BoxFit.fill)),
                    ),
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
