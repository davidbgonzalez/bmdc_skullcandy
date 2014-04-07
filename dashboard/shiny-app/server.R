# shiny::runApp('C:/Users/aalexander/Documents/Personal/big data competition - spring 2014/skullcandy/shiny-app/')

library(shiny)
library(ggplot2)
library("maps")
library(rjson)


if(.Platform$OS.type=="windows"){
setwd('C:/Users/aalexander/Documents/Personal/big data competition - spring 2014/skullcandy/shiny-app/')
} else {
  setwd('/srv/shiny-server/shiny-app/')
}

dataset = read.csv('skullcandy.csv')
load("brands.Rda")
load("twitter_followers.Rda")
amazon_product = read.csv("amazon_product.csv",header=F)
# define products to get!
#getthese = unique(amazon_product[amazon_product$V6=="Skullcandy" | amazon_product$V6=="Yurbuds","V1"])
#write.table(getthese,"getthese.csv",quote=F,row.names=F,col.names=F)


if(0){
load("sc_amz_cross_merge.RData")
sc_amz_cross_merge$transdate = as.POSIXct(as.character(sc_amz_cross_merge$transdate),format="%m/%d/%Y %H:%M:%S %p")
sc_amz_cross_merge$month = format(sc_amz_cross_merge$transdate,format="%Y-%m")
sc_amz_cross_merge$brand = as.character(sc_amz_cross_merge$brand.y)
sc_amz_cross_merge[which(!is.na(sc_amz_cross_merge$brand.x)),"brand"] <- as.character(sc_amz_cross_merge[which(!is.na(sc_amz_cross_merge$brand.x)),"brand.x"] )
sc_amz_cross_merge$brand <- as.factor(sc_amz_cross_merge$brand)
save(sc_amz_cross_merge,file="sc_amz_cross_merge.Rda")

amazon_brands = sort(table(sc_amz_cross_merge$brand.y),decreasing=T)
# amazon_brands = unique(reviews$brand.y)
save(amazon_brands,file="amazon_brands.Rda")

brands_lookup = as.data.frame(brands)
names(brands_lookup) <- c("twitter_brand")
brands_lookup[brands_lookup$twitter_brand==""]
}
load("sc_amz_cross_merge.Rda")
load("amazon_brands.Rda")

#reviews = read.csv('final_data.csv')
#reviews[, "date"] = as.Date(reviews[, "date"])
#filter = which(reviews[, "date"]>as.Date("2010-01-01"))
#reviews = reviews[filter,]
#save(reviews,file="reviews.Rda")
load("reviews.Rda")
#reviews = merge(reviews,sc_amz_cross_merge[,c("asin","brand.y","amz_category")],by.x = "id",by.y="asin")
#reviews$month = format(reviews$date,format="%Y-%m")

dataset$has_location = 0
ncharlatlon = sapply(as.character(dataset$lat.lon),FUN=nchar)
dataset[which(ncharlatlon>5),'has_location'] <- 1

dataset$social_buyer = round(runif(nrow(dataset)))
dataset$social_feeler = round(runif(nrow(dataset)))
dataset$social_hater = round(runif(nrow(dataset)))
dataset$social_leader = round(runif(nrow(dataset)))

