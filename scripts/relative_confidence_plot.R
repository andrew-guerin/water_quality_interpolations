library(tidyverse)
library(sf)
library(rnaturalearth)
#library(rnaturalearthdata) #does not appear to be required
library(raster)
library(ggpubr)
library(ggthemes)

#preparation

if(!file.exists("figures")){
  dir.create("figures")
}

crs1 <- 4326
crs2 <- "ESRI:102008"

#country outlines

us <- ne_countries(country = "united states of america", scale = "large", returnclass = "sf" ) %>% st_transform(crs = crs2)
can <- ne_countries(country = "canada", scale = "large", returnclass = "sf" ) %>% st_transform(crs = crs2)
n.amer <- rbind(us, can)

#open raster files

calc_conf <- raster("rasters/masked/calcium_confidence.tif")
ph_conf <- raster("rasters/masked/ph_confidence.tif")

#prep data for plotting

calc_confdat <- calc_conf %>%
  rasterToPoints() %>% 
  as.data.frame() %>%
  mutate(plotval = cut(layer, c(0,0.2,0.4,0.6,0.8,1.1), labels = c("< 0.2","0.2-0.4","0.4-0.6","0.6-0.8","0.8-1"))) 

ph_confdat <- ph_conf %>%
  rasterToPoints() %>% 
  as.data.frame() %>%
  mutate(plotval = cut(layer, c(0,0.2,0.4,0.6,0.8,1.1), labels = c("< 0.2","0.2-0.4","0.4-0.6","0.6-0.8","0.8-1"))) 

#plots

calc_confplot <- 
  ggplot() + 
  geom_tile(data=calc_confdat, aes(x=x,y=y,fill=plotval,colour=plotval)) +  
  scale_fill_manual(values=c("darkred","red","blueviolet","dodgerblue","darkblue")) + 
  scale_colour_manual(values=c("darkred","red","blueviolet","dodgerblue","darkblue")) + 
  geom_sf(data=n.amer, fill=NA) +
  coord_sf(xlim = c(-4755010, 2995610), ylim = c(-1689950, 4514250), expand = FALSE) +
  theme_map() + 
  theme(legend.title = element_blank(),
        legend.text = element_text(size=6),
        legend.key.size = unit(0.25,"cm"))

ph_confplot <- 
  ggplot() + 
  geom_tile(data=ph_confdat, aes(x=x,y=y,fill=plotval,colour=plotval)) +  
  scale_fill_manual(values=c("darkred","red","blueviolet","dodgerblue","darkblue")) + 
  scale_colour_manual(values=c("darkred","red","blueviolet","dodgerblue","darkblue")) + 
  geom_sf(data=n.amer, fill=NA) +
  coord_sf(xlim = c(-4755010, 2995610), ylim = c(-1689950, 4514250), expand = FALSE) +
  theme_map() + 
  theme(legend.title = element_blank(),
        legend.text = element_text(size=6),
        legend.key.size = unit(0.25,"cm"))
  
#combine plots and save

conf_plots <- ggarrange(calc_confplot,ph_confplot,labels=c("a","b"))  

ggsave(
  filename = "figures/confidence_plots.png",
  plot = conf_plots,
  device = "png",
  path = NULL,
  scale = 0.5,
  width = 30,
  height = 12,
  units = "cm",
  dpi = 1200,
  limitsize = TRUE,
  bg = "white")  

  