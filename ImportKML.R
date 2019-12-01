kml <- sf::st_read(file.choose())

#Make sure the spatial data look right
world <- ne_countries(scale = "large", returnclass = "sf")
p<-ggplot(data = world) +
  geom_sf() +
  coord_sf(xlim = c(ncLonMin, ncLonMax), ylim = c(ncLatMin, ncLatMax), expand = FALSE) +
  # add 200m contour
  geom_contour(data = bf, 
               aes(x=x, y=y, z=z),
               breaks=c(-100,-200,-300,-400, -500,-600,-700),
               size=c(0.4),
               colour="darkgrey", show.legend = FALSE) +
  geom_text_contour(data = bf, aes(x=x, y=y,z = z),breaks=c(-100,-200,-300,-400, -500,-600,-700), 
                    show.legend = FALSE, size = 2.2, alpha = .6, nudge_y = -.002) +
  geom_point(data=kml,
             # aes(Long,Lat,color= DateTimeUTC),
             aes(st_coordinates(kml$geometry)[,1],st_coordinates(kml$geometry)[,2]),
             size=5, color = 'red') +


geom_point(data=diveDiv[diveDiv$LungeCount > 0,],
           # aes(Long,Lat,color= DateTimeUTC),
           aes(Lon,Lat, color = VatT),
           size=1.5, alpha = 0.9) +
  scale_color_gradientn(colors = RColorBrewer::brewer.pal(n = 7, name = "RdBu"), #RdYlBu
                       values = rescale(c(-1, -0.5, -0.25, 0, 0.25, 0.5, 1)),
                       limits=c(-1, 1)) +

  annotation_scale(location = "bl", width_hint = 0.5) + 
  xlab("Longitude") + 
  ylab("Latitude") + 
  theme(panel.grid.major = element_line(color = gray(.5), linetype = "dashed", size = 0.5), panel.background = element_rect(fill = "aliceblue"))
p
  
