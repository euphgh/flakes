from impurity import lib
from xdg import *


def impure(cfg: dict, lib: lib) -> None:
    try:
        if cfg["home"]["zsh"]["antidote"]:
            lib.overwriteSymLink( "./p10kpure.zsh", XDG_CONFIG_HOME / "zsh/.p10k.zsh")
    except KeyError:
        pass

