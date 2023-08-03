import 'package:flutter/material.dart';

// Widget to display payment options
class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String? _selectedPaymentMethod = 'American Express';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Payments'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Text(
                "Select your payment type",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            RadioListTile<String>(
              title: const Text('Visa Credit Card'),
              value: 'Visa Credit Card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            RadioListTile<String>(
              title: const Text('American Express'),
              value: 'American Express',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            RadioListTile<String>(
              title: const Text('MasterCard'),
              value: 'MasterCard',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            RadioListTile<String>(
              title: const Text('AfterPay'),
              value: 'AfterPay',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            RadioListTile<String>(
              title: const Text('Zip'),
              value: 'Zip',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            RadioListTile<String>(
              title: const Text('Bank Transfer'),
              value: 'Bank Transfer',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle the payment method selection here
            Navigator.of(context).pop(_selectedPaymentMethod);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
