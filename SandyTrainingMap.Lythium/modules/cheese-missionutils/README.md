# Cheese Mission Utilities

Cheese Mission Utilities is a small collection of mission helper functions. This module currently provides one function: a way to prepare an ACE Arsenal on a box, crate, or other object.

This guide is written for mission makers who may not write code every day. It explains what the function does, the choices you need to make when using it, and how the repository turns a tagged version of the mission into a GitHub release.

## What is included

| Function | What it does |
| --- | --- |
| `cheese_missionutils_fnc_arsenal` | Initializes ACE Arsenal on an object, using a chosen item list or the mission's `arsenal_items` list. |

The function is in [`functions/curator/fn_arsenal.sqf`](./functions/curator/fn_arsenal.sqf). Its registration in [`cfgFunctions.hpp`](./cfgFunctions.hpp), included by the mission's `description.ext`, is what makes the name `cheese_missionutils_fnc_arsenal` available to mission scripts. ACE Arsenal must also be present in the mission.

## Arsenal function: what happens

The function accepts two optional inputs, in this order:

1. **The object to configure (`_box`)**. You can provide the object itself, or a quoted mission variable name such as `"arsenal_1"`.
2. **The allowed item list (`_items`)**. This is an array of Arma item class names, for example `["arifle_MX_F", "FirstAidKit"]`.

The function handles these choices in order:

1. If the box input is a string, it looks up the object with that name in the mission namespace.
2. If no valid object was supplied or found, it tries the object under the player's cursor.
3. If there is still no object, it creates a `B_CargoNet_01_ammo_f` cargo net at the player's position and uses that.
4. If no item list was supplied, it uses the mission variable `arsenal_items` when that variable exists. If it does not exist, the function passes `true` to ACE Arsenal.
5. It calls ACE's `ace_arsenal_fnc_initBox` to initialize the selected object with the selected items.

In practical terms, passing an item list limits the arsenal to those class names. Setting up `arsenal_items` once lets you share the same list across calls. If neither source provides a list, `true` asks ACE Arsenal to use its full-arsenal option.

### Choose the box and items

**Use a named box and a specific list:**

```sqf
["arsenal_1", ["arifle_MX_F", "FirstAidKit"]] call cheese_missionutils_fnc_arsenal;
```

`"arsenal_1"` must match the name assigned to the object in the mission. The quotes matter: they tell the function to find the object by its mission variable name.

**Use a box object and a shared mission list:**

```sqf
arsenal_items = ["arifle_MX_F", "FirstAidKit"];
[arsenal_1] call cheese_missionutils_fnc_arsenal;
```

Here, `arsenal_1` is the object variable, without quotes. Because no second input is provided, the function looks for `arsenal_items`.

**Supply a list for just one call:**

```sqf
[arsenal_1, ["arifle_MX_F", "FirstAidKit"]] call cheese_missionutils_fnc_arsenal;
```

An item name must be a valid class name from a mod enabled for the mission. Display names shown in-game are not necessarily the same as class names. If a desired item is missing, check its class name and confirm the mod that provides it is loaded.

### Use it in an object's initialization field

For a box placed in the Eden Editor, select the box and put a call like this in its **Init** field:

```sqf
[this, ["arifle_MX_F", "FirstAidKit"]] call cheese_missionutils_fnc_arsenal;
```

In an object's Init field, `this` means “the object whose field is running.” To use the shared list instead, define `arsenal_items` before the call and use:

```sqf
[this] call cheese_missionutils_fnc_arsenal;
```

### Important distinction: creating a box versus adding a Zeus action

This function initializes an arsenal; it does **not** create a Zeus/curator menu button or an ACE interaction by itself. If you call it without a usable box, it creates a cargo net at the player's position and initializes that. To make a curator action that lets someone choose when to run the function, the mission needs separate action-registration code that calls this function.

## How the mission uses the function

The mission's [`init.sqf`](../../init.sqf) shows the shared-list pattern:

- It defines names for the arsenal objects, such as `arsenal_1` and `arsenal_2`.
- It defines `arsenal_items` as the list of items available in those arsenals.
- It waits until each named arsenal object exists, then calls `cheese_missionutils_fnc_arsenal` with that object name and the shared list.

