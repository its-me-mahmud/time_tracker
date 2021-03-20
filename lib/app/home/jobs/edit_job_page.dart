import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({required this.database, this.job});

  final Database database;
  final Job? job;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Job? job,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditJobPage(database: database!, job: job),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allName = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allName.remove(widget.job!.name);
        }
        if (allName.contains(_name)) {
          await showAlertDialog(
            context: context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'Ok',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final newJob = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
          await widget.database.setJob(newJob);
          Navigator.pop(context);
        }
      } on FirebaseException catch (e) {
        await showExceptionAlertDialog(
          context: context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        onSaved: (newValue) => _name = newValue!.trim(),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        initialValue: _name,
        decoration: const InputDecoration(labelText: 'Job name'),
      ),
      TextFormField(
        onSaved: (newValue) =>
            _ratePerHour = int.tryParse(newValue!.trim()) ?? 0,
        keyboardType: const TextInputType.numberWithOptions(),
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : null,
        decoration: const InputDecoration(labelText: 'Rate per hour'),
      )
    ];
  }
}
