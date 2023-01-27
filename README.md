# Naai | Flutter App
This is a ready-to-use Flutter project template, built using Flutter 3.0.2. This project aims to provide a solid headstart to any developer with Flutter development, making most essentials available right out of the box. This is also an attempt to bring some consistency across different projects wrt the Flutter configuration.

## Important Details

|Framework| Version |
|--|--|
|Flutter| 3.0.2  |

## Setup Instructions

> Note: Not following these steps could likely result in rejected merge requests. Please make sure you follow the correct setup procedure.

Make sure the installed Flutter version is [v3.0.2](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.0.2-stable.zip). Using a different version is likely to result in conflicts and issues that we'd like to avoid. We try to keep pace with new Flutter releases and will keep updating the used version regularly. But it is critically important that all developers use the same version. After you've [installed Flutter](https://flutter.dev/docs/get-started/install) and [set up git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), follow these instructions to get working on the app:

1. Clone the repo into your folder (or through your IDE)
2. Open the project in your IDE
3. Make sure you check out branch `development` to see the latest working code
5. Create/checkout the branch for your task and write wonderful code


### Branch hierarchy
|Status| Branch Name | Remarks |
|--|--|--|
|Production| `main` ||
|Staging| `development` ||
|Feature/Task| `feature` |The branch name (case sensitive) must match that of the Jira task/issue that it corresponds to
In the development phase, for any Jira task, a corresponding branch with the same name as the task: e.g.`auth` must be created from the branch `development`.

For a sub-task, the branch should be pulled from the branch of the parent task and not directly from `development`. This helps keep the development in sync.

## Code Quality

Nobody wants to read a jumbled up mesh of variables and expressions in a file. We write tidy, readable code that works. We have a slightly customized set of rules that are best explained here:

https://dart.dev/guides/language/effective-dart/style

We expect these basic rules to be followed and have set up hooks and pipelines (WIP) to ensure that our code reflects that. Command #4 in the setup instructions sets up pre-commit and pre-push Git hooks that make sure that your code is valid before pushing.

## Authors
- [Pratik Nath Tiwari](https://github.com/pratik97179)