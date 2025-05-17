import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';
import 'package:matka_game_app/widgets/time_of_day_form_field.dart';
import 'package:matka_game_app/widgets/weekdays_form_field.dart';

class MarketForm extends StatefulWidget {
  const MarketForm({
    super.key,
    this.market,
    this.onDelete,
  });

  final Market? market;
  final Future Function(String)? onDelete;

  @override
  State<MarketForm> createState() => _MarketFormState();
}

class _MarketFormState extends State<MarketForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Market market;

  @override
  void initState() {
    market = widget.market ?? Market.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.market != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Market" : "Add Market",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FormBuilder(
              key: _formKey,
              initialValue: {
                'name': widget.market?.name ?? '',
                'openTime': widget.market?.openTime,
                'openLastBidTime': widget.market?.openLastBidTime,
                'closeTime': widget.market?.closeTime,
                'closeLastBidTime': widget.market?.closeLastBidTime,
                'openDays': widget.market?.openDays ?? '0000000',
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Market Details',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FormBuilderTextField(
                            name: 'name',
                            decoration: InputDecoration(
                              labelText: 'Market Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.store),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(3),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Timing',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TimePickerFormField(
                            name: 'openTime',
                            title: 'Open Time',
                            validator: (value) {
                              if (value == null) {
                                return 'Open Time is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TimePickerFormField(
                            name: 'openLastBidTime',
                            title: 'Open Last Bid Time',
                            validator: (value) {
                              if (value == null) {
                                return 'Open Last Bid Time is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TimePickerFormField(
                            name: 'closeTime',
                            title: 'Close Time',
                            validator: (value) {
                              if (value == null) {
                                return 'Close Time is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TimePickerFormField(
                            name: 'closeLastBidTime',
                            title: 'Close Last Bid Time',
                            validator: (value) {
                              if (value == null) {
                                return 'Close Last Bid Time is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Operating Days',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          WeekdaysFormField(
                            name: 'openDays',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Open Days is required';
                              }
                              if (value.length != 7) {
                                return 'Open Days must be a 7 character string';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    onTap: _submitForm,
                    child: Text(
                      isEditing ? 'Update Market' : 'Create Market',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 15),
                    OutlinedButton.icon(
                      onPressed: _deleteMarket,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 2,
                        ),
                      ),
                      icon: const Icon(CupertinoIcons.trash),
                      label: Text(
                        'Delete Market',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final updatedMarket = market.copyWith(
        name: values['name'] as String,
        openTime: values['openTime'] as TimeOfDay,
        openLastBidTime: values['openLastBidTime'] as TimeOfDay,
        closeTime: values['closeTime'] as TimeOfDay,
        closeLastBidTime: values['closeLastBidTime'] as TimeOfDay,
        openDays: values['openDays'] as String,
      );
      Get.back(result: updatedMarket);
    }
  }

  void _deleteMarket() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Market',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this market? This action cannot be undone and will affect all associated bets.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              widget.onDelete?.call(widget.market!.id);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
