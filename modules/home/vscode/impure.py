from impurity import lib
from xdg import *


def impure(cfg: dict, lib: lib) -> None:
    try:
        if cfg["home"]["vscode"]["enable"]:
            lib.overwriteSymLink(
                "./settings.json", XDG_CONFIG_HOME / "Code/User/settings.json"
            )
            lib.overwriteSymLink(
                "./keybindings.json", XDG_CONFIG_HOME / "Code/User/keybindings.json"
            )
    except KeyError:
        pass
