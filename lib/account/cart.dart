import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/widget.dart';
import 'package:livingseed_bookstore/models/widget.dart';
import 'package:livingseed_bookstore/services/widget.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  final Users user;
  const Cart({super.key, required this.user});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late int totalCost;

  @override
  void initState() {
    super.initState();
    if (widget.user.cart.isNotEmpty) {
      totalCost = widget.user.cart
          .map((item) => item.amount.toInt())
          .reduce((a, b) => (a + b)); // sums all amount
    } else {
      totalCost = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<BookProvider>(context, listen: false).booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading books"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No books found"));
          }
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
                  'My Cart',
                  style: TextStyle(
                    fontFamily: 'Playfair',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              persistentFooterButtons: [
                widget.user.cart.isNotEmpty && widget.user.cart != null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 7),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Cart Summary',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total order cost:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    )),
                                Text('₦ $totalCost',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      GoRouter.of(context).go(
                                          '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.cartPath}/${LivingSeedMediaRouter.makePaymentPath}',
                                          extra: snapshot.data!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      minimumSize: const Size(10, 50),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        'Make Payment (₦ $totalCost)',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Payment secured by',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SvgPicture.asset(
                                        'assets/icons/paystack.svg',
                                        width: 10,
                                        height: 10),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'PayStack',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ],
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  child: Column(
                    children: [
                      Column(
                        children: widget.user != null &&
                                widget.user.cart.isNotEmpty
                            ? widget.user.cart
                                .map((item) => _cartItems(context, item))
                                .toList()
                            : [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Icon(
                                        Icons.shopify_sharp,
                                        size: 100,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Nothing in Cart Session yet, please add book to cart',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ])
                              ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.user != null && widget.user.cart.isNotEmpty
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: ListTile(
                                onTap: () => showClearItemDialog(context),
                                leading: const Icon(
                                  Iconsax.trash,
                                  color: Colors.red,
                                ),
                                title: const Text('Clear all items in cart',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red)),
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}

SizedBox _cartItems(BuildContext context, CartItems items) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).disabledColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 70,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(items.coverImage))),
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
                              items.bookTitle,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            Text(
                              items.bookAuthor,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'N ${items.amount}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                onTap: () => showRemoveItemDialog(context, items),
                leading: const Icon(Iconsax.trash),
                title: const Text('Remove from cart',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showRemoveItemDialog(BuildContext context, CartItems items) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Removing item?',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Are you sure you want to remove this item from cart?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<UsersAuthProvider>(context, listen: false)
                .removeFromCart(items.bookTitle);
            Users user = Provider.of<UsersAuthProvider>(context, listen: false)
                .userData!;
            NotificationItems newNotification = NotificationItems(
              notificationImage: items.coverImage,
              notificationTitle: 'Book added to cart',
              notificationMessage:
                  'A book with the name: ${items.bookTitle} has been removed from your cart item. Will be a great pleasure to have you include that into your cart again, because information is power. You will not want to miss out the very information you can get from it!',
              notificationDate:
                  "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
              notificationTime:
                  "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
            );
            Provider.of<NotificationProvider>(context, listen: false)
                .sendPersonalNotification(user.emailAddress, newNotification);
            Navigator.of(context).pop();
            showMessage('One item removed from Cart', context);
          },
          child: Text(
            'Remove'.toUpperCase(),
            style:
                TextStyle(fontSize: 13, color: Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'cancel'.toUpperCase(),
            style:
                TextStyle(fontSize: 13, color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    ),
  );
}

Future<void> showClearItemDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text(
        'Clearing items?',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Are you sure you want to clear all items from cart?',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<UsersAuthProvider>(context, listen: false).clearCart();
            Navigator.of(context).pop();
            showMessage('Items cleared from Cart', context);
          },
          child: Text(
            'clear'.toUpperCase(),
            style: TextStyle(fontSize: 13, color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'cancel'.toUpperCase(),
            style:
                TextStyle(fontSize: 13, color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    ),
  );
}
