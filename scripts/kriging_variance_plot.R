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

#open raster files and mask using US-Canada outline

calc_var <- raster("rasters/unmasked/calcium-KR-97648-median-10km-ZN_variance.tif") %>% mask(n.amer)
ph_var <- raster("rasters/unmasked/ph-KR-208784-median_10km_ZN_variance.tif") %>% mask(n.amer)

#prep data for plotting

calc_vardat <- calc_var %>%
  rasterToPoints() %>% 
  as.data.frame() %>%
  mutate(plotval = cut(calcium.KR.97648.median.10km.ZN_variance, c(0,740,1063,1548,2153,3000), labels = c("< Q25", "Q25-MEDIAN", "MEDIAN-Q75", "Q75-Q95", "> Q95"))) 

ph_vardat <- ph_var %>%
  rasterToPoints() %>% 
  as.data.frame() %>%
  mutate(plotval = cut(ph.KR.208784.median_10km_ZN_variance, c(0,0.44,0.48,0.54,0.61,1), labels = c("< Q25", "Q25-MEDIAN", "MEDIAN-Q75", "Q75-Q95", "> Q95"))) 

#plots

calc_varplot <- 
  ggplot() + 
  geom_tile(data=calc_vardat, aes(x=x,y=y,fill=plotval,colour=plotval)) +  
  scale_fill_manual(#name = "Kriging\nvariance",
                    guide = guide_legend(reverse = TRUE),
                    values=c("gold","firebrick1","firebrick","firebrick4","black")) + 
  scale_colour_manual(#name = "Kriging\nvariance",
                      guide = guide_legend(reverse = TRUE),
                      values=c("gold","firebrick1","firebrick","firebrick4","black")) +  
  geom_sf(data = n.amer, fill=NA, colour="grey25") +
  coord_sf(xlim = c(-4755010, 2995610), ylim = c(-1689950, 4514250), expand = FALSE) +
  theme_map() + 
  theme(legend.title = element_blank(),
        legend.text = element_text(size=6),
        legend.key.size = unit(0.35,"cm")) 

ph_varplot <- 
  ggplot() + 
  geom_tile(data=ph_vardat, aes(x=x,y=y,fill=plotval,colour=plotval)) +  
  scale_fill_manual(values=c("gold","firebrick1","firebrick","firebrick4","black")) + 
  scale_colour_manual(values=c("gold","firebrick1","firebrick","firebrick4","black")) +  
  geom_sf(data = n.amer, fill=NA, colour="grey25") +
  coord_sf(xlim = c(-4755010, 2995610), ylim = c(-1689950, 4514250), expand = FALSE) +
  theme_map() + 
  theme(legend.position = "none") 

#combine plots and save

var_plots <- ggarrange(calc_varplot,ph_varplot,labels=c("a","b"))  

ggsave(
  filename = "figures/kriging_variance_plots.png",
  plot = var_plots,
  device = "png",
  path = NULL,
  scale = 0.5,
  width = 30,
  height = 12,
  units = "cm",
  dpi = 1200,
  limitsize = TRUE,
  bg = "white")  

  