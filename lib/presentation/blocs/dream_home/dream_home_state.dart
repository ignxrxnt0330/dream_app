part of 'dream_home_bloc.dart';

class DreamHomeState extends Equatable {
  final List<Dream> dreams;
  final int offset;
  final bool isLoading;
  final bool endReached;
  final String order;
  final bool asc;

  const DreamHomeState({
    required this.dreams,
    this.offset = 0,
    this.isLoading = false,
    this.endReached = false,
    this.order = "date",
    this.asc = false,
  });

  DreamHomeState copyWith({
    List<Dream>? dreams,
    bool? isLoading,
    int? offset,
    bool? endReached,
    String? order,
    bool? asc,
  }) =>
      DreamHomeState(
        dreams: dreams ?? this.dreams,
        isLoading: isLoading ?? this.isLoading,
        offset: offset ?? this.offset,
        endReached: endReached ?? this.endReached,
        order: order ?? this.order,
        asc: asc ?? this.asc,
      );

  @override
  List<Object> get props => [dreams, isLoading, endReached, order,asc];

  @override
  String toString() {
    return 'DreamHomeState{dreams: $dreams, order: $order, asc: $asc, offset: $offset, isLoading: $isLoading, endReached: $endReached}';
  }
}
