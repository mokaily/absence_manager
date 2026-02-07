import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/absences_bloc.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> initialTypes;
  final List<String> initialStatuses;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const FilterBottomSheet({
    super.key,
    required this.initialTypes,
    required this.initialStatuses,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedTypes;
  late List<String> _selectedStatuses;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedTypes = List.from(widget.initialTypes);
    _selectedStatuses = List.from(widget.initialStatuses);
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    // Trigger initial preview
    _updatePreview();
  }

  void _updatePreview() {
    context.read<AbsencesBloc>().add(
      PreviewFilterCountEvent(
        types: _selectedTypes,
        statuses: _selectedStatuses,
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }

  void _onTypeChanged(String type, bool? selected) {
    setState(() {
      if (selected == true) {
        if (!_selectedTypes.contains(type)) _selectedTypes.add(type);
      } else {
        _selectedTypes.remove(type);
      }
    });
    _updatePreview();
  }

  void _onStatusChanged(String status, bool? selected) {
    setState(() {
      if (selected == true) {
        if (!_selectedStatuses.contains(status)) _selectedStatuses.add(status);
      } else {
        _selectedStatuses.remove(status);
      }
    });
    _updatePreview();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _updatePreview();
    }
  }

  void _clearDates() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _updatePreview();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      // Use MediaQuery to handle bottom insets/safe area if needed,
      // but usually modal bottom sheet handles it.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filters', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),

          Text('Type', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8.0,
            children: [
              FilterChip(
                label: const Text('Sickness'),
                selected: _selectedTypes.contains('sickness'),
                onSelected: (val) => _onTypeChanged('sickness', val),
              ),
              FilterChip(
                label: const Text('Vacation'),
                selected: _selectedTypes.contains('vacation'),
                onSelected: (val) => _onTypeChanged('vacation', val),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text('Status', style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: 8.0,
            children: [
              FilterChip(
                label: const Text('Requested'),
                selected: _selectedStatuses.contains('requested'),
                onSelected: (val) => _onStatusChanged('requested', val),
              ),
              FilterChip(
                label: const Text('Confirmed'),
                selected: _selectedStatuses.contains('confirmed'),
                onSelected: (val) => _onStatusChanged('confirmed', val),
              ),
              FilterChip(
                label: const Text('Rejected'),
                selected: _selectedStatuses.contains('rejected'),
                onSelected: (val) => _onStatusChanged('rejected', val),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text('Date Range', style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _selectDateRange(context),
                  child: Text(
                    (_startDate != null && _endDate != null)
                        ? '${DateFormat('yyyy-MM-dd').format(_startDate!)} - ${DateFormat('yyyy-MM-dd').format(_endDate!)}'
                        : 'Select Date Range',
                  ),
                ),
              ),
              if (_startDate != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearDates,
                ),
            ],
          ),
          const SizedBox(height: 24),

          BlocBuilder<AbsencesBloc, AbsencesState>(
            buildWhen: (previous, current) {
              if (current is AbsencesLoaded && previous is AbsencesLoaded) {
                return previous.filterPreviewCount !=
                    current.filterPreviewCount;
              }
              return true;
            },
            builder: (context, state) {
              int? count;
              if (state is AbsencesLoaded) {
                count = state.filterPreviewCount;
              }

              return ElevatedButton(
                onPressed: () {
                  context.read<AbsencesBloc>().add(
                    ApplyFiltersEvent(
                      types: _selectedTypes,
                      statuses: _selectedStatuses,
                      startDate: _startDate,
                      endDate: _endDate,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text('Show ${count ?? '...'} Results'),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
