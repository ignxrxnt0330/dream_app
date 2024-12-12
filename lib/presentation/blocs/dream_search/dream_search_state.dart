part of 'dream_search_bloc.dart';

class DreamSearchState extends Equatable {
  final List<Dream> dreams;
  final bool isLoading;
  final int count;

  const DreamSearchState({this.dreams = const [], this.isLoading = false, this.count = 0});

  DreamSearchState copyWith({
    List<Dream>? dreams,
    bool? isLoading,
    int? count,
  }) {
    return DreamSearchState(
      dreams: dreams ?? this.dreams,
      isLoading: isLoading ?? this.isLoading,
      count: count ?? this.count,
    );
  }

  @override
  List<Object> get props => [dreams, isLoading, count];
}
