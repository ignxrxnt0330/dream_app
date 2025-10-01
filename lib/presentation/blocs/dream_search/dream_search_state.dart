part of 'dream_search_bloc.dart';

class DreamSearchState extends Equatable {
  final List<Dream> dreams;
  final bool isLoading;
  final int count;
  final int offset;
  final bool endReached;
  final String query;
  final double scroll;

  //TODO: states factory ¿?

  const DreamSearchState(
      {this.dreams = const [],
      this.isLoading = false,
      this.count = 0,
      this.offset = 0,
      this.endReached = false,
      this.query = "",
      this.scroll = 0});

  DreamSearchState copyWith(
      {List<Dream>? dreams,
      bool? isLoading,
      int? count,
      int? offset,
      bool? endReached,
      String? query,
      double? scroll}) {
    return DreamSearchState(
      dreams: dreams ?? this.dreams,
      isLoading: isLoading ?? this.isLoading,
      count: count ?? this.count,
      offset: offset ?? this.offset,
      endReached: endReached ?? this.endReached,
      query: query ?? this.query,
      scroll: scroll ?? this.scroll,
    );
  }

  @override
  @override
  String toString() =>
      'DreamSearchState { dreams: $dreams, isLoading: $isLoading, count: $count, offset: $offset, endReached: $endReached, query: $query }';

  @override
  List<Object> get props => [dreams, isLoading, endReached, query, scroll];
}
