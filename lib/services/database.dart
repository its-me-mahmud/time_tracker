import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);

  final String? uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> createJob(Job job) {
    final path = ApiPath.job(uid: uid!, jobId: 'job_abc');
    return _service.setData(path: path, data: job.toMap());
  }

  @override
  Stream<List<Job>> jobsStream() {
    final path = ApiPath.jobs(uid: uid!);
    return _service.collectionStream(
      path: path,
      builder: (data) => Job.fromMap(data),
    );
  }
}
