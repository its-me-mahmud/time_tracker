import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker/app/home/models/entry.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

import 'entry_list_item.dart';
import 'entry_page.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.database, required this.job});

  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      EditJobPage.show(context, database: database, job: job),
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
            body: _buildContent(context, job),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  EntryPage.show(context, database: database, job: job),
              child: Icon(Icons.add),
            ),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job? job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job!),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}