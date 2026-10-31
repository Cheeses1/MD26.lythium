# Sandy Training Map — Lythium

Sandy Training Map is an Arma 3 multiplayer training mission built for the Lythium terrain. It provides training-area equipment, vehicle and logistics tools, ACE fortification, and arsenals. The mission is intended to be run with its matching Arma 3 mod set.

This guide covers what players can do in the mission, what mission makers can change, how the mission files fit together, and how to build and publish a release from VS Code and GitHub.

## For players

### Before joining

- Have Arma 3 and the mods required by the mission installed and enabled.
- Use one of the repository's Arma 3 preset files to identify and install the intended training mod set:
  - `Arma 3 Preset Training MD 2026.html`
  - `Arma 3 Preset Training MD 2026 Compat.html`
- The mission uses ACE and CBA features and refers to many mod-provided vehicles and equipment. A partial or different mod set can result in missing items or vehicles.

The mission is configured for up to 150 players. AI is disabled in the mission settings, and the mission sets a 10-second respawn delay.

### Using an arsenal

Use the arsenal boxes placed around the training area. The mission initializes the named arsenal objects with a shared list of allowed equipment. If an item is not available, it may not be included in the list or its required mod may not be loaded.

### Spawning vehicles

Use ACE interaction on the designated laptops around the training area. The available options include:

- **Ground Spawner** for the configured ground vehicles.
- **Helicopter spawner** for the configured rotor-wing aircraft.
- **Jets Spawner** for the configured fixed-wing aircraft.
- Specialized spawners for medical vehicles, repair/rearm/refuel vehicles, and fortification trucks.

In the vehicle-spawner window, choose a vehicle, review its information, and use the spawn control. The interface also supports vehicle variants and a **My Vehicles** area for managing vehicles you have spawned. Vehicle availability depends on the enabled mod set.

### Using logistics and crate filling

At the configured logistics object, use its ACE **Logistics** interaction to open the crate-filler interface. The tool can create a configured supply crate and edit inventories of eligible nearby storage objects. The mission's current setup allows crate creation and deletion, uses a curated item list rather than generating the lists from every installed mod, and searches around the configured logistics spawn area.

### Building fortifications

Use the ACE Fortify system to place the objects configured for the independent side. The mission registers a catalog of fortification objects grouped into categories such as logistics, military, airport, sandbags, barriers, and obstructions. Fortification trucks are available from their vehicle spawner and are configured with build locations and budgets.

### Player-hit alerts

The mission includes a player-hit notification script. Player-on-player hits produce a warning for the involved players and notify curators; self-hits and hits involving a curator are handled separately in the mission log. The script labels these as friendly-fire alerts and does not check whether the two players are on the same side.

## For mission makers

### Opening and editing the mission

The mission source is the `SandyTrainingMap.Lythium` folder. Open it in Arma 3 Eden Editor to change the map layout, objects, object variable names, and spawn markers. The mission's scripts refer to named objects and markers, so preserve or update those names when moving or replacing equipment and laptops.

To make a working local or server test:

1. Install Arma 3 and enable the same mod set as the mission.
2. Open `SandyTrainingMap.Lythium` in Eden Editor, or copy it to the appropriate Arma 3 mission folder for local testing.
3. Test the changed feature in-game with the intended ACE/CBA and content mods enabled.
4. Check the RPT or GitHub Actions logs if a script or release build reports an error.

### Where to make common changes

| What you want to change | Where to look |
| --- | --- |
| Map layout, placed objects, mission variables and spawn markers | [`mission.sqm`](./mission.sqm), edited most easily in Eden Editor |
| Vehicle choices, vehicle-spawner laptops, spawn positions, and special spawn behavior | [`init.sqf`](./init.sqf) |
| Fortification catalog and item costs | The ACE Fortify registration near the start of [`init.sqf`](./init.sqf) |
| Arsenal boxes and the shared arsenal equipment list | The arsenal setup near the end of [`init.sqf`](./init.sqf) |
| Player hit notifications to players and curators | [`initPlayerLocal.sqf`](./initPlayerLocal.sqf) |
| Mission UI includes and module/function registration | [`description.ext`](./description.ext) |
| Localized labels shown by the crate-filler interface | [`stringtable.xml`](./stringtable.xml) |
| Crate-filler objects, allowed crates/items, interaction range and search radius | [`modules/kp_cratefiller/KPCF_config.sqf`](./modules/kp_cratefiller/KPCF_config.sqf) |
| Vehicle-spawner configuration and functions | [`modules/grad-vehicleSpawner/`](./modules/grad-vehicleSpawner/) |
| Arsenal helper behavior and examples | [`modules/cheese-missionutils/README.md`](./modules/cheese-missionutils/README.md) |

### Mission startup and major systems

The mission's main setup script is [`init.sqf`](./init.sqf). Its comments describe these sections:

