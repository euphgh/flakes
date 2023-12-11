from impurity import lib
from xdg import *


def impure(cfg: dict, lib: lib) -> None:
    try:
        if cfg["home"]["kitty"]["enable"]:
            lib.overwriteSymLink( "./kitty.conf", XDG_CONFIG_HOME / "kitty/kitty.conf")
            lib.overwriteSymLink( "./nord.conf", XDG_CONFIG_HOME / "kitty/nord.conf")
    except KeyError:
        pass

