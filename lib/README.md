# CareLink offline prototype

CareLink is a self-contained Flutter resident-community demo. It runs without
network access, a Firebase project, credentials, or backend setup. All demo
state lives in memory and resets when the application restarts.

## Run the prototype

From the repository root:

```sh
flutter pub get
flutter run -d linux
```

The application starts at property selection. Choose a property to open the
dashboard and its Home, Issues, Projects, Events, and Profile tabs.

## Structure

```text
lib/
  core/                         Shared theme and spacing
  features/
    community/presentation/     Home community feed
    dashboard/presentation/     Bottom-navigation hub
    events/                     Event model and RSVP screen
    profile/presentation/       Resident profile and activity
  models/                       Plain Dart domain models
  screens/                      Issue, post, project, and property screens
  shared/services/              In-memory demo repositories and seed data
  widgets/                      Reusable cards and progress components
```

`MockCommunityStore` owns the shared demo session. `MockPostRepository`,
`MockIssueRepository`, `MockProjectRepository`, `MockEventRepository`, and
`MockProfileRepository` provide typed feature operations. They notify listeners
when local state changes, so reactions, comments, reports, votes, and event
RSVPs update across tabs. New posts and reports, vote changes, and RSVPs are
local-only.

The seed dataset contains ten posts, seven issues, six projects, and events for
multiple properties. Choose a different property from the Home header to filter
the feed and other property-scoped screens.

## Demo limitations

This is an offline hackathon prototype, not durable multi-user storage.
Changes disappear on restart and are not synchronized between devices. Image
uploads, live notifications, authentication, and server-side moderation are
intentionally not configured.
