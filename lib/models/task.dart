// file yang berada di dalam folder model biasanya disebut dengan Data Class.
// biasanya, data class dipresentasikan dgn bundling. dgn mengimport library Parcelize = Android Native

class Task {
  final String name;
  final int duration;
  final DateTime deadline;

  Task({required this.name, required this.duration, required this.deadline});

  // utk membuat suatu turunan objek. contohnya adalah adanya function di dalam function
  @override
  String toString() {
    return 'Task: {name: $name, duration: $duration, deadline: $deadline}';
  }
}