That wait matters: it prevents the setup code from trying to initialize a box before the mission has made its object variable available. When adding another arsenal to this mission, use the same pattern: give the placed object the expected variable name, include it in the list of arsenal names, and make sure the desired items are in `arsenal_items`.

## Releasing the mission with GitHub Actions

The release automation is defined in [`.github/workflows/release-sandy-mission-pbo.yml`](../../../.github/workflows/release-sandy-mission-pbo.yml). It is a **tag-triggered release pipeline**, not a build that runs for every save or ordinary push. Pushing a matching version tag (such as `v1.2.0`) starts it.

### What the pipeline does

1. **Checks out the repository** on a Windows GitHub-hosted runner, including Git history and tags.
2. **Reads the tag name** as the release version. A tag whose name contains `rc` in any capitalization is treated as a prerelease; other tags are treated as stable releases.
3. **Gets the PBO packing tool** (`pboman3`) from its latest GitHub release.
4. **Finds Arma 3 Tools' `CfgConvert.exe`**. The workflow can use a path supplied as `CFGCONVERT_EXE`, a copy already installed on the runner, or install Arma 3 Tools through SteamCMD.
5. **Prepares and packs the mission** from `SandyTrainingMap.Lythium`. If `mission.sqm` contains `<VERSION>`, it replaces that placeholder with the tag name, binarizes the mission file, and packs the mission into a PBO.
6. **Copies the HTML preset files** into the release assets with the tag appended to each filename.
7. **Creates release notes** from the commits since the previous tag (or, if there is no previous tag, from recent commits) and uploads the generated files as workflow artifacts.
8. **Publishes the GitHub Release**. Stable releases pause for manual approval; prereleases skip that approval step.

The build step runs in the workflow's temporary checkout. It does not replace your local `mission.sqm` when you run a release from GitHub.

### One-time GitHub setup

The Windows-hosted runner may need to install Arma 3 Tools to get `CfgConvert.exe`. For that route, add these as **repository Actions secrets**:

- `STEAM_USERNAME`
- `STEAM_PASSWORD`

In GitHub, open the repository's **Settings → Secrets and variables → Actions → New repository secret**. Add each secret separately. Do not put Steam credentials in the README, source files, or a normal workflow variable.

The Steam account must have access to Arma 3 Tools (Steam app `233800`). If the workflow reports that `CfgConvert.exe` cannot be found, check the Steam secrets and account access, or arrange for the executable to be available to the runner through `CFGCONVERT_EXE`. The workflow checks that environment variable, but it does not currently map a GitHub repository variable into it automatically; configuring that option may require a workflow change or a runner where the variable is already set.

### Make and publish a release from VS Code

1. **Open the repository folder in VS Code.** Make your mission changes and save them.
2. **Review the changes** in the Source Control view. Check that you intend to include every changed file. Commit the changes with a clear message, then push the commit to GitHub. You can use VS Code's Source Control controls for commit and push.
3. **Create and push a version tag** in VS Code's integrated terminal. For example:

   ```powershell
   git tag -a v1.2.0 -m "Release v1.2.0"
   git push origin v1.2.0
   ```

   Replace `v1.2.0` with the version you are releasing. Tag the commit you want the release to contain; push your commits first so the tag points at the intended version.

4. **Watch the workflow.** In VS Code, open the repository on GitHub and select **Actions**, then open the run named **Release Sandy Mission PBO** for your tag. You can also use GitHub's **Actions** tab in a browser. A green check means the workflow completed; open a failed step's log to see what needs attention.
5. **For a stable release, approve it.** The pipeline opens an approval issue and waits for the required approval before publishing. The workflow expects approval from the person who pushed the tag. Review the build artifacts in the workflow run, then follow the approval instructions on the issue if the files are correct. A tag containing `rc`, such as `v1.2.0-rc1`, is marked as a prerelease and skips this stable-release approval.
6. **Download the published files.** Once publishing completes, open the repository's **Releases** page and choose the tag. Download the PBO and any other release assets listed there.

If you pushed the wrong tag, or need a different build, create a new tag for the corrected commit and push that tag; pushing an ordinary commit alone does not start this release workflow.
