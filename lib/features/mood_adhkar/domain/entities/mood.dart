enum Mood {
  anxious,
  grateful,
  sad,
  motivated;

  String getLocalizedKey() {
    switch (this) {
      case Mood.anxious:
        return 'moodAnxious';
      case Mood.grateful:
        return 'moodGrateful';
      case Mood.sad:
        return 'moodSad';
      case Mood.motivated:
        return 'moodMotivated';
    }
  }
}
