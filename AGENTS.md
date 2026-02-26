# AGENTS.md

Guidelines for AI coding agents working in this Nix Flakes repository.

## Project Overview

This is a Nix flake repository containing:
- Home Manager configurations for multiple machines
- Development shells for various environments
- Custom NixOS and Home Manager modules

## Build/Lint/Test Commands

### Validation
```bash
nix flake check                    # Validate flake outputs
```

### Format Nix Files
```bash
nix fmt                                # Format all .nix files
```

### Build Home Manager Configurations
```bash
nix build .#homeConfigurations.hgh@m4.activationPackage    # Build for macOS
nix build .#homeConfigurations.hgh@265k.activationPackage  # Build for Linux
```

### Development Shells
```bash
nix develop .#self-dev      # Shell for working on this flake
nix develop .#ysyx         # YSYX project development
nix develop .#python-dev  # Python development
nix develop .#cpp-dev      # C++ development
nix develop .#riscv-dev   # RISC-V development
nix develop .#remuws     # REMUWS project
```

### Quick Switch (Home Manager)
```bash
home-manager switch --flake .#hgh@m4     # Switch to m4 config (macOS)
home-manager switch --flake .#hgh@265k   # Switch to 265k config (Linux)
```

## Code Style Guidelines

### File Organization

```
.
├── flake.nix              # Main flake definition
├── devShells/             # Development shell definitions
│   ├── default.nix
│   ├── basic/
│   │   ├── python.nix
│   │   ├── cpp.nix
│   │   └── riscv-cross.nix
│   ├── ysyx.nix
│   ├── riscv-dev.nix
│   └── python-impurity/
├── home-manager/              # Machine-specific configurations
│   ├── hgh@m4.nix
│   └── hgh@265k.nix
└── modules/                 # Reusable modules
    ├── home-manager/
    │   ├── default.nix
    │   ├── devCli.nix
    │   ├── utilCli.nix
    │   ├── utilGui.nix
    │   ├── git.nix
    │   ├── tex.nix
    │   ├── nvim/
    │   ├── tmux/
    │   ├── vscode/
    │   └── zsh/
    └── └── nixos/             # NixOS modules (currently empty)
```

### Nix Formatting Rules

1. **Use `nix fmt`** before committing Nix files
2. **No trailing whitespace** in Nix files
3. **Indent with 2 spaces** (standard Nix convention)

### Import Style

Prefer the pattern used in this repository:

```nix
{ lib, config, pkgs, ... }:
with lib; let
  cfg = config.euphgh.home.<module>;
in
{
  options.euphgh.home.<module>.enable = mkEnableOption "description";
  config = mkIf cfg.enable {
    # configuration here
  };
}
```

### Module Structure

1. Options are defined under custom namespace `euphgh.home.*`
2. Use `with lib;` for common library functions at top of file
3. Use `let ... in` block to extract config
4. Conditional config with `mkIf cfg.enable`

### Function Arguments

Use explicit argument names rather than `...` for modules:

```nix
# Good: Explicit arguments
{ lib, config, pkgs, ... }:

# Used in shell definitions
{ mkShell, python3, black, pyPkgs ? (ps: with ps; [ ]) }:
```

### Package Lists

Group related packages and use `with pkgs;`:

```nix
home.packages = with pkgs; [
  package1
  package2
];
```

### Import Organization

```nix
imports = [
  ./module1
  ./module2
];
```

### Naming Conventions

- **Options**: `euphgh.home.<feature>.enable`
- **Shells**: descriptive names like `python-dev`, `cpp-dev`, `riscv-dev`
- **Configurations**: machine-specific like `hgh@m4`, `hgh@265k`

### String Formatting

For multi-line strings in Nix, use `''`:

```nix
initExtra = ''
  source ${./config/zsh-conf.zsh}
  bindkey -M emacs '^P' history-substring-search-up
'';
```

### Home Manager Patterns

Enable programs through Home Manager options:

```nix
programs.git.enable = true;
programs.neovim.enable = true;
programs.zsh.enable = true;
programs.tmux.enable = true;
programs.direnv.enable = true;
programs.home-manager.enable = true;
```

### XDG Integration

Enable `xdg.enable = true` for proper XDG base directory support.

### Dev Shell Patterns

Use `inputsFrom` to inherit from other shells:

```nix
inputsFrom = [
  riscv-cross
  python-dev
];
```

Use `shellHook` for environment setup:

```nix
shellHook = ''
  export ARCH=riscv
'';
```

### Error Handling

Nix uses lazy evaluation, so:
- Use `lib.mkIf` for conditional configurations
- Check option syntax with `lib.mkEnableOption`
- Handle missing packages gracefully with `?` operator or `lib.optional`

### SOPS (Secrets)

Secrets are managed with SOPS. The age key is defined in `.sops.yaml`:
- Secrets should be in `secrets/` directory
- Never commit unencrypted secrets

### Testing Changes

After making changes:

```bash
nix flake check                    # Validate the flake
nix fmt                                # Format code
git diff --stat                      # Review changes
```

### Common Tasks

#### Adding a New Home Manager Module

1. Create file in `modules/home-manager/`
2. Add to `imports` in `modules/home-manager/default.nix`
3. Define options under `euphgh.home.<name>`
4. Configure in machine-specific file if needed

#### Adding a New Dev Shell

1. Create file in `devShells/`
2. Add to `devShells/default.nix` exports
3. Use `nixpkgs.callPackage` pattern

#### Enabling a Module on a Machine

Edit the machine config (`home-manager/hgh@m4.nix` or `hgh@265k.nix`):

```nix
euphgh.home.<module>.enable = true;
```

### Important Notes

- The `flake.lock` file should be committed for reproducibility
- Home Manager state version: `24.11`
- Platform support: `aarch64-darwin` and `x86_64-linux`