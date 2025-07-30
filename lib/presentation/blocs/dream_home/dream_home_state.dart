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
  final int type;
  final int count;

  const DreamHomeState({
    required this.dreams,
    this.offset = 0,
    this.isLoading = false,
    this.endReached = false,
    this.order = "date",
    this.asc = false,
    this.fav = false,
    this.hidden = false,
    this.type = 3,
    this.count = 0,
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
    int? type,
    int? count,
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
        type: type ?? this.type,
        count: count ?? this.count,
      );

  @override
  List<Object> get props => [dreams, isLoading, endReached, order, asc, fav, hidden, type, count];

  @override
  String toString() {
    return 'DreamHomeState{dreams: $dreams,count: $count, order: $order, asc: $asc, fav: $fav, hidden: $hidden, type. $type, offset: $offset, isLoading: $isLoading, endReached: $endReached}';
  }
}
