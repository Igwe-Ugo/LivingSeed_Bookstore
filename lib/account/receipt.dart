import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:livingseed_media/models/widget.dart';
import 'package:printing/printing.dart';

class Receipt extends StatelessWidget {
  final Users user;
  final TransactionHistory transactionHistory;
  const Receipt(
      {super.key, required this.user, required this.transactionHistory});

  @override
  Widget build(BuildContext context) {
    double total = transactionHistory.description
        .fold(0, (sum, item) => sum + item.totalCost);
    /* double discount = 0.0; // You can add discount logic if needed
    double tax = 0.0; // You can add tax logic if needed
    double total = subtotal - discount + tax; */

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Iconsax.arrow_left_2,
              size: 17,
            )),
        title: Text(
          transactionHistory.transactionTitle,
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image:
                                AssetImage('assets/icons/LSeed-Logo-1.png'))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Receipts',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                      Text(
                        'Receipt No: ${transactionHistory.receiptNo}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                      ),
                      Text(
                        'Receipt Date: ${transactionHistory.transactionDate}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                      ),
                      Text(
                        'Receipt Time: ${transactionHistory.transactionTime}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('From'.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                      Text(
                        'peace house publications'.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        'Peace House, P.O.Box 971',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                      ),
                      Text(
                        'Gboko, Benue State, Nigeria',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                      ),
                      const Text(
                        'Contact: +234 123 456 7890',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                      ),
                      Text(
                        'Email: contact@peacehouse.com',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('To'.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10)),
                      const SizedBox(height: 4),
                      Text(
                        user.fullname.toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email: ${user.emailAddress}',
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Phone: ${user.telephone}',
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 70),
              // Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildReceiptTable(context),
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total Amount:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    total.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Signed Management',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      textBaseline: TextBaseline.ideographic),
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  _generateAndSavePdf(context, user, transactionHistory);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.download_outlined,
                        size: 30,
                      ),
                      Text(
                        'Download PDF',
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Thank you for your purchase!',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'For any inquiries, please contact our support team',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptTable(BuildContext context) {
    return DataTable(
        headingRowHeight: 40,
        dataRowHeight: 75,
        headingTextStyle: TextStyle(
            fontFamily: 'Playfair', fontSize: 17, fontWeight: FontWeight.bold),
        headingRowColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
        columns: const [
          DataColumn(
              label: Text('Description',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('Unit', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: transactionHistory.description
            .map((item) => _buildTableRow(
                item.bookName,
                item.unitCost.toString(),
                item.quantity.toString(),
                item.totalCost.toString()))
            .toList());
  }

  DataRow _buildTableRow(
      String desc, String unitCost, String qty, String totalCost) {
    return DataRow(cells: [
      DataCell(Text(desc)),
      DataCell(Text(unitCost)),
      DataCell(Text(qty)),
      DataCell(Text(totalCost)),
    ]);
  }

  Future<void> _generateAndSavePdf(
      BuildContext context, Users user, TransactionHistory history) async {
    final pdf = pw.Document();

    final total =
        history.description.fold(0.0, (sum, item) => sum + item.totalCost);

    // Create a list of PDF TableRow widgets
    final List<pw.TableRow> tableRows = [
      pw.TableRow(
        children: [
          pw.Text('Description',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Unit', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
      // Add data rows
      ...history.description.map((item) {
        return pw.TableRow(children: [
          pw.Text(item.bookName, style: const pw.TextStyle(fontSize: 10)),
          pw.Text('\$${item.unitCost.toStringAsFixed(2)}',
              style: const pw.TextStyle(fontSize: 10)),
          pw.Text(item.quantity.toString(),
              style: const pw.TextStyle(fontSize: 10)),
          pw.Text('\$${item.totalCost.toStringAsFixed(2)}',
              style: const pw.TextStyle(fontSize: 10)),
        ]);
      }),
    ];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pageContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  history.transactionTitle,
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),

              // Transaction Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Customer: ${user.fullname}'),
                  pw.Text('Receipt No: ${history.receiptNo}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date: ${history.transactionDate}'),
                  pw.Text('Time: ${history.transactionTime}'),
                ],
              ),

              pw.SizedBox(height: 20),

              // Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: const {
                  0: pw.FlexColumnWidth(3), // Description
                  1: pw.FlexColumnWidth(1.5), // Unit
                  2: pw.FlexColumnWidth(1), // Qty
                  3: pw.FlexColumnWidth(1.5), // Total
                },
                children: tableRows,
              ),

              pw.SizedBox(height: 20),

              // Totals
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Subtotal: \$${total.toStringAsFixed(2)}'),
                    pw.Divider(),
                    pw.Text(
                      'TOTAL: \$${total.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 40),
              pw.Center(
                child: pw.Text('Thank you for your purchase!',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF using the printing package
    final Uint8List bytes = await pdf.save();

    // Use the printing package's save/share functionality
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'receipt_${history.receiptNo}.pdf',
    );

    // Optionally show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Receipt ${history.receiptNo} downloaded and shared successfully!')),
    );
  }
}
