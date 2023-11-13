from sys import argv
from os import getcwd, walk, getcwd
from os.path import join
from fnmatch import filter
from pathlib import Path
from importlib import import_module
from importlib.util import spec_from_file_location, module_from_spec
from importlib.machinery import ModuleSpec
from importlib.abc import Loader
import subprocess
from json import loads
import impurity
import re

config: dict
lib: impurity.lib


def find_files(directory, pattern) -> list[str]:
    matches: list[str] = []
    for root, dirnames, filenames in walk(directory):
        for filename in filter(filenames, pattern):
            matches.append(join(root, filename))
    return matches


def evalImpureFile(impure: str) -> None:
    spec = spec_from_file_location("impure", impure)
    assert isinstance(spec, ModuleSpec)

    loader = spec.loader
    assert isinstance(loader, Loader)

    imodule = module_from_spec(spec)
    loader.exec_module(imodule)

    assert hasattr(imodule, "impure"), f"{impure} not define impure function"
    lib.setCurrFile(impureFile)
    imodule.impure(config, lib)
    lib.freeCurrFile()


if __name__ == "__main__":
    matching_files: list[str] = find_files(getcwd(), "impure.py")
    if argv.__len__() != 3:
        print("please input only one param")
        exit(1)

    rootPath = Path(getcwd())
    assert argv[1] == "home" or argv[1] == "nixos", f"argv[1] should not be {argv[1]}"
    command: str = (
        f"nix eval --json {rootPath}#{argv[1]}Configurations.{argv[2]}.config.euphgh"
    )
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    assert result.returncode == 0, f"{command} fail"
    config = loads(result.stdout)

    lib: impurity.lib = impurity.lib("nix-impure")
    for impureFile in matching_files:
        evalImpureFile(impureFile)
