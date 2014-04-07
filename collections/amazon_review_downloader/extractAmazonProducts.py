from BeautifulSoup import BeautifulSoup

# for each file in folder
import glob
files = glob.glob("amazonproducts/*.html")

# find all the products
for fileName in files :
  with open(fileName) as f:
    text = BeautifulSoup(f)
    print text.findAll(class="productTitle")


# write out file for later
