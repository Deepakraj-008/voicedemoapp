import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/crex/data/models/match_item.dart';
import '../../modules/crex/logic/match_providers.dart';

class CrexMatchDetailScreen extends StatefulWidget {
  final String matchId;

  const CrexMatchDetailScreen({
    Key? key,
    required this.matchId,
  }) : super(key: key);

  @override
  State<CrexMatchDetailScreen> createState() => _CrexMatchDetailScreenState();
}

class _CrexMatchDetailScreenState extends State<CrexMatchDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MatchProviders>(context, listen: false);
      // TODO: Fetch match details when API is implemented
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Match Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: Consumer<MatchProviders>(
        builder: (context, matchProvider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_cricket,
                  color: Colors.grey[600],
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Match Details',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Match ID: ${widget.matchId}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Complete match details will be available here',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
