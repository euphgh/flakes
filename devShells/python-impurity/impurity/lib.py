import os
import logging
from pathlib import Path


class CustomFormatter(logging.Formatter):
    grey: str = "\x1b[38;20m"
    yellow: str = "\x1b[33;20m"
    red: str = "\x1b[31;20m"
    bold_red: str = "\x1b[31;1m"
    reset: str = "\x1b[0m"
    fmtStr: str = (
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s (%(filename)s:%(lineno)d)"
    )

    FORMATS = {
        logging.DEBUG: grey + fmtStr + reset,
        logging.INFO: grey + fmtStr + reset,
        logging.WARNING: yellow + fmtStr + reset,
        logging.ERROR: red + fmtStr + reset,
        logging.CRITICAL: bold_red + fmtStr + reset,
    }

    def format(self, record) -> str:
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)


def setLogger(name: str) -> logging.Logger:
    # create logger with 'spam_application'
    logger: logging.Logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    # create console handler with a higher log level
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(CustomFormatter())
    logger.addHandler(ch)
    return logger


def inputsYorN(prompt: str) -> bool:
    guideStr = "(y,enetr/n)"
    ans: str = input(f"{prompt} {guideStr}: ")
    if ans == "" or ans == "y":
        return True
    return False


class lib:
    def __init__(self, name: str) -> None:
        self.logger: logging.Logger = setLogger(name)
        self.currFile: str = ""

    def Assert(self, cond: bool, msg: str) -> None:
        if not cond:
            self.logger.error(msg)
            assert False

    def setCurrFile(self, filePath: str) -> None:
        self.currFile = filePath

    def freeCurrFile(self) -> None:
        self.currFile = ""

    def getCurrFile(self) -> Path:
        self.Assert(self.currFile != "", f"get current file path, but not set")
        return Path(self.currFile)

    def canOverwrite(self, filePath: str | Path, srcPath: str | Path) -> bool:
        # 判断filePath是否是符号链接
        if os.path.islink(filePath):
            # 获取符号链接的路径
            linkPath: str = os.path.realpath(filePath)
            # 比较dstPath和符号链接的路径
            if linkPath == str(srcPath):
                os.remove(filePath)
                return True
            else:
                if inputsYorN(f"{filePath} is symlink to {linkPath}, overwrite it ?"):
                    os.remove(filePath)
                    print(f"overwrite {filePath} by {srcPath}")
                    return True
                else:
                    print(f"save {linkPath}")
                    return False
        # 判断filePath是否存在
        elif os.path.exists(filePath):
            self.logger.error(f"{filePath} exits, please remove manually")
            return False
        else:
            return True

    def overwriteSymLink(self, srcRelPath: str | Path, dstAbsPath: str | Path) -> None:
        srcAbsPath = (Path(self.currFile).parent / srcRelPath).resolve()
        if self.canOverwrite(dstAbsPath, srcAbsPath):
            os.symlink(srcAbsPath, dstAbsPath)
