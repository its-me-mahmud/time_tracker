class Job {
  const Job({required this.id, required this.name, required this.ratePerHour});

  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    return Job(
      id: documentId,
      name: data['name'],
      ratePerHour: data['ratePerHour'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
