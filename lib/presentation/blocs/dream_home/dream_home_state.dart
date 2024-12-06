part of 'dream_home_bloc.dart';

class DreamHomeState extends Equatable {
  final List<Dream> dreams;
  final int offset;
  final bool isLoading;
  final bool endReached;

  const DreamHomeState({
    required this.dreams,
    this.offset = 0,
    this.isLoading = false,
    this.endReached = false,
  });

  DreamHomeState copyWith({
    List<Dream>? dreams,
    bool? isLoading,
    int? offset,
    bool? endReached,
  }) =>
      DreamHomeState(
        dreams: dreams ?? this.dreams,
        isLoading: isLoading ?? this.isLoading,
        offset: offset ?? this.offset,
        endReached: endReached ?? this.endReached,
      );

  @override
  List<Object> get props => [dreams, isLoading, endReached];

  @override
  String toString() {
    return 'DreamHomeState{dreams: $dreams, offset: $offset, isLoading: $isLoading, endReached: $endReached}';
  }
}
