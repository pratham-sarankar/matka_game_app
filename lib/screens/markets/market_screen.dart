import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:matka_game_app/screens/markets/market_form.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Markets',
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
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: FirestoreListView<Map<String, dynamic>>(
          query: FirebaseFirestore.instance.collection('markets'),
          itemBuilder: (context, snapshot) {
            final market = Market.fromDoc(snapshot);
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () => _showMarketForm(context, market),
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              market.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _buildStatusChip(market),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTimeRow(
                        'Open Time',
                        market.openTime.format(context),
                        market.openLastBidTime.format(context),
                      ),
                      const SizedBox(height: 8),
                      _buildTimeRow(
                        'Close Time',
                        market.closeTime.format(context),
                        market.closeLastBidTime.format(context),
                      ),
                      const SizedBox(height: 16),
                      _buildOpenDays(market.openDays),
                    ],
                  ),
                ),
              ),
            );
          },
          emptyBuilder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Markets Found',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a new market to get started',
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          errorBuilder: (context, error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Markets',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.red.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again later',
                  style: GoogleFonts.poppins(
                    color: Colors.red.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMarketForm(context, null),
        icon: const Icon(Icons.add),
        label: Text(
          'Add Market',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(Market market) {
    final isOpen = market.isOpen;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isOpen ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOpen ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOpen ? Icons.circle : Icons.circle_outlined,
            size: 12,
            color: isOpen ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            isOpen ? 'Open' : 'Closed',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isOpen ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String time, String lastBidTime) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            time,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          'Last Bid: $lastBidTime',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildOpenDays(String openDays) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < 7; i++)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: openDays[i] == '1'
                  ? Theme.of(Get.context!).primaryColor.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              days[i],
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: openDays[i] == '1'
                    ? Theme.of(Get.context!).primaryColor
                    : Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }

  void _showMarketForm(BuildContext context, Market? market) async {
    final result = await Get.to<Market>(
      () => MarketForm(
        market: market,
        onDelete: market != null
            ? (id) async {
                await FirebaseFirestore.instance
                    .collection('markets')
                    .doc(id)
                    .delete();
              }
            : null,
      ),
    );

    if (result != null) {
      if (market == null) {
        // Create new market
        await FirebaseFirestore.instance
            .collection('markets')
            .add(result.toMap());
      } else {
        // Update existing market
        await FirebaseFirestore.instance
            .collection('markets')
            .doc(market.id)
            .update(result.toMap());
      }
    }
  }
}
