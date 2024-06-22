#!/usr/bin/env python3

import fnmatch
import subprocess
import sys
from os import path

DEFAULT_CLANG_TIDY_IGNORE = ".clang-tidy-ignore"
DEFAULT_CLANG_TIDY_CONFIG = ".clang-tidy"


def filter_file(file):
    """Filter out all files specified via globs in DEFAULT_CLANG_TIDY_IGNORE.
    """
    ignore_file = path.join(path.dirname(sys.argv[0]), DEFAULT_CLANG_TIDY_IGNORE);

    globs = list()
    with open(ignore_file, 'r') as tidy_ignore:
        for l in tidy_ignore:
            line = l.strip()
            # Tolerate comments and empty lines
            if not line or line.startswith('#'):
                continue
            globs.append(line)

    for g in globs:
        if fnmatch.fnmatch(file, g):
            return True

    return False


def filter_args(args):
    ignored_flags = ["-fcoroutines", "-flto=auto", "-fno-fat-lto-objects", "-fprofile-abs-path"]
    new_arg = [arg for arg in args if
               arg not in ignored_flags and not arg.startswith("EXTRA_CLANG_TIDY_COMPILER_FLAGS")]
    extra_compiler_flags = [arg[len("EXTRA_CLANG_TIDY_COMPILER_FLAGS="):] for arg in args if
                            arg.startswith("EXTRA_CLANG_TIDY_COMPILER_FLAGS")]
    for arg in new_arg:
        if arg.endswith(".h") or arg.endswith(".cc") or arg.endswith(".cpp"):
            if filter_file(arg):
                return []

    return new_arg + extra_compiler_flags


def invoke_clang_tidy(args):
    try:
        config = "--config-file=" + path.join(path.dirname(sys.argv[0]), DEFAULT_CLANG_TIDY_CONFIG)
        cmds = " ".join([args[0], config] + args[1:])
        print(cmds)
        output = subprocess.run(args=cmds, shell=True)
        sys.exit(output.returncode)
    except FileNotFoundError as e:
        print(e, file=sys.stderr)
        sys.exit(e.errno)
    except Exception as e:
        print(e, file=sys.stderr)
        sys.exit(-1)


def main():
    args = filter_args(sys.argv[1:])

    if not args:
        sys.exit(0)

    invoke_clang_tidy(args)


if __name__ == '__main__':
    main()
