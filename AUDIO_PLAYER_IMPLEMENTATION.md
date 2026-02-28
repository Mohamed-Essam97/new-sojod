# Global Persistent Audio Player Implementation

## Overview
Complete implementation of a background-capable audio player for Quran recitation with the following features:
- **Persistent playback** across all screens
- **Background playback** with Android foreground service
- **Media notifications** with playback controls
- **Global mini player** widget overlay
- **Reciter switching** during playback

## Architecture

### 1. Audio Handler (`audio_handler.dart`)
```
lib/features/audio_player/data/services/audio_handler.dart
```
- Extends `BaseAudioHandler` from `audio_service`
- Manages `just_audio` player instance
- Provides media controls (play, pause, skip, stop)
- Handles Android media notifications
- Implements queue management for surah playback

### 2. Audio Player Cubit (`audio_player_cubit.dart`)
```
lib/features/audio_player/presentation/cubit/audio_player_cubit.dart
```
- **Singleton** registered in GetIt dependency injection
- Manages global playback state
- Methods:
  - `playSurah(int surahNumber, {Reciter? customReciter})` - Play entire surah
  - `playAyah(int surahNumber, int ayahNumber, {Reciter? customReciter})` - Play single ayah
  - `changeReciter(Reciter newReciter)` - Switch reciter while maintaining position
  - `togglePlayPause()` - Play/pause toggle
  - `stop()` - Stop playback
  - `skipNext()` / `skipPrevious()` - Navigate ayahs

### 3. Playback State Entity (`playback_state.dart`)
```
lib/features/audio_player/domain/entities/playback_state.dart
```
- Immutable state using Equatable
- Properties:
  - `PlaybackMode mode` (idle, playing, paused)
  - `int? currentSurah`
  - `int? currentAyah`
  - `String? surahName`
  - `int totalAyahs`
  - `int currentIndex`
  - `String? reciterName`

### 4. Persistent Audio Player Widget (`persistent_audio_player.dart`)
```
lib/features/audio_player/presentation/widgets/persistent_audio_player.dart
```
- Global mini player overlay
- Shows: Reciter avatar, surah name, ayah info, reciter name
- Controls: Previous, Play/Pause, Next, Close
- **Change Reciter** button opens reciter selection sheet
- Progress bar showing current position in surah
- Positioned above bottom navigation (bottom: 80px)

### 5. App Shell Integration (`home_shell_screen.dart`)
```
lib/features/shell/presentation/pages/home_shell_screen.dart
```
- Uses `Stack` to overlay `PersistentAudioPlayer` on all screens
- Player remains visible during navigation
- Structure:
  ```dart
  Scaffold(
    body: Stack(
      children: [
        IndexedStack(...screens...),
        const PersistentAudioPlayer(),
      ],
    ),
  )
  ```

## Dependency Injection Setup

### In `injection.dart`:
```dart
// Audio Player (Global Singleton)
sl.registerLazySingleton<AudioPlayerCubit>(
  () => AudioPlayerCubit(sl<QuranRepository>(), sl<ReciterRepository>()),
);
```

### In `main.dart`:
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => sl<SettingsCubit>()..loadSettings()),
    BlocProvider(create: (_) => sl<AudioPlayerCubit>()),
  ],
  child: ...
)
```

## Android Configuration

### Permissions (`AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.INTERNET" />
```

### Services (`AndroidManifest.xml`):
```xml
<service
    android:name="com.ryanheise.audioservice.AudioService"
    android:foregroundServiceType="mediaPlayback"
    android:exported="true">
    <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService" />
    </intent-filter>
</service>

<receiver
    android:name="androidx.media.session.MediaButtonReceiver"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON" />
    </intent-filter>
</receiver>
```

## Usage Examples

### 1. Play Surah from Any Screen
```dart
context.read<AudioPlayerCubit>().playSurah(1); // Play Al-Fatiha
```

### 2. Play Single Ayah
```dart
context.read<AudioPlayerCubit>().playAyah(2, 255); // Play Ayat Al-Kursi
```

### 3. Change Reciter During Playback
```dart
final newReciter = Reciter(...);
context.read<AudioPlayerCubit>().changeReciter(newReciter);
// Audio continues seamlessly with new reciter from current position
```

### 4. Control Playback
```dart
final cubit = context.read<AudioPlayerCubit>();
await cubit.togglePlayPause();
await cubit.skipNext();
await cubit.skipPrevious();
await cubit.stop();
```

### 5. Listen to Playback State
```dart
BlocBuilder<AudioPlayerCubit, AudioPlaybackState>(
  builder: (context, state) {
    if (state.isPlaying) {
      return Text('Playing ${state.surahName}');
    }
    return const SizedBox.shrink();
  },
)
```

## Features

### ✅ Background Playback
- Android foreground service keeps audio playing when app is in background
- Media notifications with album art (reciter image)
- Lock screen controls

### ✅ Seamless Reciter Switching
- Stops current playback
- Regenerates audio URLs with new reciter
- Resumes from the same ayah
- No interruption in user experience

### ✅ Global Mini Player
- Always visible when audio is active
- Hides automatically when playback stops
- Shows reciter avatar (circular, 40x40)
- Displays surah name, ayah progress, reciter name
- Full playback controls
- Change Reciter button with sheet UI

### ✅ Clean Architecture
- Separation of concerns (data, domain, presentation)
- Singleton pattern for global state
- Repository pattern for data access
- BLoC pattern for state management

## Testing

### Test Background Playback:
1. Start playing a surah
2. Press home button or switch apps
3. Audio should continue playing
4. Notification should appear with controls
5. Lock screen should show media controls

### Test Navigation:
1. Start playing a surah on Quran page
2. Navigate to Home, Settings, Adhkar, etc.
3. Mini player should remain visible on all screens
4. Playback should not be interrupted

### Test Reciter Switching:
1. Start playing a surah
2. Tap "Change Reciter" button
3. Select a different reciter
4. Playback should continue from same position with new reciter
5. Mini player should update reciter name and avatar

## Dependencies

```yaml
dependencies:
  just_audio: ^0.9.40          # Audio playback
  audio_session: ^0.1.21       # Audio session management
  audio_service: ^0.18.15      # Background audio service
  flutter_bloc: ^8.1.6         # State management
  get_it: ^8.0.2               # Dependency injection
  quran_with_tafsir: ^1.0.1    # Quran data and audio URLs
```

## Notes

- Player instance is **never disposed** during app lifecycle
- Only disposed when cubit is closed (app termination)
- Screens should **never** create their own audio players
- Always use the global `AudioPlayerCubit` from context
- Reciter images must be in assets and referenced correctly
- Audio URLs are generated using `quran_with_tafsir` package

## Troubleshooting

### Audio doesn't play in background:
- Check FOREGROUND_SERVICE permissions in AndroidManifest.xml
- Ensure AudioService is properly declared
- Verify audio_service initialization in cubit

### Mini player doesn't show:
- Check that AudioPlayerCubit is provided at root level
- Verify PersistentAudioPlayer is in Stack above screens
- Ensure state is not idle when playback starts

### Reciter change doesn't work:
- Verify ReciterRepository is returning valid reciter data
- Check that reciter.id matches quran_with_tafsir reciter IDs
- Ensure changeReciter method is awaited

## Future Enhancements

- [ ] Playback speed control
- [ ] Audio seek functionality
- [ ] Download ayahs for offline playback
- [ ] Playlist management
- [ ] Audio visualization
- [ ] Sleep timer
- [ ] Auto-play next surah option
