#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# File Name: python_language_test.py
import logging

from rich.logging import RichHandler

print(logging.getLogger())


def extracted_method():
    """[summary]"""
    x = map(lambda x: x + 1, [1, 2, 3, 4, 5])
    print(x)


extracted_method()
