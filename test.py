#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# File Name: test.py
import logging

from rich.logging import RichHandler

root = logging.getLogger()
if root.handlers:
    for h in root.handlers:
        root.removeHandler(h)()

FORMAT = "%(message)s"
logging.basicConfig(level="INFO",
                    format=FORMAT,
                    datefmt="[%X]",
                    handlers=[RichHandler()])


def main() -> None:
    list = list(range(100))
    # get values from 50 to 75 only
    list = list[50:75]
    print(list)


if __name__ == "__main__":
    main()
