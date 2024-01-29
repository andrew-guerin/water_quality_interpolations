
library(tidyverse)
library(sf)
library(rnaturalearth)
library(gstat)
library(raster) #note  - masks dplyr::select
library(ggthemes)

if(!file.exists("figures")){
  dir.create("figures")
}

#coordinate reference systems 
crs1 <- 4326 
crs2 <- "ESRI:102008"

#country outlines
us <- ne_countries(country = "united states of america", scale = "large", returnclass = "sf" ) %>% st_transform(crs = crs2) 
can <- ne_countries(country = "canada", scale = "large", returnclass = "sf" ) %>% st_transform(crs = crs2)
n.amer <- rbind(us, can)

# load rasters and mask with country outlines
calc_raster <- raster("rasters/unmasked/calcium-KR-97648-median-10km-ZN.tif") %>% mask(n.amer)
ph_raster <- raster("rasters/unmasked/ph-KR-208784-median_10km_ZN.tif") %>% mask(n.amer)

#prepare plotting data

calc_plotdata <- calc_raster %>% 
  rasterToPoints() %>% 
  as.data.frame() %>%
  rename(layer="calcium.KR.97648.median.10km.ZN") %>%
  #mutate(grades = cut(layer,c(0,5.4999,10.4999,15.4999,20.4999,25.4999,30.4999,501),
  #                     labels=c("0 - 5","6 - 10","11 - 15","16 - 20","21 - 25","26 - 30","> 30")))  %>%
  mutate(grades = cut(layer,c(0,5.4999,10.4999,15.4999,20.4999,25.4999,30.4999,35.4999,40.4999,45.4999,50.4999,501),
                       labels=c("0 - 5","6 - 10","11 - 15","16 - 20","21 - 25","26 - 30","31 - 35","36 - 40","41 - 45","46 - 50","> 50")))
  
  
ph_plotdata <- ph_raster %>% 
  rasterToPoints() %>% 
  as.data.frame() %>%
  rename(layer="ph.KR.208784.median_10km_ZN") %>%
  mutate(phcat = cut(layer, c(0,5.5,6,6.5,7,7.5,8,8.5,13), 
                      labels = c("<5.5","5-5.5","5.5-6","6.5-7.","7-7.5","7.5-8","8-8.5",">8.5"))) 

#calcium plot

plot_calc <- 
  ggplot() +
  geom_tile(data=calc_plotdata,aes(x=x,y=y,fill=grades,colour=grades)) +
  scale_fill_manual(bquote("Calcium, mg L"^-1), 
                    guide = guide_legend(reverse = TRUE),
                    #values = c("#4575B4","#91BFDB","#E0F3F8","#FFFFBF","#FEE090","#FC8D59","#D73027"),
                    values = c("#313695","#4575B4","#74ADD1","#ABD9E9","#E0F3F8","#FFFFBF","#FEE090","#FDAE61","#F46D43","#D73027","#A50026")) +
  scale_colour_manual(bquote("Calcium, mg L"^-1), 
                      guide = guide_legend(reverse = TRUE),
                      #values = c("#4575B4","#91BFDB","#E0F3F8","#FFFFBF","#FEE090","#FC8D59","#D73027"),
                      values = c("#313695","#4575B4","#74ADD1","#ABD9E9","#E0F3F8","#FFFFBF","#FEE090","#FDAE61","#F46D43","#D73027","#A50026")) +
  geom_sf(data=n.amer, fill=NA) +
  coord_sf(xlim = c(-4755010, 2995610), ylim = c(-1689950, 4514250), expand = FALSE) +
  theme_map() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16))

ggsave(
  filename = "figures/calcium_map.png",
  plot = plot_calc,
  device = "png",
  path = NULL,
  scale = 0.5,
  width = 40,
  height = 30,
  units = "cm",
  dpi = 600,
  limitsize = TRUE,
  bg = "white") 

ggsave(
  filename = "figures/calcium_map.tif",
  plot = plot_calc,
  device = "tiff",
  path = NULL,
  scale = 0.5,
  width = 40,
  height = 30,
  units = "cm",
  dpi = 600,
  limitsize = TRUE,
  bg = "white") 


#pH plot 

plot_ph <- 
  ggplot() +
  geom_tile(data=ph_plotdata, aes(x=x,y=y,fill=phcat,colour=phcat)) +
  scale_fill_manual("pH",
                    guide = guide_legend(reverse = TRUE),
                    values=c("#0D0887FF",
                             "#5402A3FF",
                             "#8B0AA5FF",
                             "#B93289FF",
                             "#DB5C68FF",
                             "#F48849FF",
                             "#FEBC2AFF",
                             "#F0F921FF")) +
  scale_colour_manual("pH", 
                      guide = guide_legend(reverse = TRUE),
                      values=c("#0D0887FF",
                               "#5402A3FF",
                               "#8B0AA5FF",
                               "#B93289FF",
                               "#DB5C68FF",
                               "#F48849FF",
                               "#FEBC2AFF",
                               "#F0F921FF")) +
  geom_sf(data=n.amer, fill=NA) +
  coord_sf(xlim = c(-4755010, 2995610), ylim = c(-1689950, 4514250), expand = FALSE) +
  theme_map() +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size=16)) 


ggsave(
  filename = "figures/ph_map.png",
  plot = plot_ph,
  device = "png",
  path = NULL,
  scale = 0.5,
  width = 40,
  height = 30,
  units = "cm",
  dpi = 600,
  limitsize = TRUE,
  bg = "white") 

ggsave(
  filename = "figures/ph_map.tif",
  plot = plot_ph,
  device = "tiff",
  path = NULL,
  scale = 0.5,
  width = 40,
  height = 30,
  units = "cm",
  dpi = 600,
  limitsize = TRUE,
  bg = "white") 

