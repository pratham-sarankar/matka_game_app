import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../models/wallet_transaction.dart';

class MyWalletFilterDialog extends StatefulWidget {
  final double? initialMinAmount;
  final double? initialMaxAmount;
  final DateTime? initialFromDate;
  final DateTime? initialToDate;
  final WalletTransactionType? initialType;
  final WalletTransactionStatus? initialStatus;
  final VoidCallback onReset;
  final Function({
    double? minAmount,
    double? maxAmount,
    DateTime? fromDate,
    DateTime? toDate,
    WalletTransactionType? type,
    WalletTransactionStatus? status,
  }) onApply;

  const MyWalletFilterDialog({
    super.key,
    this.initialMinAmount,
    this.initialMaxAmount,
    this.initialFromDate,
    this.initialToDate,
    this.initialType,
    this.initialStatus,
    required this.onReset,
    required this.onApply,
  });

  @override
  State<MyWalletFilterDialog> createState() => _MyWalletFilterDialogState();
}

class _MyWalletFilterDialogState extends State<MyWalletFilterDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  late DateTime? _fromDate;
  late DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _fromDate = widget.initialFromDate;
    _toDate = widget.initialToDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Transactions'),
      content: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'minAmount': widget.initialMinAmount?.toString() ?? '',
            'maxAmount': widget.initialMaxAmount?.toString() ?? '',
            'type': widget.initialType,
            'status': widget.initialStatus,
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Amount Range
              FormBuilderTextField(
                name: 'minAmount',
                decoration: const InputDecoration(
                  labelText: 'Min Amount',
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.numeric(checkNullOrEmpty: false),
                  (value) {
                    if (value != null && value.isNotEmpty) {
                      final minAmount = double.tryParse(value);
                      final maxAmount = double.tryParse(
                          _formKey.currentState?.fields['maxAmount']?.value ??
                              '');
                      if (maxAmount != null && minAmount! > maxAmount) {
                        return 'Min amount cannot be greater than max amount';
                      }
                    }
                    return null;
                  },
                ]),
              ),
              const SizedBox(height: 8),
              FormBuilderTextField(
                name: 'maxAmount',
                decoration: const InputDecoration(
                  labelText: 'Max Amount',
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.numeric(checkNullOrEmpty: false),
                  (value) {
                    if (value != null && value.isNotEmpty) {
                      final maxAmount = double.tryParse(value);
                      final minAmount = double.tryParse(
                          _formKey.currentState?.fields['minAmount']?.value ??
                              '');
                      if (minAmount != null && maxAmount! < minAmount) {
                        return 'Max amount cannot be less than min amount';
                      }
                    }
                    return null;
                  },
                ]),
              ),
              const SizedBox(height: 16),
              // Date Range
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _fromDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _fromDate = date);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            _fromDate?.toString().split(' ')[0] ?? 'From Date'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _toDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _toDate = date);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            _toDate?.toString().split(' ')[0] ?? 'To Date'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Transaction Type
              FormBuilderDropdown<WalletTransactionType>(
                name: 'type',
                decoration: const InputDecoration(
                  labelText: 'Transaction Type',
                ),
                items: WalletTransactionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              // Transaction Status
              FormBuilderDropdown<WalletTransactionStatus>(
                name: 'status',
                decoration: const InputDecoration(
                  labelText: 'Transaction Status',
                ),
                items: WalletTransactionStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onReset();
            Navigator.pop(context);
          },
          child: const Text('Clear All'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              final values = _formKey.currentState!.value;
              widget.onApply(
                minAmount: double.tryParse(values['minAmount'] ?? ''),
                maxAmount: double.tryParse(values['maxAmount'] ?? ''),
                fromDate: _fromDate,
                toDate: _toDate,
                type: values['type'] != null
                    ? WalletTransactionType.values.firstWhere(
                        (e) => e == values['type'],
                      )
                    : null,
                status: values['status'] != null
                    ? WalletTransactionStatus.values.firstWhere(
                        (e) => e == values['status'],
                      )
                    : null,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
