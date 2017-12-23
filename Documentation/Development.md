# Development Workflow

## Branching Strategy
We are following `git-flow` branching strategy.
- **Master branch** - Stable release branch with tag
- **Development branch** - a branch with new features
- **Hotfix branch** - a bug fixes on release, it should branch out from master and merged into Master and Development branch
- **Feature branch** - a branch where you development new feature, naming `feature/< FEATURE_NAME >`
- **Enhancement branch** - a branch where you modify existing feature, naming `enhancement/< ENHANCEMENT_NAME >`

## Understanding of folder structure
### Constants and Extensions
This is all the constants that need to be defined and the extensions for existing types.

### Models
This is all calculations and measurements related functions that represent the core of LOC8.

### Graphics
Graphics folder contain every thing related to graphic components and functions such as drawing etc.

### Helpers
 Helpers simple are data sources and services that shares across the app.

### UI
All files that relates to UI, this includes `View` and `ViewController`.  
Relation: `View` -> `ViewController`
1. Cells
2. Custom Views
3. View Controllers - Controllers for views, including changing text and such.

## How to release
1. merge `development` to `master`
2. create a release on `github` with auto tagging (possibly automate it)