shinyServer(function(input, output, session) {
  
  
  output$ts <- renderPlot({
    #filter = which(!is.na(sc_amz_cross_merge$month))
    #toplot = aggregate(sc_amz_cross_merge[filter,"quantity_ordered"],by=list(sc_amz_cross_merge[filter, "month"]),FUN=sum,na.rm=T)
    #plot(as.Date(paste(toplot$Group.1,"01",sep="-")),toplot$x,type="l")
    
    
    filter = T
    if(length(input$brands)>0){
      filter = which(reviews$brand.y %in% input$brands)
    }
    filter2 = T
    if(length(input$prod_cat)>0){
      filter2 = which(reviews$amz_category %in% input$prod_cat)
    }
    filter = intersect(filter, filter2)
    
    p <- ggplot(reviews[filter,], aes_string(x="date", y="star_rating", group="brand.y", colour="brand.y"))
    facets <- paste('.', '~', '.')
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    p <- p + geom_smooth()
    print(p)
    
  })
  
  output$reviews <- renderDataTable({
    viewt = reviews[which(reviews$brand.y %in% input$brands & reviews$amz_category %in% input$prod_cat),]
    viewt = viewt[order(viewt$total_votes,decreasing=T),]
    viewt = viewt[1:min(20,nrow(viewt)),]
    },
                         options = list(
                           iDisplayLength = 5
                         )
  )
  
  output$ts_bubble <- renderPlot({
    #reviews = reviews[order(reviews$total_votes,decreasing=T),]
    bubbles = reviews[which(reviews$brand.y %in% input$brands & reviews$amz_category %in% input$prod_cat),]
    # only first 200
    #bubbles = bubbles[1:min(10000,nrow(bubbles)),]
    bubbles$Helpfulness = (bubbles$yes_helpful)/(bubbles$total_votes)
    bubbles[which(bubbles$total_votes==0),"Helpfulness"] <- 0
    # exagurated popularity
    bubbles$votes = bubbles$total_votes/max(bubbles$total_votes)*30
    p <- ggplot(bubbles, aes_string(x="date", y="star_rating")) +
      ylab("SENTIMENT (Number of Stars)") + 
      geom_point(
        aes(size=votes,colour=Helpfulness)
      ) + 
      labs(colour = "Helpfulness")
    facets <- paste("brand.y", '~', ".")
    if (facets != '. ~ .')
      p <- p + facet_grid(facets)
    print(p)
  })
  
  
  output$plot_map <- renderPlot({
    map(input$map_location, plot = TRUE, fill = FALSE, col = palette())
    dataset = dataset_sampled()
    dataset$'lat.lon'
    lat = rep(NA,nrow(dataset))
    lon = rep(NA,nrow(dataset))
    ncharlatlon = sapply(as.character(dataset$lat.lon),FUN=nchar)
    lat[which(ncharlatlon>5)] <- as.numeric(sapply(strsplit(as.character(dataset$lat.lon[which(ncharlatlon>5)]),":"),`[[`,1))
    lon[which(ncharlatlon>5)] <- as.numeric(sapply(strsplit(sapply(strsplit(as.character(dataset$lat.lon[which(ncharlatlon>5)]),"\t"),`[[`,1),":"),`[[`,2))
    points(x=lon,y=lat,col=dataset$language,cex=log(dataset$avg_shares)/max(log(dataset$avg_shares))*4)
  }, height=400)
  
  if(0){
  output$view <- renderTable({
    dd = data.frame(
      sum(df[,paste("brand",input$brand,"twitter-followers",input$brand,sep="-")],na.rm=T),
      sum(df[,paste("brand",input$comp_brand,"twitter-followers",input$comp_brand,sep="-")],na.rm=T),
      sum(df[,paste("brand",input$comp_brand,"twitter-followers",input$comp_brand,sep="-")] %in% 1 & df[,paste("brand",input$brand,"twitter-followers",input$brand,sep="-")] %in% 1 )
    )
    names(dd) = c("a","b","c")
    dd
  })
  }
  
  #observe({
  #  session$sendCustomMessage(type = 'circles',
  #      message = list( 
  #        circle2_r = round(sum(df[,paste("brand",input$subgroup,"twitter-followers",input$subgroup,sep="-")] %in% 1 & df[,paste("brand",input$brand,"twitter-followers",input$brand,sep="-")] %in% 1)/sum(df[,paste("brand",input$brand,"twitter-followers",input$brand,sep="-")],na.rm=T)*100), 
  #        circle1_label = 'text'))
  #})
  
  observe({
    
    df_simple = table(df[which(
      df$'brand-beatsbydre-twitter-followers-beatsbydre'==1 | 
        df$'brand-Skullcandy-twitter-followers-Skullcandy' == 1| 
        df$'brand-monsterproducts-twitter-followers-monsterproducts' == 1| 
        df$'brand-bose-twitter-followers-bose' == 1| 
        df$'brand-yurbuds-twitter-followers-yurbuds' == 1
      ),c(
        "brand-Skullcandy-twitter-followers-Skullcandy",
        "brand-beatsbydre-twitter-followers-beatsbydre",
        "brand-monsterproducts-twitter-followers-monsterproducts",
        "brand-bose-twitter-followers-bose",
        "brand-yurbuds-twitter-followers-yurbuds"
      )],useNA="ifany")
    
    
    
    xy.df = as.data.frame(ftable(df_simple))
    cols = c("Skullcandy","Beats","Monster","Bose",'yurbuds')
    names(xy.df) <- c(cols,"values")
    
    xy.list = vector("list", nrow(xy.df))
    for(each_row in 1:nrow(xy.df)){
      xy.list[[each_row]]=as.list(as.vector(data.frame(xy.df[each_row,])))
    }
    
    csv_json = toJSON(xy.list)
    
    
    
    
    session$sendCustomMessage(type = 'cat_data',
                              message = list( 
                                data = csv_json,
                                cols = cols))
  })
  
  output$summary <- renderPrint({ input$prod_cat })
  
})


