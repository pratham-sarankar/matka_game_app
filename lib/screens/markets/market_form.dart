import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        title: Text(isEditing ? "Edit Market" : "Add Market"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 25,
          bottom: 10,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Market Name"),
                initialValue: widget.market?.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Market Name is required";
                  }
                  return null;
                },
                onSaved: (value) {
                  market.name = value!;
                },
              ),
              const SizedBox(height: 20),
              TimePickerFormField(
                title: "Open Time",
                initialValue: widget.market?.openTime,
                validator: (value) {
                  if (value == null) {
                    return "Open Time is required";
                  }
                  return null;
                },
                onSaved: (value) {
                  market.openTime = value!;
                },
              ),
              const SizedBox(height: 20),
              TimePickerFormField(
                title: "Open Last Bid Time",
                initialValue: widget.market?.openLastBidTime,
                validator: (value) {
                  if (value == null) {
                    return "Open Last Bid Time is required";
                  }
                  return null;
                },
                onSaved: (value) {
                  market.openLastBidTime = value!;
                },
              ),
              const SizedBox(height: 20),
              TimePickerFormField(
                title: "Close Time",
                initialValue: widget.market?.closeTime,
                validator: (value) {
                  if (value == null) {
                    return "Close Time is required";
                  }
                  return null;
                },
                onSaved: (value) {
                  market.closeTime = value!;
                },
              ),
              const SizedBox(height: 20),
              TimePickerFormField(
                title: "Close Last Bid Time",
                initialValue: widget.market?.closeLastBidTime,
                validator: (value) {
                  if (value == null) {
                    return "Close Last Bid Time is required";
                  }
                  return null;
                },
                onSaved: (value) {
                  market.closeLastBidTime = value!;
                },
              ),
              const SizedBox(height: 20),
              WeekdaysFormField(
                initialValue: widget.market?.openDays,
                validator: (value) {
                  if (value == null) {
                    return "Open Days is required";
                  } else if (value.length != 7) {
                    return "Open Days must be a 7 character string.";
                  }
                  return null;
                },
                onSaved: (value) {
                  market.openDays = value!;
                },
              ),
              const SizedBox(height: 20),
              GradientButton(
                child: const Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    Get.back(result: market);
                  }
                },
              ),
              if (isEditing) ...[
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: _deleteMarket,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.trash),
                      SizedBox(width: 8),
                      Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _deleteMarket() async {
    // if (widget.onDelete == null) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text(
              "Deleting this market will delete all the bets associated with this market "
              "and user will lose their pending bet credits?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                Get.back();
                await widget.onDelete?.call(widget.market!.id);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
