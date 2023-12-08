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
    xl = range(1, 100)

    return xl


extracted_method()
