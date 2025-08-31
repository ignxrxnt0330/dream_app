part of 'dream_search_bloc.dart';

abstract class DreamSearchEvent {
  const DreamSearchEvent();
}

class SearchDreams extends DreamSearchEvent {
  final String query;
  final int limit;
  final int offset;
  final List<String>? names;
  const SearchDreams({
    required this.query,
    this.limit = 10,
    this.offset = 0,
    this.names,
  });
}

class ScrollSearch extends DreamSearchEvent {
  final String query;
  final int limit;
  final int offset;
  final List<String>? names;
  const ScrollSearch({
    required this.query,
    this.limit = 10,
    this.offset = 0,
    this.names,
  });

}

class SearchScrollChange extends DreamSearchEvent {
  final double scroll;
  const SearchScrollChange({
      required this.scroll,
      });
}
