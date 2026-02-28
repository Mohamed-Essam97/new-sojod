# Quick Start: Global Audio Player

## ✅ What's Been Implemented

### 1. **Global AudioPlayerCubit** (Singleton)
- Manages all audio playback across the app
- Registered in `injection.dart` as `LazySingleton`
- Provided at root in `main.dart` via `MultiBlocProvider`

### 2. **Background Playback Support**
- `audio_service` integration with `QuranAudioHandler`
- Android foreground service configuration
- Media notifications with controls
- Lock screen playback controls

### 3. **Persistent Mini Player**
- Overlays all screens in `HomeShellScreen`
- Shows: Reciter avatar, surah name, ayah progress, reciter name
- Controls: Previous, Play/Pause, Next, Close, Change Reciter
- Auto-hides when playback stops
- Positioned above bottom nav (80px from bottom)

### 4. **Reciter Switching**
- Tap "Change Reciter" button in mini player
- Opens reciter selection sheet
- Seamlessly continues playback from current position
- Updates notification with new reciter info

## 🚀 How to Use

### Start Playing a Surah:
```dart
// From any screen with access to context
context.read<AudioPlayerCubit>().playSurah(1); // Al-Fatiha
```

### Play Single Ayah:
```dart
context.read<AudioPlayerCubit>().playAyah(2, 255); // Ayat Al-Kursi
```

### Control Playback:
```dart
final cubit = context.read<AudioPlayerCubit>();
cubit.togglePlayPause();  // Play or pause
cubit.skipNext();         // Next ayah
cubit.skipPrevious();     // Previous ayah
cubit.stop();             // Stop playback
```

### Change Reciter:
```dart
// Tap "Change Reciter" button in mini player
// OR programmatically:
final newReciter = sl<ReciterRepository>().getReciterById('Mishary_Alafasy');
context.read<AudioPlayerCubit>().changeReciter(newReciter);
```

## 📂 Key Files

| File | Purpose |
|------|---------|
| `audio_handler.dart` | Background audio service handler |
| `audio_player_cubit.dart` | Global playback state management |
| `playback_state.dart` | Playback state entity |
| `persistent_audio_player.dart` | Mini player UI widget |
| `home_shell_screen.dart` | App shell with Stack overlay |
| `injection.dart` | DI registration |
| `main.dart` | Root BlocProvider setup |

## 🔧 Configuration

### Android (AndroidManifest.xml):
```xml
<!-- Already configured ✅ -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
<uses-permission android:name="android.permission.WAKE_LOCK" />

<service android:name="com.ryanheise.audioservice.AudioService" ... />
<receiver android:name="androidx.media.session.MediaButtonReceiver" ... />
```

### Dependencies (pubspec.yaml):
```yaml
# Already added ✅
audio_service: ^0.18.15
just_audio: ^0.9.40
audio_session: ^0.1.21
```

## 🎯 Integration Points

### Existing Integrations:
1. ✅ **Quran Reader Page**: Can call `playSurah()` when user taps "Play Surah" button
2. ✅ **Ayah Context Menu**: Can call `playAyah()` when user selects "Play Ayah"
3. ✅ **Quran Page**: Auto-plays when navigating to reader with `initialSurah` parameter
4. ✅ **All Screens**: Mini player automatically shows when playback starts

### Where Audio Player Appears:
- **Home Page**: Mini player overlay
- **Quran Page**: Mini player overlay
- **Adhkar Page**: Mini player overlay
- **Settings Page**: Mini player overlay
- **Background/Notifications**: Media controls

## 📱 User Flow

1. User opens Quran page
2. User selects a surah → navigates to reader
3. Reader auto-plays (if `initialSurah` param provided)
4. Mini player appears at bottom
5. User navigates to Home → mini player still visible
6. User locks screen → notification controls available
7. User taps "Change Reciter" → sheet opens
8. User selects new reciter → playback continues seamlessly
9. User taps close → playback stops, mini player hides

## 🧪 Test Checklist

- [ ] Play surah from Quran reader
- [ ] Navigate to different screens while playing
- [ ] Verify mini player shows on all screens
- [ ] Lock screen and check media controls
- [ ] Switch to another app (audio should continue)
- [ ] Tap skip next/previous
- [ ] Tap play/pause toggle
- [ ] Change reciter mid-playback
- [ ] Close playback (mini player should hide)
- [ ] Restart app (no player should show initially)

## 🐛 Known Limitations

1. **iOS Background Audio**: Requires additional configuration (Info.plist audio mode)
2. **Seek Bar**: Not implemented yet (could be added to mini player)
3. **Playback Speed**: Not available (future enhancement)
4. **Offline Mode**: Requires downloading audio files first

## 🎨 UI Details

### Mini Player Design:
- **Background**: Teal gradient (AppColors.teal → AppColors.tealDark)
- **Height**: ~100px (auto-adjusts to content)
- **Position**: 80px from bottom (above nav bar)
- **Elevation**: 12 (shadow)
- **Border Radius**: 16px
- **Padding**: 12px all sides

### Components:
1. **Reciter Avatar**: 40x40 circular image (left)
2. **Info Section**: Surah name (Arabic), ayah progress, reciter name
3. **Change Reciter Button**: Right-aligned, white semi-transparent bg
4. **Control Row**: Previous, Play/Pause (larger), Next, Close
5. **Progress Bar**: Linear indicator showing position in surah

## 💡 Tips

- Always use `context.read<AudioPlayerCubit>()` to access player
- Never create local `AudioPlayer()` instances for Quran audio
- Use `BlocBuilder<AudioPlayerCubit, AudioPlaybackState>` to react to state changes
- Mini player automatically manages its visibility (no manual show/hide needed)
- Reciter images must be in assets for avatar display

## 🔗 Related Files

See `AUDIO_PLAYER_IMPLEMENTATION.md` for complete technical documentation.
