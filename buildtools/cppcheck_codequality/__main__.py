# -*- coding: utf-8 -*-
#!/usr/bin/env python3
"""CLI app for converting CppCheck XML to code quality JSON.

Copyright (c) 2020, Alexander Hogen
SPDX-License-Identifier: MIT
"""

import argparse
import logging
import sys
from typing import List

from . import __version__, convert_file


def _init_logging(level, fname):
    """Setup root logger to log to console, when this is run as a script.

    Args:
        level:
            Global logging level to set. See logging.Logger.setLevel().
        fname:
            Path of log file to append to, if not "/dev/null".
    """
    logging.getLogger().setLevel(level)

    h_console = logging.StreamHandler()
    log_fmt_short = logging.Formatter(
        "[%(relativeCreated)d] %(name)s %(levelname)s: %(message)s", datefmt="%H:%M:%S"
    )
    h_console.setFormatter(log_fmt_short)

    # Add console handler to root logger
    logging.getLogger("").addHandler(h_console)

    if fname != "/dev/null":
        h_file = logging.FileHandler(fname, encoding="utf-8")
        log_fmt_long = logging.Formatter(
            "%(asctime)s %(name)s %(levelname)s: %(message)s"
        )
        h_file.setFormatter(log_fmt_long)
        # Add file handler to root logger
        logging.getLogger("").addHandler(h_file)


def _get_args(argv) -> argparse.Namespace:
    """Parse CLI args with argparse

    Args:
        argv
            List of CLI argument strings to parse.
    """
    # Make parser object
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "-i",
        "--input-file",
        metavar="INPUT_XML_FILE",
        dest="input_file",
        type=str,
        default="cppcheck.xml",
        help="the cppcheck XML output file to read defects from (default: %(default)s)",
    )

    parser.add_argument(
        "-o",
        "--output-file",
        metavar="FILE",
        dest="output_file",
        type=str,
        default="cppcheck.json",
        help="output filename to write JSON to (default: %(default)s)",
    )

    parser.add_argument(
        "-b",
        "--base-dir",
        metavar="BASE_DIR",
        action="append",
        default=["."],
        help="Base directory where source code files can be found. (default: '%(default)s')",
    )

    parser.add_argument(
        "-l",
        "--loglevel",
        metavar="LVL",
        type=str,
        choices=["debug", "info", "warn", "error"],
        default="info",
        help="set logging message severity level (default: '%(default)s')",
    )

    parser.add_argument(
        "-L",
        "--logfile",
        metavar="FNAME",
        type=str,
        default="/dev/null",
        help="log messages to a file, in addition to the console (default: '%(default)s')",
    )

    parser.add_argument(
        "-v",
        "--version",
        dest="print_version",
        action="store_true",
        help="print version and exit",
    )

    return parser.parse_args(args=argv)


def main(argv: List[str] = sys.argv[1:]) -> int:
    """Convert a CppCheck XML file to Code Climate JSON file, at the command line.

    Args:
        argv:
            Command line arguments to parse, such as `["--version"]`. Defaults
            to system argv.

    Returns:
        0 if successful.
    """

    if sys.version_info < (3, 6, 0):
        sys.stderr.write("You need python 3.6 or later to run this script\n")
        return 1

    args = _get_args(argv)

    # Initialize logging for CLI.
    _init_logging(level=args.loglevel.upper(), fname=args.logfile)
    m_log = logging.getLogger("cppcheck_codequality")

    if args.print_version:
        print(__version__)
        return 0

    # Convert the XML to JSON here.
    ret = convert_file(
        fname_in=args.input_file, fname_out=args.output_file, base_dirs=args.base_dir
    )
    if ret < 0:
        m_log.error("Conversion failed")
        return 1

    # Logging the total count.
    # Side note: In personal projects, I intent to `cat` the log file and extract
    # this number, to record in a "metrics.txt" file and to generate a badge with "anybadge"
    # See:
    #   - https://docs.gitlab.com/ee/ci/metrics_reports.html
    #   - https://pypi.org/project/anybadge
    m_log.info("Converted %d CppCheck issues", ret)

    return 0


if __name__ == "__main__":
    sys.exit(main())
