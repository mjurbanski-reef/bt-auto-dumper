import argparse
import pathlib


def main(apiver: str | None = None):
    apiver = apiver or pathlib.Path(__file__).parent.name
    parser = argparse.ArgumentParser(description=f"BT Auto Dumper CLI {apiver}")
    parser.parse_args()


if __name__ == "__main__":
    main()
