class APIPath {
  static String job({required String uid, required String jobId}) {
    return 'users/$uid/jobs/$jobId';
  }

  static String jobs({required String uid}) => 'users/$uid/jobs';

  static String entry({required String uid, required String entryId}) {
    return 'users/$uid/entries/$entryId';
  }

  static String entries({required String uid}) => 'users/$uid/entries';
}
