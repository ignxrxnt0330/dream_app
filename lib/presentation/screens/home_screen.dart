import 'package:dream_app/l10n/app_localizations.dart';
import 'package:dream_app/presentation/blocs/blocs.dart';
import 'package:dream_app/presentation/widgets/shared/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:dream_app/presentation/views/views.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'HomeScreen';
  final int index;

  const HomeScreen({super.key, required this.index});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  bool _showReplace = false;
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _replaceFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _replaceController = TextEditingController();

  Widget? getFab(int index, BuildContext context) {
    switch (index) {
      case 0:
        return GestureDetector(
            onLongPress: () {
              final int lastEditedId =
                  context.read<DreamFormBloc>().state.lastEdited.dream.id;
              context.read<DreamFormBloc>().add(ResumeEditDream());
              context
                  .read<DreamFormBloc>()
                  .stream
                  .firstWhere((state) => state.dream.id == lastEditedId)
                  .then((state) {
                if (!context.mounted) return;
                if (state.dream.hidden) {
                  context.push("/bio_validate/dream/$lastEditedId");
                  return;
                }
                context.push("/dream/$lastEditedId");
              });
            },
            child: FloatingActionButton(
              onPressed: () {
                context.read<DreamFormBloc>().add(const FormInit());
                context.push("/dream/0");
              },
              child: const Icon(Icons.add),
            ));
      case 1:
        return FloatingActionButton(
          onPressed: () {
            var bloc = context.read<DreamCalendarBloc>();
            // showDatePicker(context: context, firstDate: bloc.state.firstDate ?? DateTime.now(), lastDate: bloc.state.lastDate ?? DateTime.now()).then(
            showDatePicker(
                    context: context,
                    firstDate: DateTime(2020, 1, 1),
                    lastDate: DateTime(2069, 4, 20),
                    initialEntryMode: DatePickerEntryMode.input)
                .then(
              (value) {
                if (value == null) {
                  return;
                }
                bloc.add(FetchDreamsOnDate(value));
              },
              onError: (err) {
                debugPrint(err);
              },
            );
          },
          child: const Icon(Icons.date_range),
        );

      // case 3:
      //   return FloatingActionButton(
      //     onPressed: () {
      //       Restart.restartApp();
      //     },
      //     child: const Icon(Icons.refresh),
      //   );
      default:
        return null;
    }
  }

  final routes = const <Widget>[
    HomeView(),
    CalendarView(),
    StatsView(),
    ConfigView(),
  ];

  final actions = [
    (BuildContext context) {
      context.read<DreamHomeBloc>().add(const RefreshDreams());
    },
    (BuildContext context) {
      var calendarBloc = context.read<DreamCalendarBloc>();
      calendarBloc.add(const FetchBracket());
      calendarBloc.add(const FetchDates());
      calendarBloc.add(FetchDreamsOnDate(calendarBloc.state.selectedDate));
    },
    (BuildContext context) {
      final int bracket = context.read<DreamStatsBloc>().state.bracket;
      context.read<DreamStatsBloc>().add(FetchStats(bracket: bracket));
    },
    (BuildContext context) {},
  ];

  @override
  void initState() {
    _searchFocusNode.addListener(() {
      //FIXME: inputs / botones buscar
      if (!_searchFocusNode.hasFocus && !_replaceFocusNode.hasFocus) {
        _isSearching = false;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_isSearching,
      onPopInvokedWithResult: (_, __) {
        if (_isSearching) {
          _isSearching = false;
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: _showReplace ? 100 : 50,
          title: _isSearching
              ? SafeArea(
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          context
                              .read<DreamHomeBloc>()
                              .add(QueryChanged(query: value));
                        },
                        onSubmitted: (String value) {
                          context
                              .read<DreamHomeBloc>()
                              .add(QueryChanged(query: value));
                          _isSearching = false;
                          setState(() {});
                        },
                      ),
                      BlocBuilder<DreamHomeBloc, DreamHomeState>(
                        builder: (context, state) {
                          return Visibility(
                            visible: _isSearching && _showReplace,
                            child: TextField(
                              autofocus: false,
                              controller: _replaceController,
                              focusNode: _replaceFocusNode,
                              onSubmitted: (String value) {
                                context.read<DreamHomeBloc>().add(
                                    ResultsReplaced(
                                        replace:
                                            _replaceController.value.text));
                                context
                                    .read<DreamHomeBloc>()
                                    .add(QueryChanged(query: ''));
                                _isSearching = false;
                                _showReplace = false;
                                _replaceController.clear();
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : Text(localizations.appTitle,
                  style: TextStyle(fontFamily: "Consolas")),
          actions: [
            BlocBuilder<DreamHomeBloc, DreamHomeState>(
              builder: (context, state) {
                return Visibility(
                  visible: state.query != '',
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context
                          .read<DreamHomeBloc>()
                          .add(QueryChanged(query: ''));
                      setState(() {});
                    },
                  ),
                );
              },
            ),
            BlocBuilder<DreamHomeBloc, DreamHomeState>(
              builder: (context, state) {
                return Visibility(
                  visible: _isSearching,
                  child: IconButton(
                    icon: Icon(Icons.find_replace_sharp),
                    onPressed: () {
                      _showReplace = !_showReplace;
                      _replaceFocusNode.requestFocus();
                      setState(() {});
                    },
                  ),
                );
              },
            ),
            Visibility(
              visible: _isSearching,
              child: IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  //TODO: toggle replace
                  //TODO: show filter modal
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _isSearching = true;
                if (widget.index != 0) context.replace('/home/0');
                setState(() {});
              },
            ),
          ],
        ),
        body: IndexedStack(
          // keeps state
          index: widget.index,
          children: routes,
        ),
        floatingActionButton: getFab(widget.index, context),
        bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: widget.index,
          actions: actions,
        ),
      ),
    );
  }
}
