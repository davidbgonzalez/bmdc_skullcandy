#!/usr/bin/env python

import sys
import json

def main(argv):
  line = sys.stdin.readline().rstrip()
  # check there is at least some data
  if len(line)<2:
    line = '[]'
  # check if line is json?
  if line[-1] == ']':
    line = line
  else:
    line = '[]'
  parsed = json.loads(line)
  # number of posts total
  retweet_counts = []
  favorite_counts = []
  langs = []
  geos = []
  if len(parsed):
    # average retweets
    for x in parsed:
      # find the most popular location
      if x['geo'] is not None:
        geos.append(str(x['geo']['coordinates'][0]) +","+ str(x['geo']['coordinates'][1]))
      # find the most popular language
      if x['lang'] is not None:
        langs.append(x['lang'])
      if x['retweet_count'] is not None:
        retweet_counts.append(x['retweet_count'])
      # average retweets
      if x['favorite_count'] is not None:
        favorite_counts.append(x['favorite_count'])
      user = x['user']['id']

    def most_common(lst):
      return max(set(lst), key=lst.count)

    if len(geos):
      geo = most_common(geos)
    else:
      geo = 'NA'

    print user, \
      str(len(parsed)), \
      float(sum(retweet_counts))/len(retweet_counts), \
      float(sum(favorite_counts))/len(favorite_counts), \
      most_common(langs), \
      geo

if __name__ == "__main__":
    main(sys.argv)



