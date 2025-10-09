import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/common/router.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:livingseed_media/services/users_services.dart';
import 'package:provider/provider.dart';

class TransactionHistoryList extends StatelessWidget {
  const TransactionHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    // Correctly check if the transaction history is empty right at the start.
    return Consumer<UsersAuthProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.userData;
        final hasTransactions = user!.transactionHistory.isNotEmpty;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
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
              'My Transaction History',
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Use a ternary operator on the body to decide which widget to display.
          body: hasTransactions
              ? ListView.builder(
                  itemCount: user.transactionHistory.length,
                  itemBuilder: (context, index) {
                    // If we reach here, we know the list is not empty, so we safely build the item.
                    return _transactionHistoryItems(
                        context, user.transactionHistory[index], user, index);
                  },
                )
              : const Center(
                  // Display this only if hasTransactions is false.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.receipt,
                        size: 70,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No Recent Transactions to be reviewed",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
        );
      }
    );
  }
}

// Function to build individual transaction history items
Widget _transactionHistoryItems(
    BuildContext context, TransactionHistory history, Users user, int index) {
  return GestureDetector(
    onTap: () {
      GoRouter.of(context).go(
        '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.transactionHistoryPath}/${LivingSeedMediaRouter.receiptPath}',
      );
    },
    child: Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                history.transactionTitle,
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
                "Receipt Number: ${history.receiptNo}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    history.transactionDate,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
                  ),
                  Text(
                    history.transactionTime,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
                  )
                ],
              ),
              Center(
                  child: Text(
                'Tap to display or download receipt',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ))
            ],
          ),
        ),
      ),
    ),
  );
}
