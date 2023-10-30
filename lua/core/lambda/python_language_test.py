#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# File Name: python_language_test.py
import logging

import pyinspect as pi
from rich.logging import RichHandler

print(logging.getLogger())


for _ in range(10):
    print(pi.random_string(10))


def extracted_method():
    """[summary]"""
    x = map(lambda x: x + 1, [1, 2, 3, 4, 5])
    print(x)


extracted_method()
