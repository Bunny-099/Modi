# Replace Dummy Songs with Local Assets and Enable Playback

The goal is to remove the current dummy data from the `HomeScreen` and replace it with actual local audio files found in `assets/audio/`. Additionally, we need to implement the playback logic so that tapping a song actually plays it.

## User Review Required

> [!IMPORTANT]
> I will be clearing the existing Hive music box to remove the current dummy data. This means any previous "recently played" or "favorite" status will be lost.

## Proposed Changes

### Core Constants & Data Loading

#### [asset_paths.dart](file:///D:/Project_apne/modi/lib/core/constants/asset_paths.dart)
- Clean up and add paths for the new audio files.

#### [default_music_loader.dart](file:///D:/Project_apne/modi/lib/core/database/default_music_loader.dart)
- Update `loadDefaultData` to clear the box first (for this migration).
- Add the 4 local songs: `dope_shop.mp3`, `maja_nahi_aa_raha.mp3`, `Saiyaara.mp3`, `teri_meri_prem_kahani.mp3`.

---

### Player Feature Implementation

#### [NEW] [player_provider.dart](file:///D:/Project_apne/modi/lib/features/player/providers/player_provider.dart)
- Create a `StateNotifier` to manage the current song and playback state (playing, position, duration).
- Use `AudioPlayerService` for the actual playback logic.

#### [home_screen.dart](file:///D:/Project_apne/modi/lib/features/home/presentation/pages/home_screen.dart)
- Update tap handlers to call `playSong` from the new `playerProvider`.
- Navigate to the `PlayerScreen`.

#### [player_screen.dart](file:///D:/Project_apne/modi/lib/features/player/presentation/pages/player_screen.dart)
- Connect UI elements (Title, Artist, Slider, Play/Pause button) to `playerProvider`.

---

### UI & Models

#### [music_model.dart](file:///D:/Project_apne/modi/lib/shared/models/music_model.dart)
- Ensure `MusicModel` is suitable for the new assets. (Already seems fine).

## Verification Plan

### Automated Tests
- N/A (Project currently lacks a robust testing suite for audio).

### Manual Verification
1. **Initial Load**: Run the app and verify that the `HomeScreen` shows the 4 new songs instead of the old dummy ones.
2. **Playback**: Tap a song and verify that:
    - The `PlayerScreen` opens.
    - The correct song info is displayed.
    - Audio starts playing.
    - The progress bar moves.
    - Play/Pause button works.
