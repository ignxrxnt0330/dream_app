import 'package:flutter/material.dart';

class SleepQualityView extends StatefulWidget {
  static const name = 'sleep_quality_view';
  const SleepQualityView({super.key});

  @override
  State<SleepQualityView> createState() => _SleepQualityViewState();
}

class _SleepQualityViewState extends State<SleepQualityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          //FIXME: styling
          const Text('Sleep Quality'),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView(
              //TODO: animated builder
              children: const [
                _CustomListTile(
                  title: 'very bad',
                  icon: Icons.thumb_down_sharp,
                ),
                SizedBox(
                  height: 20,
                ),
                _CustomListTile(
                  title: 'bad',
                  icon: Icons.thumb_down_outlined,
                ),
                SizedBox(
                  height: 20,
                ),
                _CustomListTile(
                  title: 'meh',
                  icon: Icons.sentiment_neutral,
                ),
                SizedBox(
                  height: 20,
                ),
                _CustomListTile(
                  title: 'good',
                  icon: Icons.thumb_up_outlined,
                ),
                SizedBox(
                  height: 20,
                ),
                _CustomListTile(
                  title: 'nice',
                  icon: Icons.thumb_up_sharp,
                ),
                SizedBox(
                  height: 20,
                ),
                _CustomListTile(
                  title: 'excellent',
                  icon: Icons.sentiment_very_satisfied,
                ),
                SizedBox(
                  height: 20,
                ),
                _CustomListTile(
                  title: 'perfect',
                  icon: Icons.star_rounded,
                ),
              ],
            ),
          )
          
        ],
      ),
    ));
  }
}

class _CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _CustomListTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {

      },
    );
  }
}
