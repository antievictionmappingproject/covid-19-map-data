# 
# library("googledrive")
# drive_find(type = "spreadsheet") 
# 
# 1PCPWLyyreBHMqRmqM5RiUb0xB6Ja_ADf85t5r79Bp3E


library(ggplot2)

# qplot(data)

table((data_int_graphs %>% filter(ISO != "USA"))$range, (data_int_graphs %>% filter(ISO != "USA"))$admin_scale )

gd <- data_export1 %>% 
	group_by(admin_scale) %>% 
	summarise(
		point_total = mean(point_total))

# Plot both data sets
ggplot( data_export1, aes(x = as.numeric(point_total), fill = as.factor(range) )) +
	geom_histogram() +  geom_vline(data=gd, aes(xintercept=point_total, color=admin_scale ))+
	theme_bw() + theme(legend.position="top")
	# geom_line(data = gd, x = point_total)


ggplot(data_export1, aes(x = admin_scale, y = as.numeric(range), color = admin_scale, fill = admin_scale)) +
# geom_hline(data = gd, aes(yintercept = rank, color = admin_scale), alpha = .3, size = 3) +
ggrepel::geom_text_repel(aes(label = municipality), color = "black", size = 2.5, segment.color = "grey") +
geom_point() +
	guides(color = "none", fill = "none") +
	theme_bw() +
	labs(
		title = "Range Totals",
		x = "Admin Style",
		y = "Range"
	)

data_export_dom_int -> data_int_graphs

data_int_graphs$geocountry <- trimws(toupper(data_int_graphs$Country))
data_int_graphs$geostate <- trimws(toupper(data_int_graphs$state))

data_int_graphs <- data_int_graphs %>% mutate( municipality =  case_when( municipality != "" ~ municipality,
																																					municipality == "" & state != "" ~ state,
																																					municipality == "" & state == "" ~ Country))
																	 
# data_int_graphs$geo <- ifelse( stringr::fixed(as.character(data_tab$state)) ==
# 													stringr::fixed(trimws(toupper(data_tab$where_does_this_protection_or_campaign_apply))),
# 												data_tab$state,
# 												paste(data_tab$where_does_this_protection_or_campaign_apply,  data_tab$state, sep = ", " ))

forcats::fct_relevel(data_int_graphs$admin_scale, "City", "State", "Country") -> data_int_graphs$admin_scale

#international grouping
ggplot(data_int_graphs %>% filter(ISO != "USA" & municipality != "West Virginia"), aes(x = admin_scale, y = as.factor(range), color = admin_scale, fill = admin_scale)) +
	# geom_hline(data = gd, aes(yintercept = rank, color = admin_scale), alpha = .3, size = 3) +
	ggrepel::geom_text_repel(aes(label = municipality), color = "black", size = 3.5, segment.color = "grey") +
	geom_point() +
	guides(color = "none", fill = "none") +
	theme_bw() +
	labs(
		title = "Range Totals",
		x = "Admin Style",
		y = "Range"
	)



qplot(data_int_filter$range, fill= data_int_filter$admin_scale)
qplot(data_export_dom_int$range, fill= data_export_dom_int$admin_scale)
qplot(as.numeric(data_export_dom_int$point_total), fill= data_export_dom_int$admin_scale)

qplot(as.numeric( (data_export_dom_int %>% filter(admin_scale == "City"))$point_total	), fill= (data_export_dom_int %>% filter(admin_scale == "City"))$admin_scale)
qplot(as.numeric( (data_export_dom_int %>% filter(admin_scale == "County"))$point_total	), fill= (data_export_dom_int %>% filter(admin_scale == "County"))$admin_scale)
qplot(as.numeric( (data_export_dom_int %>% filter(admin_scale == "State"))$point_total	), fill= (data_export_dom_int %>% filter(admin_scale == "State"))$admin_scale)

## grouped variable summaries

## plotly


qplot(data_export1$point_total, fill= data_export1$admin_scale)
qplot(data_export1$point_total, color = data_export1$admin_scale)
qplot(data_export1$point_total, color = admin_scale)
qplot(data_export1$point_total)

# ggplot2::ggplot( data_tab, aes( long, lat),color="grey98") +
# 	borders("state") + theme_classic() + geom_point() +
# 	theme(line = element_blank(),text = element_blank(),title = element_blank()) +
# 	ggrepel::geom_label_repel(aes(label =geo),show.legend=F) +
# 	scale_x_continuous(breaks = NULL) + scale_y_continuous(breaks = NULL)
