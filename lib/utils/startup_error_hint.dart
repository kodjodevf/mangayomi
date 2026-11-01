/// What a database error at launch means and what to do about it, for the
/// errors whose cause is on the machine rather than in the app; null for
/// the others.
///
/// In English: it shows before the app, and its language setting, has
/// loaded.
String? startupErrorHint(String error) {
  // libmdbx refuses a volume exported over NFS, where macOS asks every
  // operation for a read flag it does not pass (#652).
  if (error.contains('MdbxError (15)') ||
      error.contains('Block device required')) {
    return 'The disk holding Mangayomi\'s data is shared over NFS, and its '
        'database cannot open on a shared disk. Stop sharing that disk '
        '(remove it from /etc/exports, or run "sudo nfsd disable" if nothing '
        'else needs it), then open Mangayomi again.';
  }
  if (error.contains('MdbxError (13)') || error.contains('Permission denied')) {
    return 'Mangayomi is not allowed to open its data folder. Check that '
        'your user owns that folder and can write to it, then open '
        'Mangayomi again.';
  }
  return null;
}
