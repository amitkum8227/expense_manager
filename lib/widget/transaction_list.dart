import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
        return Column(
          children: [
            Text(
              'no transaction yet',
              style: Theme
                  .of(context)
                  .textTheme
                  .title,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: constraints.maxHeight * 0.6,
                child: Image.asset(
                  'assests/images/waiting.png',
                  fit: BoxFit.cover,
                )),
          ],
        );
      })
          : ListView.builder(
        itemBuilder: (ctx, index) {
          return TransactionItem(transaction: transactions[index], deleteTx: deleteTx);
        },
        itemCount: transactions.length,
      ),
    );
  }
}

