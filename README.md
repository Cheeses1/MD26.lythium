# MD26 Lythium Training Mission

This repository contains the Arma 3 Lythium training mission, its source files, and the HTML mod presets used to prepare a compatible game setup. The mission includes a curated training area and custom scripts. Start with the [mission guide](SandyTrainingMap.Lythium/README.md) for player instructions, editing pointers, and the release process.

## Repository layout

| Path | Contents |
| --- | --- |
| [`SandyTrainingMap.Lythium/`](SandyTrainingMap.Lythium/) | The Eden mission source and its configuration, scripts, and modules. |
| [`SandyTrainingMap.Lythium/README.md`](SandyTrainingMap.Lythium/README.md) | Mission features, player usage, editing guidance, and GitHub release instructions. |
| [`SandyTrainingMap.Lythium/mission.sqm`](SandyTrainingMap.Lythium/mission.sqm) | Eden Editor mission data: terrain, placed objects, and mission settings. |
| [`SandyTrainingMap.Lythium/description.ext`](SandyTrainingMap.Lythium/description.ext) | Mission UI configuration and module/function registration. |
| [`SandyTrainingMap.Lythium/init.sqf`](SandyTrainingMap.Lythium/init.sqf) | Mission-wide setup for fortification, spawners, and arsenals. |
| [`SandyTrainingMap.Lythium/initPlayerLocal.sqf`](SandyTrainingMap.Lythium/initPlayerLocal.sqf) | Player-local hit alerts and curator notifications. |
| [`SandyTrainingMap.Lythium/modules/cheese-missionutils/`](SandyTrainingMap.Lythium/modules/cheese-missionutils/) | The mission's Cheese Mission Utilities helper and its documentation. |
| [`Arma 3 Preset Training MD 2026.html`](Arma%203%20Preset%20Training%20MD%202026.html) | HTML preset for the training mod set. |
| [`Arma 3 Preset Training MD 2026 Compat.html`](Arma%203%20Preset%20Training%20MD%202026%20Compat.html) | Compatibility variant of the training mod preset. |
| [`.github/workflows/release-sandy-mission-pbo.yml`](.github/workflows/release-sandy-mission-pbo.yml) | GitHub Actions workflow for building and publishing tagged mission releases. |

The mission folder contains additional configuration and module files. Its own README explains the main systems and where to make common changes.

## Credits and source

- **Mission authors — Cheese Boi & KryoX2.** Credited in the mission metadata in [`mission.sqm`](SandyTrainingMap.Lythium/mission.sqm). The mission source is maintained in this [repository](https://github.com/Cheeses1/MD26.lythium).
- **Cheese Mission Utilities — Cheese.** The module describes itself as Cheese's Mission Utils. Its [arsenal helper source](SandyTrainingMap.Lythium/modules/cheese-missionutils/functions/curator/fn_arsenal.sqf) and [usage documentation](SandyTrainingMap.Lythium/modules/cheese-missionutils/README.md) are included here.
- **Player-hit alert script — Belhun and Cutup (4th ARMCO).** The attribution appears in the header of [`initPlayerLocal.sqf`](SandyTrainingMap.Lythium/initPlayerLocal.sqf). See the [4th ARMCO Lythium mission source](https://github.com/Cheeses1/MD26.4thArmco.lythium).

### Third-party modules

These modules are included in the mission but are separate works. Their authors retain their respective copyrights and licensing terms; the repository's root license does not replace those terms.

- **GRAD Vehicle Spawner — Gruppe Adler; upstream package credits McDiod as a contributor.** Included under [`SandyTrainingMap.Lythium/modules/grad-vehicleSpawner/`](SandyTrainingMap.Lythium/modules/grad-vehicleSpawner/). See the [upstream source repository](https://github.com/gruppe-adler/grad-vehicleSpawner) and its [module documentation](SandyTrainingMap.Lythium/modules/grad-vehicleSpawner/README.md).
- **KP Cratefiller — Killah Potatoes; upstream credits Dubjunk for the module and Wyqer for the GUI components.** Included under [`SandyTrainingMap.Lythium/modules/kp_cratefiller/`](SandyTrainingMap.Lythium/modules/kp_cratefiller/). See the [upstream source repository](https://github.com/KillahPotatoes/KP-Cratefiller). The upstream project identifies its license as GNU GPL version 3 or (at your option) any later version; consult its source for the applicable terms.

## License

Original project work that the maintainers are authorized to license is provided under the [GNU General Public License, version 3 only](LICENSE). The license is not an assertion of ownership over third-party software, game content, mod assets, or other separately authored material included or referenced in the repository. Such material remains under its own applicable terms; check its source before copying or redistributing it.
