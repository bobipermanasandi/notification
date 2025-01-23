enum MyWorkmanager {
  oneOff("task-identifier", "task-identifier"),
  periodic("com.safna.notification", "com.safna.notification");

  final String uniqueName;
  final String taskName;

  const MyWorkmanager(this.uniqueName, this.taskName);
}
