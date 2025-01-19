import 'package:dream_app/presentation/blocs/dream_form/dream_form_bloc.dart';
import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:dream_app/presentation/delegates/dream_search_delegate.dart';
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
  FloatingActionButton? getFab(int index, BuildContext context) {
    switch (index) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            context.read<DreamFormBloc>().add(const FormInit());
            context.push("/dream/0");
          },
          child: const Icon(Icons.add),
        );
      case 1:
        return null;

      case 2:
        return FloatingActionButton(
          onPressed: () {
            context.read<DreamHomeBloc>().add(const ExportDreams());
          },
          child: const Icon(Icons.download),
        );

      case 3:
        return FloatingActionButton(
          onPressed: () {
            context.read<DreamHomeBloc>().add(ImportDreams(context));
          },
          child: const Icon(Icons.upload_file_rounded),
        );
      default:
        return null;
    }
  }

  final routes = const <Widget>[
    HomeView(),
    CalendarView(),
    // SearchView(),
    StatsView(),
    ConfigView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dream_app'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DreamSearchDelegate(context),
              );
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
      ),
    );
  }
}
