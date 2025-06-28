import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_card.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_section.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class TrackerSectionScreen extends StatefulWidget {
  final TrackLibrarySection section;

  const TrackerSectionScreen({super.key, required this.section});

  @override
  State<TrackerSectionScreen> createState() => _TrackerSectionScreenState();
}

class _TrackerSectionScreenState extends State<TrackerSectionScreen> {
  String _errorMessage = "";
  bool _isLoading = true;
  List<TrackSearch> _tracks = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didUpdateWidget(covariant TrackerSectionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return Scaffold(
      body: SizedBox(
        height: 260,
        child: Column(
          children: [
            ListTile(dense: true, title: Text(widget.section.name)),
            Flexible(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Builder(
                      builder: (context) {
                        if (_errorMessage.isNotEmpty) {
                          return Center(child: Text(_errorMessage));
                        }
                        if (_tracks.isNotEmpty) {
                          return SuperListView.builder(
                            extentPrecalculationPolicy:
                                SuperPrecalculationPolicy(),
                            scrollDirection: Axis.horizontal,
                            itemCount: _tracks.length,
                            itemBuilder: (context, index) {
                              return TrackerLibraryImageCard(
                                track: _tracks[index],
                                itemType: widget.section.itemType,
                              );
                            },
                          );
                        }
                        return Center(child: Text(l10n.no_result));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _fetchData() async {
    final box = await Hive.openBox("tracker_library");
    final key =
        "${widget.section.syncId}-${widget.section.itemType.name}-${widget.section.name}";
    if (_checkCache(box, key)) {
      return;
    }
    try {
      _errorMessage = "";
      _tracks = await widget.section.func() ?? [];
      box.put(key, _tracks);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  bool _checkCache(Box<dynamic> box, String key) {
    if (!widget.section.isSearch && box.containsKey(key)) {
      final temp = box.get(key);
      if (temp is List<TrackSearch>) {
        _errorMessage = "";
        _tracks = temp;
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return true;
      }
    }
    return false;
  }
}

class SuperPrecalculationPolicy extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) {
    return context.numberOfItems < 100;
  }
}
