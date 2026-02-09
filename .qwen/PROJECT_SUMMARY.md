# Project Summary

## Overall Goal
Analyze the LibreTV project (a Flutter-based video aggregation app) and plan a migration to a new project with Riverpod for state management, potentially replacing Hive database with a more modern solution, and integrating a custom logging system.

## Key Knowledge
- **Project Name**: sjgtv（原 LibreTV/libretv_app）
- **Core Functionality**: Video aggregation search, video playback, source management, tag management, proxy management, ad filtering, TV-optimized UI
- **Current API Address**: `http://localhost:8023` with endpoints `/api/sources`, `/api/proxies`, `/api/tags`, `/api/search`
- **Current Dependencies**: Uses `dio`, `provider`, `hive`, `cached_network_image`, `media_kit`, `shelf`, etc.
- **Current State Management**: Limited use of `provider`, mostly direct Hive database operations
- **Database**: Currently uses Hive but considering alternatives like Drift (SQLite-based) due to Isar not supporting Web
- **Logging**: Currently uses `print` statements, planned to migrate to custom logging system at `../root/base/lib/src/log/`
- **Database Decision**: Hive is still viable for the project despite considering alternatives
- **Video Playback**: Uses MediaKit for video playback with features like progress memory, seeking, volume control
- **UI Features**: TV-optimized interface with keyboard/remote navigation, focus management, category browsing
- **Ad Filtering**: Includes M3U8 ad removal functionality
- **Remote Management**: QR code-based remote access to settings and management
- **GitHub Workflow**: Automated build and release process for APK generation with signing
- **Local Build Process**: For local compilation, tag the commit and build APK manually

## Recent Actions
- Completed comprehensive analysis of LibreTV project structure, functionality, and dependencies
- Identified core features, API endpoints, and current technology stack
- Created sample Riverpod providers for Source and Proxy management (`source_provider.dart`, `proxy_provider.dart`)
- Recognized that current project has limited Provider usage, mostly direct Hive operations
- Acknowledged that Isar is no longer maintained and doesn't support Web, considering Drift as alternative
- Created new Flutter project structure (sjgtv)
- Added Riverpod, Hive and Logger dependencies to the new project
- Implemented complete Riverpod integration in the new project
- Decided to continue using Hive as the database solution for now
- Integrated custom logging system to replace print statements
- Created basic application architecture with main.dart, providers, and screens structure
- Documented GitHub workflow for automated APK builds and releases
- Updated documentation to include local build process: tag the commit and build APK manually

## Current Plan
1. [DONE] Analyze LibreTV project core functionality
2. [DONE] Identify API addresses and endpoints
3. [DONE] Record project dependencies
4. [DONE] Understand current state management approach
5. [DONE] Plan Riverpod migration strategy
6. [DONE] Create sample Riverpod providers
7. [DONE] Create new Flutter project and add dependencies
8. [DONE] Complete full Riverpod integration in new project
9. [DONE] Decide on database solution (continue with Hive)
10. [DONE] Integrate custom logging system to replace print statements
11. [DONE] Create basic application architecture

## GitHub Workflow
- Automated workflow for building and releasing the app when pushing tags
- Workflow builds APK or App Bundle with signing
- Includes caching, verification, and release automation
- Supports both manual dispatch and automatic triggers
- For local builds: tag the commit and build APK manually

---

## Summary Metadata
**Update time**: 2026-01-30T16:54:15.166Z