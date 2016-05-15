# Development Workflow

## Branching Strategy
We are following `git-flow` branching strategy.
- **Master branch** - Stable release branch with tag
- **Development branch** - Development branch with new features
- **Hotfix branch** - Hotfix branch is a bug fixes on release, it should branch out from master and merged into Master and Development branch
- **Feature branch** - Feature branch is branch where you development new feature, naming `feature/< FEATURE_NAME >`

## Understanding of folder structure
### Constants and Extensions


### Models
This is all calculations and measurements related functions that represent the core of LOC8.

1. Geometry
2. Physics
3. Measurement
4. Vector3D
5. Rotation3D
6. Heading
7. MotionActivity
8. Estimation
9. TrackingSession
10. Filter

### Graphics
Graphics folder contain every thing related to graphic components and functions such as drawing etc.

1. Cylinder
2. Path
3. PathManager

### Helpers
 Helpers simple are data sources and services that shares across the app.

 1. MotionDetector
 2. SensorsManager
 3. SettingsService
 4. LogManager
 5. MultipeerManager

### UI
All files that relates to UI, this includes `View` and `ViewController`.  
Relation: `View` -> `ViewController`
1. Cells
2. Custom Views
3. View Controllers - Controllers for views, including changing text and such.

## How to release
1. merge `development` to `master`
2. create a release on `github` with auto tagging (possibly automate it)
