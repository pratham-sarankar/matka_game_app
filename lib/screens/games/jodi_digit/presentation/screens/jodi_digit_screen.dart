import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matka_game_app/models/bid.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:matka_game_app/repositories/bid_repository.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/widgets/balance_widget.dart';
import 'package:matka_game_app/widgets/bid_confirmation_dialog.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

class JodiDigitScreen extends StatefulWidget {
  final Market market;
  final UserService userService;
  final Bid? bid; // If provided, we're in view/edit mode

  const JodiDigitScreen({
    super.key,
    required this.market,
    required this.userService,
    this.bid,
  });

  @override
  State<JodiDigitScreen> createState() => _JodiDigitScreenState();
}

class _JodiDigitScreenState extends State<JodiDigitScreen> {
  final _bidRepository = BidRepository();
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  bool _isViewMode = false;

  @override
  void initState() {
    super.initState();
    _isViewMode = widget.bid != null;
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      final bid = Bid(
        id: widget.bid?.id ?? '', // Will be set by Firestore for new bids
        userId: widget.userService.currentUserId,
        marketId: widget.market.id,
        gameType: 'Jodi Digit',
        digit: formData['digit'],
        amount: double.parse(formData['amount']),
        timestamp: widget.bid?.timestamp ?? DateTime.now(),
        session: formData['session'] as String,
        status: widget.bid?.status ?? BidStatus.pending,
      );

      if (!mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => BidConfirmationDialog(
          market: widget.market,
          bid: bid,
          onConfirm: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        ),
      );

      if (confirmed != true || !mounted) return;

      setState(() => _isLoading = true);

      try {
        await _bidRepository.placeBid(bid);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bid placed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          _showError('Failed to place bid: $e');
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 25,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.market.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isViewMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => _isViewMode = false);
              },
            ),
          BalanceWidget(userId: widget.userService.currentUserId),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        enabled: !_isViewMode,
        initialValue: widget.bid != null
            ? {
                'digit': widget.bid!.digit.toString().padLeft(2, '0'),
                'amount': widget.bid!.amount.toString(),
                'session': widget.bid!.session,
              }
            : {
                'session': 'open',
              },
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 25,
          ),
          children: [
            Center(
              child: Text(
                widget.market.name.toUpperCase(),
                style: GoogleFonts.poppins(
                  color: const Color(0xffcf1a65),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Date",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: DateFormat("dd-MM-yyyy").format(DateTime.now()),
                hintStyle: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                ),
                contentPadding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 20, right: 10),
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff530b47),
                  ),
                  child: const Icon(
                    CupertinoIcons.calendar,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Choose Session",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            FormBuilderRadioGroup<String>(
              name: 'session',
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              options: const [
                FormBuilderFieldOption(
                  value: 'open',
                  child: Text('Open'),
                ),
                FormBuilderFieldOption(
                  value: 'close',
                  child: Text('Close'),
                ),
              ],
              initialValue: 'open',
              validator: FormBuilderValidators.required(
                errorText: 'Please select a session',
              ),
            ),
            const SizedBox(height: 20),
            FormBuilderTextField(
              name: 'digit',
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                hintText: "Enter Jodi Digit (00-99)",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade800,
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Please enter a jodi digit',
                ),
                FormBuilderValidators.numeric(
                  errorText: 'Please enter a valid number',
                ),
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a jodi digit';
                  }
                  final digit = int.tryParse(value);
                  if (digit == null || digit < 0 || digit > 99) {
                    return 'Jodi digit must be between 00 and 99';
                  }
                  return null;
                },
              ]),
            ),
            const SizedBox(height: 15),
            FormBuilderTextField(
              name: 'amount',
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter Bid Points",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade800,
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                  errorText: 'Please enter bid points',
                ),
                FormBuilderValidators.numeric(
                  errorText: 'Please enter a valid number',
                ),
                (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ]),
            ),
            const SizedBox(height: 20),
            if (!_isViewMode)
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : GradientButton(
                        onTap: _onSubmit,
                        child: Text(
                          widget.bid != null ? "Update Bid" : "Place Bid",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
