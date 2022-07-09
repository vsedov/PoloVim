#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# File Name: test.py
import logging

import pyinspect as pi
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

    def pointer():
        pass

    x = 10
    pr


if __name__ == "__main__":
    pi.install_traceback(pnable_prompt=True)
    print("this is a function")

    for i in range(""):
        pass
for i in range(""):
    print("this is a function")
