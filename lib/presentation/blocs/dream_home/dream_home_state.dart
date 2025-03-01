part of 'dream_home_bloc.dart';

class DreamHomeState extends Equatable {
  final List<Dream> dreams;
  final int offset;
  final bool isLoading;
  final bool endReached;
  final String order;
  final bool asc;
  final bool fav;
  final bool hidden;

  const DreamHomeState({
    required this.dreams,
    this.offset = 0,
    this.isLoading = false,
    this.endReached = false,
    this.order = "date",
    this.asc = false,
    this.fav = false,
    this.hidden = false,
  });

  DreamHomeState copyWith({
    List<Dream>? dreams,
    bool? isLoading,
    int? offset,
    bool? endReached,
    String? order,
    bool? asc,
    bool? fav,
    bool? hidden,
  }) =>
      DreamHomeState(
        dreams: dreams ?? this.dreams,
        isLoading: isLoading ?? this.isLoading,
        offset: offset ?? this.offset,
        endReached: endReached ?? this.endReached,
        order: order ?? this.order,
        asc: asc ?? this.asc,
        fav: fav ?? this.fav,
        hidden: hidden ?? this.hidden,
      );

  @override
  List<Object> get props => [dreams, isLoading, endReached, order, asc, fav, hidden];

  @override
  String toString() {
    return 'DreamHomeState{dreams: $dreams, order: $order, asc: $asc, fav: $fav, hidden: $hidden, offset: $offset, isLoading: $isLoading, endReached: $endReached}';
  }
}
