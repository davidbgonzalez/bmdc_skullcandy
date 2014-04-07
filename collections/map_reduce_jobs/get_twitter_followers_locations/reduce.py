#!/usr/bin/env python

import sys
import json

def main(argv):
  line = sys.stdin.readline()
  try:
    while line:
      line = line.rstrip()
      print line
      line = sys.stdin.readline()
  except "end of file":
    return None
if __name__ == "__main__":
    main(sys.argv)

