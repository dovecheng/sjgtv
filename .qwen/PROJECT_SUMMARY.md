# SJGTV Project Summary

## 给 Qwen 的说明

**Qwen 此前参与的重构不可靠**（直接复制 base 导致大量错误、项目过复杂等）。当前改用 **Cursor** 推进，以 **`.cursor/summaries/recoding.md`** 为权威摘要与计划。请以 recoding 为准，勿再按本文件的旧内容执行。

---

## Overall Goal
SJGTV is a Flutter-based video aggregation application derived from the LibreTV project. The app focuses on providing an optimized TV viewing experience with video aggregation, search capabilities, source management, and ad filtering. The project now incorporates the base project infrastructure with Riverpod 3.x, comprehensive logging, and standardized architecture patterns.

## Key Knowledge
- **Project Name**: SJGTV (sjgtv)
- **Core Functionality**: Video aggregation search, video playback, source management, tag management, proxy management, ad filtering, TV-optimized UI
- **Current API Address**: `http://localhost:8023` with endpoints `/api/sources`, `/api/proxies`, `/api/tags`, `/api/search`
- **Current Dependencies**: Uses `dio`, `riverpod`, `isar`, `cached_network_image`, `media_kit`, `json_annotation`, `retrofit`, `logging`, etc.
- **Current State Management**: Using Riverpod 3.x with code generation for state management
- **Database**: Using Isar for local storage (migrated from Hive)
- **Logging**: Custom logging system based on root/base project to replace print statements
- **Video Playback**: Uses MediaKit for video playback with features like progress memory, seeking, volume control
- **UI Features**: TV-optimized interface with keyboard/remote navigation, focus management, category browsing
- **Ad Filtering**: Includes M3U8 ad removal functionality
- **Remote Management**: QR code-based remote access to settings and management

## Recent Actions
- Created new SJGTV Flutter project with package name com.sjg.tv
- Migrated from LibreTV project structure and requirements
- Implemented Riverpod 3.x with code generation for state management
- Integrated comprehensive logging system from root/base project
- Added all base project modules (log, converter, extension, api, model, provider, utils)
- Updated pubspec.yaml with extensive dependencies from base project
- Added VS Code configuration files (launch.json, tasks.json, settings.json) from base project
- Added script directory with build and utility scripts from base project
- Created source management functionality with Riverpod providers
- Created video models and services
- Removed all copyright information from copied code
- Added necessary dependencies for video playback, networking, storage, and internationalization

## Current Plan
1. [DONE] Create SJGTV Flutter project
2. [DONE] Set package name to com.sjg.tv
3. [DONE] Transfer LibreTV project knowledge and requirements
4. [DONE] Create custom logging system based on base project
5. [DONE] Add Riverpod 3.x state management with code generation
6. [DONE] Add VS Code configuration files from base project
7. [DONE] Copy base project modules (log, converter, extension, etc.)
8. [DONE] Update pubspec.yaml with base project dependencies
9. [DONE] Add script directory from base project
10. [IN PROGRESS] Implement source management functionality
11. [TODO] Implement video playback with MediaKit
12. [TODO] Create TV-optimized UI components
13. [TODO] Implement search functionality
14. [TODO] Add ad filtering capabilities
15. [TODO] Develop proxy management system
16. [TODO] Create tag management system

## GitHub Workflow
- Automated workflow for building and releasing the app when pushing tags
- Workflow builds APK or App Bundle with signing
- Includes caching, verification, and release automation
- Supports both manual dispatch and automatic triggers
- For local builds: tag the commit and build APK manually

---

## Summary Metadata
**Update time**: 2026-01-30T17:40:00.000Z

## Daily Work Log
今天的工作重点是分析当前SJGTV项目的状态，并制定了新的重构计划。我们认识到直接复制base项目导致了过多的错误和复杂性，因此决定采用模块化方法，将项目分为base模块和app模块。新的计划将循序渐进地进行开发，每一步都会检查和修复错误，确保项目稳定性和可维护性。

此外，我们还补充了以下细节：
- 从root项目复制 `.cursor`, `.vscode`, `.qwen`, `.gemini` 配置到**新项目的base模块**
- 保留与base项目相关和通用的运行方式和终端任务
- **重要：所有配置都只是复制到新项目，绝不会修改root里的任何东西**
- 采用渐进式开发方法，确保每一步都经过错误检查和修复
