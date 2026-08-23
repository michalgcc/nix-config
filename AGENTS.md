# NixOS Configuration

Flake-based NixOS + home-manager configuration. Targets multiple machines and a
non-NixOS (Ubuntu/WSL) CLI profile.

## Hosts

| Target                              | Flake attr           | Kind                         |
| ----------------------------------- | -------------------- | ---------------------------- |
| `mg-laptop`, `mg-desktop`, `mg-t14gen1i` | `.#<hostname>`       | NixOS system                 |
| `mg@home-manager`                   | `.#mg@home-manager`  | home-manager (GUI, on NixOS) |
| `mg@home-manager-cli`               | `.#mg@home-manager-cli` | home-manager (CLI, Ubuntu/WSL) |

## Repo layout

- `flake.nix` — flake entry; inputs (`nixos-26.05`, `nixos-unstable`, home-manager) and all outputs.
- `nixos/<host>/` — per-host NixOS config: `configuration.nix` and the committed `hardware-configuration.nix`.
- `nixos/shared/` — cross-host NixOS modules (`system.nix`, `packages.nix`, `lutris.nix`, `default.nix`).
- `home-manager/` — `home-gui.nix` (NixOS GUI), `base.nix` (shared base, used directly by the CLI profile), `shared.nix`, `dotfiles.nix`, and `apps/`.
- `modules/` — reusable NixOS modules (e.g. `thinkpad_acpi.nix`).
- `overlays/` — nixpkgs overlays (imported from `flake.nix`).
- `pkgs/` — custom / patched packages (currently unused; patched kernel modules live in `modules/`).
- `patches/` — vendored patches (e.g. `disable-lapmode.patch`).
- `scripts/` — standalone helper scripts.
- Root `*.sh` — build / apply / maintenance helpers (see below).

## Build and apply

The helper scripts are the source of truth — prefer them over raw `nixos-rebuild` / `home-manager`.

- `./format_code.sh` — format **before every commit**. Runs `nixfmt` on `*.nix` and `shfmt -i=4` on shell scripts. Also enforced by the pre-commit hook.
- `./rebuild_nixos.sh` — `nixos-rebuild switch --flake .#$(hostname)` (NixOS only; guards on `/etc/os-release`).
- `./rebuild_home_manager.sh` — `home-manager switch` for `mg@home-manager` (NixOS GUI).
- `./rebuild_cli_nix_home_manager.sh` — `home-manager switch` for `mg@home-manager-cli` (Ubuntu/WSL).
- `./apply.sh` — rebuild home-manager + NixOS, then flatpaks + npm globals (NixOS only).
- `./update_lock.sh` — `nix flake update`.
- `./update_lock_and_apply.sh` — `update_lock.sh` then rebuild NixOS + home-manager + flatpaks + npm (NixOS only).
- `./collect_garbage_and_optimise.sh` — nix GC + store optimise.
- `./run_diagnostics.sh` — system diagnostics.

Verify a change against the **matching host**: edit a NixOS host → `./rebuild_nixos.sh`; edit `home-manager/home-gui.nix` → `./rebuild_home_manager.sh`; edit `home-manager/base.nix` (CLI profile) → `./rebuild_cli_nix_home_manager.sh`.

## Conventions

### Conventional Commits (enforced)

Conventional Commits are mandatory. `cog.toml` installs cocogitto (`cog`) hooks:

- **pre-commit** runs `./format_code.sh`.
- **commit-msg** runs `cog verify` on the message and `cog check` on history.

Allowed types (Angular set): `feat`, `fix`, `chore`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `revert`. History mostly uses `feat`, `chore`, `fix`; scopes are optional and rarely used.

Commit using `cog` so the message is valid by construction and the hooks run:

```bash
git add <files>
cog commit feat "add foo to desktop"        # cog commit <TYPE> "<MESSAGE>" [SCOPE]
cog commit fix laptop "regenerate initrd"   # scope is the last positional arg
```

`-a` adds tracked files like `git add .`; `-u` stages modifications only. Avoid raw `git commit` unless `cog` is unavailable.

### Formatting

- Nix → `nixfmt` (do not hand-format; run `./format_code.sh`).
- Shell → `shfmt` with **4-space** indent (`-i=4`).

### Flake rules

- Never hand-edit `flake.lock` — run `./update_lock.sh` (`nix flake update`).
- After changing `inputs` in `flake.nix`, regenerate the lock before rebuilding.
- `hardware-configuration.nix` is committed per host under `nixos/<host>/`; do not delete or regenerate it casually.

### Devshell

`.envrc` runs `use flake . --impure` (direnv). The flake `devShells.default` provides `cocogitto`, `nixfmt`, `shfmt` and auto-installs the `cog` hooks on shell entry. Make sure you are in this devshell so `cog` and the formatters are available.

## Gotchas

- NixOS-only scripts (`rebuild_nixos.sh`, `apply.sh`, `update_lock_and_apply.sh`, `rebuild_home_manager.sh`) refuse to run on non-NixOS; use the `*_cli_` script for the Ubuntu/WSL target.
- Do not commit secrets, keys, or machine-specific tokens.
- Patches referenced from modules live under `patches/` — keep paths consistent when adding new ones.
