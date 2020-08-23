

test <- cbind(' ' = '&oplus;', mtcars)
View(test)

install.packages("flexdashboard")
if (!require("DT")) install.packages('DT')

DT:::DT2BSClass(c('compact', 'cell-border'))

data_table_out <-data_export_dom_int %>% select( -starts_with("pts_"), -lat, -lng, -passed)
data_table_out$range <- forcats::fct_recode( data_table_out$range, `Many Tenant Protections` = "1", `Some Tenant Protections` = "2", `Few Tenant Protections` = "3")
data_table_out$resource <- case_when( data_table_out$resource == "" ~ "",
														TRUE ~paste0("<a href='",data_table_out$resource,"' target='_blank'>","link","</a>"))

data_table_out$link <- case_when( data_table_out$resource == "" ~ "",
																			TRUE ~paste0("<a href='",data_table_out$link,"' target='_blank'>","news link","</a>"))

data_table_out$end_date_legist <- lubridate::as_date(data_table_out$end_date_legist)
data_table_out$end_date_rent_relief <- lubridate::as_date(data_table_out$end_date_rent_relief)
data_table_out$end_date_court <- lubridate::as_date(data_table_out$end_date_court)
data_table_out$end_date_earliest <- lubridate::as_date(data_table_out$end_date_earliest)
data_table_out$place <- case_when( data_table_out$municipality == "" & data_table_out$state == "" ~ data_table_out$Country,
																	 data_table_out$municipality == "" ~data_table_out$state,
																	 TRUE ~ data_table_out$municipality)

row.names(data_table_out) <- data_table_out$place

data_table_out$place <- NULL

data_table_out <- data_table_out %>% select(-ISO, -starts_with("bool"))
data_table_out <- data_table_out %>% select(-starts_with("bool"))
# data_table_out %>% select(-starts_with("pts_"), -ISO, -range) %>% names()
# data_table_out <- data_table_out %>% select(Municipality = municipality, State=state, `Admin Scale` = admin_scale, `Policy Summary` = policy_summary, 
# 													`Protection Level` = range, `AEMP Score` = point_total,
# 													`Earliest Policy Expiration` = end_date_earliest,
# 													`Existence of Legist. Protections?` = bool_legist_exist,	`Legistlative Policy End Date` = end_date_legist, 
# 													`Existence of Rent Relief Protections?` = bool_rent_relief_exist, `Rent Relief Policy End Date` = end_date_rent_relief, 
# 													`Existence of Court Protections?` = bool_court_exist, `Court Policy End Date` = end_date_court, 
# 													`Policy Type` = policy_type, resource, 
# 													`Have Some Protections Expired` = has_expired_protections, 
# 													everything(), -Country, - ISO
													)
# names(data_table_out)
# # 'Policy Type': ' + d[12] + ', 'Existence of Legist. Protections?': ' + d[6] + ', 'Legistlative Policy End Date': ' + d[7] + ', 'Existence of Rent Relief Protections?': ' + d[8] + ' , Rent Relief Policy End Date: ' + d[9] + ', Existence of Court Protections?: ' + d[10] + ', Court Policy End Date: ' + d[11] + ', State Legal Status: ' + d[16] + ', State Legal Summary: ' + d[17] + 
# filter = 'top', class = 'cell-border stripe', rownames = FALSE,
# extensions = 'Buttons', 
# # colnames = c('Here', 'Are', 'Some', 'New', 'Names'),
# options = list(
# 	columnDefs = list(
# 		list(visible = FALSE, targets = c(9)),
# 		list(orderable = FALSE, className = 'details-control', targets = 1)
# 	),
# 	dom = 'Bfrtip',
# 	buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
# 	autoWidth = TRUE,
# 	escape = FALSE),



y <- datatable( cbind(' ' = '&oplus;', data_table_out)  ,
							 options = list(
							 	columnDefs = list(
							 		list(visible = FALSE, targets = c(10, 15)),
							 		list(orderable = FALSE, className = 'details-control', targets = 1)
							 	)
							 	),
								escape = FALSE,
							
							
  callback = JS("
							var table = $('#data').DataTable( {
        				rowReorder: {
            selector: 'td:nth-child(2)'
        				},
        			responsive: true
    						} );
							table.column(1).nodes().to$().css({cursor: 'pointer'});
							var format = function(d) {
								return '<div style=\"background-color:#eee; padding: .5em;\"> Policy Summary: ' + d[10] + ',  Legal Summary: ' + d[15] + '</div>';
							};
							table.on('click', 'td.details-control', function() {
								var td = $(this), row = table.row(td.closest('tr'));
								if (row.child.isShown()) {
									row.child.hide();
									td.html('&oplus;');
								} else {
									row.child(format(row.data())).show();
									td.html('&CircleMinus;');
								}
							});"
  							))

DT::saveWidget(y, 'export.html')
# setwd("C:\\Users\\azada\\OneDrive\\@Projects\\aemp\\covid_map\\_table")



$(document).ready(function() {
	var table = $('#example').DataTable( {
		rowReorder: {
			selector: 'td:nth-child(2)'
		},
		responsive: true
	} );
} );

options = list(
	initComplete = JS(
		"function(settings, json) {",
		"$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
		"}")
	
	
	, callback = JS('table.page("next").draw(false);'))


callback = JS("	var table = $('#example').DataTable( {
		rowReorder: {
			selector: 'td:nth-child(2)'
		},
		responsive: true
	} );")