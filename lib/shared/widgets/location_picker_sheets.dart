import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/location_models.dart';
import 'package:skye_app/shared/services/location_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

const _sheetTextStyle = TextStyle(fontSize: 14, color: AppColors.grayPrimary);
const _sheetSubtitleStyle = TextStyle(fontSize: 12, color: AppColors.grayDark);

/// State seçim bottom sheet – Clear/Apply pattern, search, select/unselect
Future<StateModel?> showStatePickerSheet(
  BuildContext context, {
  StateModel? selected,
}) async {
  return await showModalBottomSheet<StateModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _StatePickerSheet(selected: selected),
  );
}

class _StatePickerSheet extends StatefulWidget {
  const _StatePickerSheet({this.selected});

  final StateModel? selected;

  @override
  State<_StatePickerSheet> createState() => _StatePickerSheetState();
}

class _StatePickerSheetState extends State<_StatePickerSheet> {
  List<StateModel> _states = [];
  bool _loading = true;
  String? _error;
  StateModel? _pending;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pending = widget.selected;
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await LocationApiService.instance.getStates();
      if (mounted) {
        setState(() {
          _states = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Widget _buildFrame(Widget child) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Text(
                'Select State',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.labelBlack),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: _sheetSubtitleStyle,
                  filled: true,
                  fillColor: AppColors.white,
                  prefixIcon: const Icon(Icons.search, color: AppColors.grayPrimary, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: _sheetTextStyle,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(child: child),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        debugPrint('✅ [StatePickerSheet] Clear tapped');
                        setState(() => _pending = null);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.labelBlack,
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        debugPrint('✅ [StatePickerSheet] Apply tapped, selected: ${_pending?.name}');
                        Navigator.of(context).pop(_pending);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy800,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchController.text.toLowerCase().trim();
    final filtered = q.isEmpty ? _states : _states.where((s) => s.name.toLowerCase().contains(q) || (s.code.toLowerCase().contains(q))).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return _buildFrame(
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                          const SizedBox(height: 8),
                          TextButton(onPressed: _load, child: const Text('Retry')),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final s = filtered[i];
                        final isSelected = _pending?.id == s.id;
                        return InkWell(
                          onTap: () => setState(() => _pending = isSelected ? null : s),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.navy800.withValues(alpha: 0.08) : null,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppColors.navy800 : AppColors.borderLight,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(s.name, style: _sheetTextStyle),
                                      Text(s.code, style: _sheetSubtitleStyle),
                                    ],
                                  ),
                                ),
                                if (isSelected) const Icon(Icons.check_circle, color: AppColors.navy800, size: 22),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}

/// City seçim bottom sheet (state gerekli) – Clear/Apply, search, select/unselect
Future<CityModel?> showCityPickerSheet(
  BuildContext context, {
  required int stateId,
  CityModel? selected,
}) async {
  return await showModalBottomSheet<CityModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _CityPickerSheet(stateId: stateId, selected: selected),
  );
}

class _CityPickerSheet extends StatefulWidget {
  const _CityPickerSheet({required this.stateId, this.selected});

  final int stateId;
  final CityModel? selected;

  @override
  State<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<_CityPickerSheet> {
  List<CityModel> _cities = [];
  bool _loading = true;
  String? _error;
  CityModel? _pending;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pending = widget.selected;
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await LocationApiService.instance.getCitiesByState(widget.stateId);
      if (mounted) {
        setState(() {
          _cities = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _searchController.text.toLowerCase().trim();
    final filtered = q.isEmpty ? _cities : _cities.where((c) => c.name.toLowerCase().contains(q)).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Text(
                    'Select City',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.labelBlack),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: _sheetSubtitleStyle,
                      filled: true,
                      fillColor: AppColors.white,
                      prefixIcon: const Icon(Icons.search, color: AppColors.grayPrimary, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: _sheetTextStyle,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  TextButton(onPressed: _load, child: const Text('Retry')),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final c = filtered[i];
                                final isSelected = _pending?.id == c.id;
                                return InkWell(
                                  onTap: () => setState(() => _pending = isSelected ? null : c),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.navy800.withValues(alpha: 0.08) : null,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? AppColors.navy800 : AppColors.borderLight,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(c.name, style: _sheetTextStyle)),
                                        if (isSelected) const Icon(Icons.check_circle, color: AppColors.navy800, size: 22),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            debugPrint('✅ [CityPickerSheet] Clear tapped');
                            setState(() => _pending = null);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.labelBlack,
                            side: const BorderSide(color: AppColors.borderLight),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            debugPrint('✅ [CityPickerSheet] Apply tapped, selected: ${_pending?.name}');
                            Navigator.of(context).pop(_pending);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.navy800,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Airport seçim – search ile veya city'den
/// multiSelect: true ise birden fazla seçilir, sonuç List<AirportModel>
/// multiSelect: false ise tek seçim, sonuç AirportModel?
Future<AirportModel?> showAirportPickerSheet(
  BuildContext context, {
  int? cityId,
  List<AirportModel>? initialSelected,
  bool multiSelect = false,
}) async {
  return await showModalBottomSheet<AirportModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AirportPickerSheet(
      cityId: cityId,
      initialSelected: initialSelected ?? [],
      multiSelect: multiSelect,
    ),
  );
}

class _AirportPickerSheet extends StatefulWidget {
  const _AirportPickerSheet({
    this.cityId,
    this.initialSelected = const [],
    this.multiSelect = false,
  });

  final int? cityId;
  final List<AirportModel> initialSelected;
  final bool multiSelect;

  @override
  State<_AirportPickerSheet> createState() => _AirportPickerSheetState();
}

class _AirportPickerSheetState extends State<_AirportPickerSheet> {
  final _searchController = TextEditingController();
  List<AirportModel> _airports = [];
  bool _loading = false;
  String? _error;
  Timer? _debounce;
  AirportModel? _pending;

  @override
  void initState() {
    super.initState();
    _pending = widget.initialSelected.isNotEmpty ? widget.initialSelected.first : null;
    if (widget.cityId != null) {
      _loadByCity();
    } else {
      _searchWithInit();
    }
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (widget.cityId != null) {
      setState(() {});
      return;
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = _searchController.text.trim();
      if (q.length >= 2) {
        _searchAirports(q);
      } else if (q.isEmpty) {
        _searchWithInit();
      }
    });
  }

  Future<void> _searchWithInit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await LocationApiService.instance.searchAirports(init: true);
      if (mounted) {
        setState(() {
          _airports = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _searchAirports(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await LocationApiService.instance.searchAirports(query: query);
      if (mounted) {
        setState(() {
          _airports = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadByCity() async {
    if (widget.cityId == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await LocationApiService.instance.getAirportsByCity(widget.cityId!);
      if (mounted) {
        setState(() {
          _airports = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  bool _isSelected(AirportModel a) {
    if (widget.multiSelect) return widget.initialSelected.any((s) => s.id == a.id);
    return _pending?.id == a.id;
  }

  List<AirportModel> get _filteredAirports {
    final q = _searchController.text.toLowerCase().trim();
    if (q.isEmpty) return _airports;
    return _airports.where((a) => a.name.toLowerCase().contains(q) || a.code.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayList = widget.cityId != null ? _filteredAirports : _airports;
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Text(
                    widget.multiSelect ? 'Select Base Airport(s)' : 'Select Airport',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.labelBlack),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: widget.cityId != null ? 'Search by code or name' : 'Search by code or name (min 2 chars)',
                      hintStyle: _sheetSubtitleStyle,
                      filled: true,
                      fillColor: AppColors.white,
                      prefixIcon: const Icon(Icons.search, color: AppColors.grayPrimary, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    style: _sheetTextStyle,
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () => widget.cityId != null ? _loadByCity() : _searchWithInit(),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: displayList.length,
                              itemBuilder: (context, i) {
                                final a = displayList[i];
                                final isSelected = _isSelected(a);
                                return InkWell(
                                  onTap: () {
                                    if (widget.multiSelect) {
                                      // multiSelect: keep current pop behavior for now
                                      Navigator.pop(context, a);
                                    } else {
                                      setState(() => _pending = isSelected ? null : a);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.navy800.withValues(alpha: 0.08) : null,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? AppColors.navy800 : AppColors.borderLight,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(a.code, style: _sheetTextStyle),
                                              Text(a.name, style: _sheetSubtitleStyle),
                                            ],
                                          ),
                                        ),
                                        if (isSelected) const Icon(Icons.check_circle, color: AppColors.navy800, size: 22),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
                if (!widget.multiSelect)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              debugPrint('✅ [AirportPickerSheet] Clear tapped');
                              setState(() => _pending = null);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.labelBlack,
                              side: const BorderSide(color: AppColors.borderLight),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Clear'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              debugPrint('✅ [AirportPickerSheet] Apply tapped, selected: ${_pending?.name}');
                              Navigator.of(context).pop(_pending);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.navy800,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
