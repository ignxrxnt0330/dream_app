part of 'dream_search_bloc.dart';

class DreamSearchState extends Equatable {
  final List<Dream> dreams;
  final bool isLoading;
  final int count;
  final int offset;

  //TODO: states factory ¿?

  const DreamSearchState({this.dreams = const [], this.isLoading = false, this.count = 0, this.offset = 0});

  DreamSearchState copyWith({
    List<Dream>? dreams,
    bool? isLoading,
    int? count,
    int? offset,
  }) {
    return DreamSearchState(
      dreams: dreams ?? this.dreams,
      isLoading: isLoading ?? this.isLoading,
      count: count ?? this.count,
      offset: offset ?? this.offset,
    );
  }

  @override
  List<Object> get props => [dreams, isLoading, count];
}
