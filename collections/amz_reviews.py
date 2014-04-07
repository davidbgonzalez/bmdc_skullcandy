import csv
from amazonproduct import API

api=API()

BRANDS = ['skullcandy', 'beats by dre','house of marley', 'bose headphones','wicked audio','sennheiser headphones','able planet headphones','plantronics headphones','koss headphones','audio technica headphones', 'zagg headphones','monster headphones','meelectronics headphones','jbl headphones','tribeca headphones','urbanears','jabra headphones','beyerdynamic headphones','yurbuds headphones','ihip headphones','klipsch headphones','polk headphones','sol republic headphones','nad electronics headphones','shure headphones','sony headphones']

def main():
    i = 0
    for brand in BRANDS:
        bidx = BRANDS[i]
        outfile = '%s.out' % (BRANDS[i])
        products = api.item_search('Electronics', Keywords= bidx)
        for product in products:
            record = u""
            prodid = product.ASIN
            record += unicode(prodid +"|")
            ires = api.item_lookup(str(product.ASIN), ResponseGroup="ItemAttributes, Reviews")
            for r in ires.Items.Item:
                name = r.ItemAttributes.Title
                try:
                    ptype = u"%s" % r.ItemAttributes.ProductTypeName
                except:
                    ptype = u"null"
                try:
                    part = u"%s" % str(r.ItemAttributes.MPN)
                except:
                    part = u"null"
                try:
                    price = u"%s" % r.ItemAttributes.ListPrice.FormattedPrice
                except:
                    price = u"null"
                try:
                    pbrand = u"%s" % r.ItemAttributes.Brand
                except:
                    pbrand = u"null"
                try:
                    link = u"%s" % r.ItemLinks.ItemLink[5].URL
                except:
                    link = u"null"
                record += unicode(name + "|")
                record += unicode(ptype + "|")
                record += unicode(part + "|")
                record += unicode(price + "|")
                record += unicode(pbrand + "|")
                record += unicode(link)
                print(record)
        i+=1


if __name__=='__main__':
    main()
