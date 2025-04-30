import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/discover_params_model.dart';
import '../../../data/repo/genre_repo.dart';
import '../../../data/src/genre_src.dart';
import '../../../utils/web/http_client.dart';
import '../bloc/discover_bloc.dart';

class DiscoverFilterDialog extends StatefulWidget {
  final bool isMovie;
  final ScrollController scrollController;

  const DiscoverFilterDialog({
    super.key,
    required this.isMovie,
    required this.scrollController,
  });

  @override
  State<DiscoverFilterDialog> createState() => _DiscoverFilterDialogState();
}

class _DiscoverFilterDialogState extends State<DiscoverFilterDialog> {
  late String _sortBy;
  late RangeValues _voteAverageRange;
  late RangeValues _runtimeRange;
  late DateTime? _releaseDateStart;
  late DateTime? _releaseDateEnd;
  final List<String> _selectedGenres = [];
  final List<String> _selectedKeywords = [];
  final Map<String, String> _selectedKeywordNames = {};
  final TextEditingController _keywordController = TextEditingController();
  List<Map<String, dynamic>> _genres = [];
  List<Map<String, dynamic>> _searchedKeywords = [];

  @override
  void initState() {
    super.initState();
    _loadInitialState();
    _loadGenres();
  }

  void _loadInitialState() {
    final bloc = context.read<DiscoverBloc>();
    final params = widget.isMovie ? bloc.movieParams : bloc.tvParams;

    // Load keyword names from bloc
    if (bloc.keywordNames.isNotEmpty) {
      _selectedKeywordNames.addAll(bloc.keywordNames);
    }

    if (widget.isMovie) {
      final movieParams = params as DiscoverMovieParams;
      _sortBy = movieParams.sortBy ?? DiscoverSortOptions.popularityDesc;
      _voteAverageRange = RangeValues(
        (movieParams.voteAverageGte ?? 0).toDouble(),
        (movieParams.voteAverageLte ?? 10).toDouble(),
      );
      _runtimeRange = RangeValues(
        (movieParams.withRuntimeGte ?? 0).toDouble(),
        (movieParams.withRuntimeLte ?? 400).toDouble(),
      );
      _releaseDateStart =
          movieParams.releaseDateGte != null ? DateTime.parse(movieParams.releaseDateGte!) : null;
      _releaseDateEnd =
          movieParams.releaseDateLte != null ? DateTime.parse(movieParams.releaseDateLte!) : null;
      if (movieParams.withGenres != null) {
        _selectedGenres.addAll(movieParams.withGenres!.split(','));
      }
      if (movieParams.withKeywords != null) {
        _selectedKeywords.addAll(movieParams.withKeywords!.split(','));
      }
    } else {
      final tvParams = params as DiscoverTvParams;
      _sortBy = tvParams.sortBy ?? DiscoverSortOptions.popularityDesc;
      _voteAverageRange = RangeValues(
        (tvParams.voteAverageGte ?? 0).toDouble(),
        (tvParams.voteAverageLte ?? 10).toDouble(),
      );
      _runtimeRange = RangeValues(
        (tvParams.withRuntimeGte ?? 0).toDouble(),
        (tvParams.withRuntimeLte ?? 400).toDouble(),
      );
      _releaseDateStart =
          tvParams.firstAirDateGte != null ? DateTime.parse(tvParams.firstAirDateGte!) : null;
      _releaseDateEnd =
          tvParams.firstAirDateLte != null ? DateTime.parse(tvParams.firstAirDateLte!) : null;
      if (tvParams.withGenres != null) {
        _selectedGenres.addAll(tvParams.withGenres!.split(','));
      }
      if (tvParams.withKeywords != null) {
        _selectedKeywords.addAll(tvParams.withKeywords!.split(','));
      }
    }
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _loadGenres() async {
    try {
      final genreRepo = GenreRepository(GenreRemoteSrc(httpClient));
      final genres =
          widget.isMovie ? await genreRepo.getMovieGenres() : await genreRepo.getTvShowGenres();
      setState(() {
        _genres = genres
            .map((genre) => {
                  'id': genre.id,
                  'name': genre.name,
                })
            .toList();
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _searchKeywords(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchedKeywords = [];
      });
      return;
    }

    try {
      final response = await httpClient.get(
        '3/search/keyword',
        queryParameters: {'query': query},
      );

      setState(() {
        _searchedKeywords = (response.data['results'] as List)
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
      });
    } catch (e) {
      // Handle error
    }
  }

  void _selectKeyword(Map<String, dynamic> keyword) {
    setState(() {
      final keywordId = keyword['id'].toString();
      final keywordName = keyword['name'].toString();

      _selectedKeywords.add(keywordId);
      _selectedKeywordNames[keywordId] = keywordName; // Store the name
      _searchedKeywords = [];
      _keywordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Filter ${widget.isMovie ? 'Movies' : 'TV Shows'}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildSortByDropdown(),
          const SizedBox(height: 16),
          _buildGenreDropdown(),
          const SizedBox(height: 16),
          _buildKeywordSearch(),
          const SizedBox(height: 16),
          _buildVoteAverageFilter(),
          const SizedBox(height: 16),
          _buildRuntimeFilter(),
          const SizedBox(height: 16),
          _buildReleaseDateFilter(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply'),
              ),
            ],
          ),
          // Add extra padding at the bottom for keyboard
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSortByDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sort By'),
        DropdownButton<String>(
          value: _sortBy,
          isExpanded: true,
          items: [
            DropdownMenuItem(
              value: DiscoverSortOptions.popularityDesc,
              child: const Text('Popularity Descending'),
            ),
            DropdownMenuItem(
              value: DiscoverSortOptions.popularityAsc,
              child: const Text('Popularity Ascending'),
            ),
            DropdownMenuItem(
              value: DiscoverSortOptions.voteAverageDesc,
              child: const Text('Rating Descending'),
            ),
            DropdownMenuItem(
              value: DiscoverSortOptions.voteAverageAsc,
              child: const Text('Rating Ascending'),
            ),
            if (widget.isMovie) ...[
              DropdownMenuItem(
                value: DiscoverSortOptions.revenueDesc,
                child: const Text('Revenue Descending'),
              ),
              DropdownMenuItem(
                value: DiscoverSortOptions.revenueAsc,
                child: const Text('Revenue Ascending'),
              ),
            ],
            DropdownMenuItem(
              value: widget.isMovie
                  ? DiscoverSortOptions.primaryReleaseDateDesc
                  : 'first_air_date.desc',
              child: const Text('Release Date Descending'),
            ),
            DropdownMenuItem(
              value:
                  widget.isMovie ? DiscoverSortOptions.primaryReleaseDateAsc : 'first_air_date.asc',
              child: const Text('Release Date Ascending'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _sortBy = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildGenreDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Genres'),
        Wrap(
          spacing: 8,
          children: [
            ..._genres.map((genre) {
              final isSelected = _selectedGenres.contains(genre['id'].toString());
              return FilterChip(
                label: Text(genre['name']),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedGenres.add(genre['id'].toString());
                    } else {
                      _selectedGenres.remove(genre['id'].toString());
                    }
                  });
                },
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildKeywordSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Keywords'),
        if (_selectedKeywords.isNotEmpty)
          Wrap(
            spacing: 8,
            children: _selectedKeywords.map((keywordId) {
              return Chip(
                label: Text(_selectedKeywordNames[keywordId] ?? keywordId),
                onDeleted: () {
                  setState(() {
                    _selectedKeywords.remove(keywordId);
                    _selectedKeywordNames.remove(keywordId);
                  });
                },
              );
            }).toList(),
          ),
        TextField(
          controller: _keywordController,
          decoration: const InputDecoration(
            hintText: 'Search keywords...',
            suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => _searchKeywords(value),
        ),
        if (_searchedKeywords.isNotEmpty)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchedKeywords.length,
              itemBuilder: (context, index) {
                final keyword = _searchedKeywords[index];
                return ListTile(
                  title: Text(keyword['name']),
                  onTap: () => _selectKeyword(keyword),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildVoteAverageFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Vote Average Range'),
        RangeSlider(
          values: _voteAverageRange,
          min: 0,
          max: 10,
          divisions: 20,
          labels: RangeLabels(
            _voteAverageRange.start.toStringAsFixed(1),
            _voteAverageRange.end.toStringAsFixed(1),
          ),
          onChanged: (values) {
            setState(() => _voteAverageRange = values);
          },
        ),
      ],
    );
  }

  Widget _buildRuntimeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Runtime Range (minutes)'),
        RangeSlider(
          values: _runtimeRange,
          min: 0,
          max: 400,
          divisions: 40,
          labels: RangeLabels(
            _runtimeRange.start.round().toString(),
            _runtimeRange.end.round().toString(),
          ),
          onChanged: (values) {
            setState(() => _runtimeRange = values);
          },
        ),
      ],
    );
  }

  Widget _buildReleaseDateFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Release Date Range'),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => _selectDate(true),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                    _releaseDateStart == null ? 'Start Date' : _formatDate(_releaseDateStart!)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextButton.icon(
                onPressed: () => _selectDate(false),
                icon: const Icon(Icons.calendar_today),
                label: Text(_releaseDateEnd == null ? 'End Date' : _formatDate(_releaseDateEnd!)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _releaseDateStart = picked;
        } else {
          _releaseDateEnd = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _applyFilters() {
    print('Applying filters: isMovie=${widget.isMovie}');
    final bloc = context.read<DiscoverBloc>();

    // Save keyword names to the bloc
    bloc.keywordNames.clear();
    bloc.keywordNames.addAll(_selectedKeywordNames);

    if (widget.isMovie) {
      final params = DiscoverMovieParams(
        sortBy: _sortBy,
        voteAverageGte: _voteAverageRange.start,
        voteAverageLte: _voteAverageRange.end,
        withRuntimeGte: _runtimeRange.start,
        withRuntimeLte: _runtimeRange.end,
        releaseDateGte: _releaseDateStart?.toIso8601String(),
        releaseDateLte: _releaseDateEnd?.toIso8601String(),
        withGenres: _selectedGenres.isNotEmpty ? _selectedGenres.join(',') : null,
        withKeywords: _selectedKeywords.isNotEmpty ? _selectedKeywords.join(',') : null,
      );
      print('Movie params: ${params.toJson()}');
      bloc.add(DiscoverMovieParamsChanged(params));
    } else {
      final params = DiscoverTvParams(
        sortBy: _sortBy,
        voteAverageGte: _voteAverageRange.start,
        voteAverageLte: _voteAverageRange.end,
        withRuntimeGte: _runtimeRange.start,
        withRuntimeLte: _runtimeRange.end,
        firstAirDateGte: _releaseDateStart?.toIso8601String(),
        firstAirDateLte: _releaseDateEnd?.toIso8601String(),
        withGenres: _selectedGenres.isNotEmpty ? _selectedGenres.join(',') : null,
        withKeywords: _selectedKeywords.isNotEmpty ? _selectedKeywords.join(',') : null,
      );
      print('TV show params: ${params.toJson()}');
      bloc.add(DiscoverTvParamsChanged(params));
    }

    Navigator.pop(context);
  }
}
