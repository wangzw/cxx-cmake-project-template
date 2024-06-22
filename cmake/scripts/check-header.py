#!/usr/bin/env python3

import sys
import os


def check_single_include(include_base, installed_headers, required_headers, errors, file, line):
    line = line[len("#include"):].strip()
    if len(line) == 0 or line[0] != '"' or line[-1] != '"':
        return

    line = line.strip('"')
    path = os.path.join(include_base, line)
    # included header does not exist
    if (not os.path.exists(path)) or (not os.path.isfile(path)):
        errors.add('header "{}" in file "{}" does not exist'.format(
            line, os.path.relpath(file, include_base)))
    if path not in installed_headers:
        errors.add('header "{}" in file "{}" does not included in public headers'.format(
            line, os.path.relpath(file, include_base)))
    required_headers.append(path)


def check_single_header(include_base, installed_headers, required_headers, errors, file):
    with open(file, 'r') as content:
        for l in content:
            line = l.strip()
            if line.startswith("#include"):
                check_single_include(include_base, installed_headers, required_headers, errors, file, line)


def main():
    if len(sys.argv) < 2:
        sys.exit(-1)

    include_base = sys.argv[1]
    installed_headers = sys.argv[2:]
    errors = set()
    loop = True

    while loop:
        loop = False
        required_headers = []

        for file in installed_headers:
            check_single_header(include_base, installed_headers, required_headers, errors, file)
        for file in installed_headers:
            if "/detail/" in file and file not in required_headers:
                installed_headers.remove(file)
                loop = True
                errors.add('internal header "{}" should not be installed'.format(
                    os.path.relpath(file, include_base)))

    if errors:
        for err in errors:
            print("ERROR:", err, file=sys.stderr)
        exit(-1)


if __name__ == '__main__':
    main()
