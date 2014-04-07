from subprocess import call

# open the file you want to process
filename = "getthese.csv"
s3bucket = "skullcandy-data-amazon-products"

# make sure those folders exist
call(["s3cmd","mb","s3://"+s3bucket])


# get all the product ids from file
with open(filename) as f:
    files_on_s3 = f.readlines()

products = map(lambda s: s.strip(), files_on_s3)

#products = ("B007136EDG","B007136E1S")


# for each product
for product in products:
  
  product = product.split(",")[0]
  print "########## "+product+" Now downloading"
  # start downloading the reviews files
  call(["./downloadAmazonReviews.pl","com",product])

  print "########## "+product+" Now extracting"
  # process the downloaded files
  call("./extractAmazonReviews.pl"+" amazonreviews/com/"+product+" > final_data/"+product+".csv",shell=True)

  print "########## "+product+" upload to S3"
  # upload file to aws
  call(["s3cmd","put","final_data/"+product+".csv","s3://"+s3bucket+"/"])
