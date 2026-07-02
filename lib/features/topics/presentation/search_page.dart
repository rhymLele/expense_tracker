import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/base/base_cubit.dart';
import '../../../core/di/service_locator.dart';
import '../../../lingua_thread/theme/lt_colors.dart';
import '../../../lingua_thread/theme/lt_spacing.dart';
import '../../../lingua_thread/theme/lt_typography.dart';
import '../../../lingua_thread/widgets/lt_avatar.dart';
import '../data/datasources/topics_remote_datasource.dart';
import '../domain/entities/topic_entity.dart';

// ── State ─────────────────────────────────────────────────────────────────────

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<TopicEntity> results;
  final String query;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const [],
    this.query = '',
  });

  SearchState copyWith({
    SearchStatus? status,
    List<TopicEntity>? results,
    String? query,
  }) =>
      SearchState(
        status: status ?? this.status,
        results: results ?? this.results,
        query: query ?? this.query,
      );

  @override
  List<Object?> get props => [status, results, query];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class SearchCubit extends BaseCubit<SearchState> {
  final TopicsRemoteDataSource _datasource;

  SearchCubit(this._datasource) : super(const SearchState());

  /// Tìm kiếm được kích hoạt từ ô nhập, nên không load ban đầu.
  @override
  Future<void> fetchData() async {}

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchState());
      return;
    }
    emit(state.copyWith(status: SearchStatus.loading, query: query));
    try {
      final result = await _datasource.searchTopics(query.trim());
      emit(state.copyWith(
        status: SearchStatus.success,
        results: List<TopicEntity>.from(result.items),
      ));
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }
}

// ── Page ──────────────────────────────────────────────────────────────────────

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(sl<TopicsRemoteDataSource>()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LtColors.bg,
      appBar: AppBar(
        backgroundColor: LtColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: LtColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: LtTypography.body,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm posts, threads...',
            hintStyle: LtTypography.body.copyWith(color: LtColors.textMuted),
            border: InputBorder.none,
          ),
          onChanged: (q) => context.read<SearchCubit>().search(q),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (ctx, state) {
          switch (state.status) {
            case SearchStatus.initial:
              return _buildPlaceholder();
            case SearchStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: LtColors.ink),
              );
            case SearchStatus.failure:
              return Center(
                child: Text(
                  'Lỗi tìm kiếm, thử lại',
                  style: LtTypography.body,
                ),
              );
            case SearchStatus.success:
              if (state.results.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Không tìm thấy "${state.query}"',
                        style: LtTypography.body,
                      ),
                      const SizedBox(height: 6),
                      Text('Thử từ khoá khác', style: LtTypography.caption),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.results.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: LtColors.divider),
                itemBuilder: (_, i) => _buildResultTile(state.results[i]),
              );
          }
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'Nhập từ khoá để tìm kiếm',
            style: LtTypography.body.copyWith(color: LtColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(TopicEntity t) {
    final preview =
        t.content?.isNotEmpty == true ? t.content! : t.title;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: LtSpacing.padPage,
        vertical: 6,
      ),
      leading: LtAvatar(
        name: t.authorName?.isNotEmpty == true ? t.authorName![0] : '?',
        size: 40,
      ),
      title: Text(
        preview,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: LtTypography.body,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          t.authorName ?? 'Unknown',
          style: LtTypography.caption,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, size: 14, color: LtColors.textMuted),
          const SizedBox(width: 3),
          Text('${t.likeCount}', style: LtTypography.caption),
        ],
      ),
    );
  }
}
