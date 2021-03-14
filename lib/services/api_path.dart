class ApiPath {
  static String job({required String uid, required String jobId}) {
    return 'users/$uid/jobs/$jobId';
  }

  static String jobs({required String uid}) => 'users/$uid/jobs';
}
