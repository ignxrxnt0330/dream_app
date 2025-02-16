import 'package:dream_app/domain/entities/dream/dream.dart';
import 'package:dream_app/infrastructure/auth/biometrics.dart';
import 'package:dream_app/presentation/blocs/dream_home/dream_home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomDreamListTile extends StatelessWidget {
  const CustomDreamListTile({
    super.key,
    required this.dream,
  });

  final Dream dream;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            dream.title ?? "asd",
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Text(dream.formattedDate),
        IconButton(
          icon: dream.isFav ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          onPressed: () {
            context.read<DreamHomeBloc>().add(ToggleFavDream(dreamId: dream.id));
          },
        ),
      ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            !dream.hidden ? dream.description : "...",
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
          if (dream.tags != null)
            Wrap(
              spacing: 5,
              children: !dream.hidden ? dream.tags!.map((tag) => Chip(label: Text(tag))).toList() : dream.tags!.map((tag) => const Chip(label: Text("..."))).toList(),
            ),
          if (dream.names != null)
            Wrap(
              spacing: 5,
              children: !dream.hidden ? dream.names!.map((name) => Chip(label: Text(name))).toList() : dream.names!.map((tag) => const Chip(label: Text("..."))).toList(),
            ),
        ],
      ),
      onTap: () async {
        if (dream.hidden) {
          bool allowed = await Biometrics.authenticate();
          if (!allowed) return;
        }
        if (!context.mounted) return;
        context.push("/dream/${dream.id}");
      },
      onLongPress: () {
        // show dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(dream.title ?? "delete dream"),
              content: const Text("do you really wanna delete this dream ¿?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("nah"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<DreamHomeBloc>().add(RemoveDream(dreamId: dream.id));
                    Navigator.of(context).pop();
                  },
                  child: const Text("ye"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
