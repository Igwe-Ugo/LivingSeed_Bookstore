import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_bookstore/common/widget.dart';
import 'package:livingseed_bookstore/models/widget.dart';

class TransactionHistoryList extends StatelessWidget {
  final Users user;
  const TransactionHistoryList({super.key, required this.user});

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
          'My Transaction History',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: user.transactionHistory.length,
        itemBuilder: (context, index) {
          return user != null && user.transactionHistory.isNotEmpty
              ? _transactionHistoryItems(
                  context, user.transactionHistory[index], user, index)
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

Container _transactionHistoryItems(
    BuildContext context, TransactionHistory history, Users user, int index) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: MediaQuery.of(context).size.width,
    child: Card(
      elevation: 0,
      child: InkWell(
        onTap: () => GoRouter.of(context).go(
            '${LivingSeedMediaRouter.accountPath}/${LivingSeedMediaRouter.transactionHistoryPath}/${LivingSeedMediaRouter.transactionDescriptionPath}',
            extra: {
              'user': user,
              'transactionHistory': user.transactionHistory[index]
            }),
        child: Padding(
          padding: const EdgeInsets.all(15),
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
