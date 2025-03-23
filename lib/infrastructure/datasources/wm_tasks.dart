import 'package:dream_app/domain/datasource/tasks.dart';
import 'package:dream_app/infrastructure/datasources/isar_datasource.dart';
import 'package:workmanager/workmanager.dart';

class WmTasks extends Tasks {
   @override
  void registerTasks() {
    Workmanager().registerPeriodicTask(
      "back-up-task",
      "BackUpDreams",
      frequency: const Duration(minutes: 15),
      // backoffPolicy: BackoffPolicy.linear,
      // existingWorkPolicy: ExistingWorkPolicy.update,
      initialDelay: Duration.zero,
      // outOfQuotaPolicy: OutOfQuotaPolicy.run_as_non_expedited_work_request,
    );
  }

   @override
  Function getTaskCallback(String taskUniqueName) {
    switch (taskUniqueName) {
      case "back-up-task":
        return () async {
          print("exporting dreams");
          await IsarDatasource().exportDreams(dialog: false);
        };
      default:
        return () {};
    }
  }
}
