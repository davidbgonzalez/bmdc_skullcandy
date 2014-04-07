import re, os 
import csv 
from dateutil import parser
from os import listdir
from os.path import isfile, join

# load the files in the final_data folder
mypath = "final_data/" 
onlyfiles = [ f for f in listdir(mypath) if isfile(join(mypath,f))]

#onlyfiles = ("B001UE6I0G.csv","B00428N9OK.csv")

# load the output file
fname = "final_data.csv"
with open(fname,"w") as f_out:
  f_out.write("id,star_rating,yes_helpful,total_votes,date,title\n")

  # for each file
  for fname_in in onlyfiles:
    lines_out=()
    with open("final_data/"+fname_in) as f_in:
      all_lines = f_in.readlines()
    for my_line in all_lines:
      if len(re.findall("\"",my_line))==20 and len(re.findall("<",my_line)) < 2:
        row = my_line.split('\"')
        review_date = parser.parse(row[13])
        title = row[17].replace(",","")
        title = title.split("(")[0]
        f_out.write(row[5]+","+row[7]+","+row[9]+","+row[11]+","+review_date.strftime("%Y-%m-%d")+",\""+title+"\"\n")
