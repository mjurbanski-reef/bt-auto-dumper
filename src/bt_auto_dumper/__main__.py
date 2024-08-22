import os
import pathlib
import re

_THIS_DIR = pathlib.Path(__file__).parent
_APIVER_RE = re.compile(r"_?v\d+")


def get_bt_auto_dumper_apiver() -> str:
    ver = os.environ.get("B2_AUTO_DUMPER_APIVER", "v1")
    if not re.match(r"_?v\d+", ver):
        available_versions = [d.name for d in _THIS_DIR.iterdir() if d.is_dir() and _APIVER_RE.match(d.name)]
        raise ValueError(f"Invalid BT_AUTO_DUMPER_APIVER={ver!r} . Available versions: {available_versions}")

    return ver


def main():
    apiver = get_bt_auto_dumper_apiver()
    __import__(f"bt_auto_dumper.{apiver}.__main__", fromlist=["main"]).main()