1. **ACE Fortify objects** — registers the independent-side build catalog, with each object's class name, point cost, and menu category.
2. **Vehicle lists and spawner interactions** — groups available ground, rotor-wing, fixed-wing, medical, repair/rearm/refuel, and fortification vehicles. It waits for the relevant laptop objects to exist before adding ACE interactions. Spawn positions are held in named objects or coordinate arrays.
3. **Special vehicle setup** — after a fortification truck is spawned, it receives ACE Fortify locations. Medical vehicles get the ACE medical-vehicle flag. Repair/rearm/refuel vehicles get their corresponding ACE capabilities.
4. **Arsenal setup** — defines the shared `arsenal_items` list, waits for each named arsenal object, and initializes it with the list.

The waits are intentional: mission initialization can begin before Eden-placed objects are available to scripts. When adding a laptop or arsenal, make sure the object name used by the script matches the name assigned to it in Eden.

[`initPlayerLocal.sqf`](./initPlayerLocal.sqf) installs the hit event handler for each player client and maintains a list of active curator players for notifications. [`description.ext`](./description.ext) includes the interfaces and function registries for the installed modules.

### Included modules

#### GRAD Vehicle Spawner

The vehicle spawner is configured in `init.sqf` and registered through `description.ext`. Its ACE interaction opens a selection screen where players preview and choose vehicles, select available variants, and spawn or manage vehicles. The module's own [`README.md`](./modules/grad-vehicleSpawner/README.md) documents its configuration and user interface.

The mission overrides several module defaults in `description.ext`: the abandoned-vehicle timer is set to 99,999 seconds, and the cleanup thresholds are 1,000 spawned vehicles globally and 100 per player. The laptop interactions and their vehicle lists are configured in `init.sqf`.

#### KP Cratefiller

The KP Cratefiller module is initialized for players and reads [`KPCF_config.sqf`](./modules/kp_cratefiller/KPCF_config.sqf). That configuration chooses the logistics interaction object type, nearby crate spawn object type, interaction/search distances, crate types, and the curated equipment lists. The current configuration enables crate spawning/deletion and disables automatic item-list generation.

#### Cheese Mission Utilities

The local utility module currently supplies the ACE Arsenal initialization helper. See [`modules/cheese-missionutils/README.md`](./modules/cheese-missionutils/README.md) for its inputs, fallback behavior, and examples.

## Building and publishing a release

The GitHub Actions workflow is [`.github/workflows/release-sandy-mission-pbo.yml`](../.github/workflows/release-sandy-mission-pbo.yml). It builds a release when a matching Git tag is pushed; ordinary commits and pushes do not publish a release.

### One-time GitHub setup

The workflow runs on a Windows GitHub-hosted runner and needs Arma 3 Tools' `CfgConvert.exe` to binarize the mission. If the runner cannot find it, the workflow can install Arma 3 Tools with SteamCMD. For that, a repository administrator should add these repository Actions secrets in **GitHub → Settings → Secrets and variables → Actions**:

- `STEAM_USERNAME`
- `STEAM_PASSWORD`

The Steam account needs access to Arma 3 Tools (Steam app `233800`). Keep these credentials in GitHub Secrets; do not put them in the repository. The workflow also checks `CFGCONVERT_EXE` if that environment variable is already available, but it does not currently map a GitHub repository variable to that environment variable automatically.

### Create a release in VS Code

1. Open the repository in VS Code. Edit and save the mission files.
2. In **Source Control**, review the changes, commit the files intended for release, and push the commit to GitHub.
3. Open VS Code's integrated terminal and create and push a version tag for the commit you want released:

   ```powershell
   git tag -a v1.2.0 -m "Release v1.2.0"
   git push origin v1.2.0
   ```

   Replace `v1.2.0` with the version you are publishing. Push the commit first so the tag points to the right version.

4. On GitHub, open the repository's **Actions** tab and select the **Release Sandy Mission PBO** run for the tag. You can also open the repository on GitHub from VS Code and select **Actions** there.
5. Review the build artifacts and the workflow step logs. If a stable release is being built, the workflow waits for approval through a GitHub issue; the person who pushed the tag is the configured approver. Follow the approval issue's instructions only after reviewing the artifacts. A tag containing `rc` (for example `v1.2.0-rc1`) is marked as a prerelease and skips the stable approval step.
6. After the workflow finishes successfully, open the repository's **Releases** page and download the PBO and other release assets.

The build replaces `<VERSION>` in the mission's `mission.sqm` with the tag name in the workflow's temporary checkout, converts the mission file, packs `SandyTrainingMap.Lythium` as a PBO, and adds versioned copies of the repository's HTML preset files. These release-build steps do not change your local mission files.

### What the workflow does

- Downloads the latest PBO Manager binaries (`pboman3`) and locates `CfgConvert.exe`.
- Builds and packs the mission as `SandyTrainingMap-<tag>.Lythium.pbo`.
- Copies the root-level HTML presets into the release assets with the tag added to each filename.
- Prepares release notes from commits since the prior tag, or recent commits if no previous tag exists.
- Uploads the files as workflow artifacts, then publishes them on the GitHub Release after any required stable-release approval.

If a run fails, open the failed job and step in **Actions** to read its log. Frequent causes include missing or invalid Steam credentials, a Steam account without Arma 3 Tools access, a missing mission source file, or PBO/CfgConvert build errors. Pushing a new ordinary commit does not rerun a release; push a new tag for the corrected commit.
