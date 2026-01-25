# Changelog

All notable changes to Delete Soul Shard will be documented in this file.

## [2.0.1] - 2026-01-24

### Changed
- Shards determined by itemID instead of localized name.

## [2.0.0] - 2026-01-23

### Added
- **Minimum shard threshold**: Configure how many soul shards to keep in your bags. The `/dss` command will not delete shards if you are at or below this threshold.
- **Options panel**: Access settings via Interface > AddOns > DeleteSoulShard
  - Slider control to set minimum shards to keep (0-100)
  - Direct text input for precise values
- **Minimap button**: Quick access to the options panel
- **Persistent settings**: Your minimum shard preference is saved between sessions

### Changed
- Usage message now displays your current minimum shard setting

## [1.0.1]

### Fixed
- Only delete 1 shard per `/dss` command due to Blizzard API changes (`DeleteCursorItem()` can only be called once per hardware event)

### Added
- Added logo to TOC file

## [1.0.0]

### Added
- Initial release
- `/dss` slash command to delete soul shards from your bags
