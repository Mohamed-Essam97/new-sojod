import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

/// Placeholder mosque finder - uses geocoding to find "mosque" near user
/// In production, use Google Places API or similar
class MosquePage extends StatefulWidget {
  const MosquePage({super.key});

  @override
  State<MosquePage> createState() => _MosquePageState();
}

class _MosquePageState extends State<MosquePage> {
  bool _loading = false;
  String _error = '';
  List<Location> _locations = [];

  Future<void> _findMosques() async {
    setState(() {
      _loading = true;
      _error = '';
      _locations = [];
    });
    try {
      await Geolocator.getCurrentPosition();
      final locations = await locationFromAddress('mosque');
      setState(() {
        _locations = locations.take(10).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not find mosques. Enable location and try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('mosque')),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mosque, size: 64, color: AppColors.teal),
                        const SizedBox(height: 16),
                        Text(
                          _error,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _findMosques,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    FilledButton.icon(
                      onPressed: _findMosques,
                      icon: const Icon(Icons.search),
                      label: const Text('Find Nearby Mosques'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_locations.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.mosque, size: 64, color: AppColors.teal),
                              const SizedBox(height: 16),
                              Text(
                                'Tap the button above to find mosques near you',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._locations.map((loc) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(Icons.mosque, color: AppColors.teal),
                              title: Text(
                                  '${loc.latitude.toStringAsFixed(4)}, ${loc.longitude.toStringAsFixed(4)}'),
                              subtitle: const Text('Mosque location'),
                            ),
                          )),
                  ],
                ),
    );
  }
}
