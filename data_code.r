
# devtools::install_github("tidyverse/googlesheets4") run once installs
# install.packages('rlist', 'tidygeocoder', 'tidyverse', 'qdapTools', 'jsonlite', 'rvest')
# remotes::install_github("bergant/airtabler")

library(googlesheets4)
library(airtabler)
library(dplyr)
library(janitor)
library(tidygeocoder)
library(qdapTools)
library(jsonlite)
library(rvest)
library(glue)

lev_of <- function(x) {levels(as.factor(x) )}
'%!in%' <- function(x,y)!('%in%'(x,y))

## put your own dropbox folder and sheet locations in .env
source(".env")

#   ____________________________________________________________________________
#   Read AEMP Data and Wait for Interactive Authentication                  ####

# run read_sheet command once interactively to auth each session 
# and then you can run the rest of the code in one go, 
data <- read_sheet(gsheet_env)


# __          __       _____  _______ #
# \ \        / //\    |_   _||__   __|#
#  \ \  /\  / //  \     | |     | |   #
# 	\ \/  \/ // /\ \    | |     | |   #
# 	 \  /\  // ____ \  _| |_    | |   #
#     \/  \//_/    \_\|_____|   |_|   #
	


#   ____________________________________________________________________________
#   RUN AGAIN                                                               ####
data <- janitor::clean_names(data)

# google form questions had spanish translations added which changed variable names, this reverts names so code runs

data <- data %>% select(
	after_the_temporary_protection_ends_how_long_will_tenants_have_to_pay_the_rent_they_missed_during_the_emergency = after_the_temporary_protection_ends_how_long_will_tenants_have_to_pay_the_rent_they_missed_during_the_emergency_despues_que_la_emergencia_ha_terminado_cuanto_tiempo_tienen_los_inquilinos_para_pagar_la_renta_que_no_han_pagado,
	how_are_tenants_protected_against_eviction = how_are_tenants_protected_against_eviction_como_se_protege_a_los_inquilinos_contra_el_desalojo,
	what_types_of_evictions_are_protected = what_types_of_evictions_are_protected_que_tipos_de_desalojos_estan_protegidos,
	what_u_s_state_or_territory_is_it_in = what_u_s_state_or_territory_is_it_in_en_que_estado_o_territorio_de_los_estados_unidos_esta_implementada_la_regulacion,
	where_does_this_protection_or_campaign_apply = where_does_this_protection_or_campaign_apply_donde_esta_implementada_la_medida_de_proteccion_o_campana,
	does_the_notification_have_to_be_in_writing = does_the_notification_have_to_be_in_writing_debe_ser_la_notificacion_por_escrito,
	do_tenants_have_to_provide_documentation_of_their_need_for_the_protection_e_g_that_they_cant_afford_to_pay_rent = 
		do_tenants_have_to_provide_documentation_of_their_need_for_the_protection_e_g_that_they_cant_afford_to_pay_rent_deben_los_inquilinos_proveer_alguna_documentacion_para_su_proteccion_por_ejemplo_justificar_que_no_pueden_pagar_la_renta,
	when_do_tenants_have_to_provide_documentation = 
		when_do_tenants_have_to_provide_documentation_cuando_es_que_los_inquilinos_tienen_que_proveer_documentacion,
	do_tenants_have_to_provide_documentation_of_their_need_for_the_protection_e_g_that_they_cant_afford_to_pay_rent = 
		do_tenants_have_to_provide_documentation_of_their_need_for_the_protection_e_g_that_they_cant_afford_to_pay_rent_deben_los_inquilinos_proveer_alguna_documentacion_para_su_proteccion_por_ejemplo_justificar_que_no_pueden_pagar_la_renta,
	what_does_the_law_say_about_paying_part_of_the_rent =
		what_does_the_law_say_about_paying_part_of_the_rent_que_es_lo_que_la_ley_dice_acerca_de_pagar_renta_parcial,
	can_landlords_charge_late_fees_or_interest_on_missed_rent_payments =
		can_landlords_charge_late_fees_or_interest_on_missed_rent_payments_pueden_los_propietarios_cobrar_cargo_por_retraso_o_interes_en_renta_no_pagada,
	what_does_the_policy_say_about_repayment_plans =
		what_does_the_policy_say_about_repayment_plans_que_dice_la_medida_de_proteccion_acerca_de_planes_de_pago,
	are_courts_holding_eviction_proceedings =
		are_courts_holding_eviction_proceedings_estan_los_tribunales_llevando_a_cabo_procedimientos_de_desalojo,
	will_courts_issue_writs_of_possession_i_e_order_the_tenant_to_leave =
		will_courts_issue_writs_of_possession_i_e_order_the_tenant_to_leave_estan_las_cortes_dando_ordenes_de_desalojo_es_decir_ordenaran_que_el_inquilino_se_vaya,
	will_law_enforcement_act_on_writs_of_possession_i_e_forcibly_remove_tenants_from_their_homes =
		will_law_enforcement_act_on_writs_of_possession_i_e_forcibly_remove_tenants_from_their_homes_tomaria_accion_las_agencias_de_policia_sobre_la_orden_de_desalojo_es_decir_sacar_a_la_fuerza_a_los_inquilinos_de_sus_hogares,
	is_there_a_ban_on_rent_increases = 
		is_there_a_ban_on_rent_increases_existe_una_prohibicion_de_aumentos_de_renta,
	can_landlords_charge_late_fees_or_interest_on_missed_rent_payments = 
		can_landlords_charge_late_fees_or_interest_on_missed_rent_payments_pueden_los_propietarios_cobrar_cargo_por_retraso_o_interes_en_renta_no_pagada,
	can_tenants_pay_some_or_all_of_their_rent_out_of_their_security_deposit = 
		can_tenants_pay_some_or_all_of_their_rent_out_of_their_security_deposit_pueden_los_inquilinos_pagar_parte_o_toda_la_renta_con_su_deposito_de_garantia,
	do_you_want_to_tell_us_about_eviction_protections = 
		do_you_want_to_tell_us_about_eviction_protections_nos_puedes_platicar_sobre_protecciones_contra_el_desalojo,
	do_you_want_to_tell_us_about_an_rental_relief_protection =
		do_you_want_to_tell_us_about_an_rental_relief_protection_quiere_contarnos_sobre_subsidio_para_la_renta,
	do_you_want_to_tell_us_about_a_court_law_enforcement_policy_change =
		do_you_want_to_tell_us_about_a_court_law_enforcement_policy_change_quiere_decirnos_sobre_cambios_en_las_medidas_de_proteccion_relacionadas_con_su_implementacion_o_su_cumplimiento,
	is_it_in_the_united_states_or_a_u_s_territory = is_it_in_the_united_states_or_a_u_s_territory_la_medida_se_encuentra_en_los_estados_unidos_o_alguno_de_sus_territorios,
	is_this_an_active_organizing_campaign_or_a_tenant_protection_that_has_been_enacted = is_this_an_active_organizing_campaign_or_a_tenant_protection_that_has_been_enacted_la_politica_que_nos_compartes_es_una_campana_para_una_nueva_medida_o_una_medida_de_proteccion_que_ya_esta_implementada,
	tenant_protection_policy_summary =
		tenant_protection_policy_summary_resumen_de_las_politicas_de_proteccion_a_los_inquilinos,
	link_to_source = link_to_source_link_al_recurso,
	tenant_resources =	tenant_resources_recursos_para_inquilinos,
	
	
	everything()
)







##  ............................................................................
##  Benfer / Columbia State Legal Data                                      ####

# downloading via html not sheets 
url <- "https://docs.google.com/spreadsheets/u/1/d/e/2PACX-1vTH8dUIbfnt3X52TrY3dEHQCAm60e5nqo0Rn1rNCf15dPGeXxM9QN9UdxUfEjxwvfTKzbCbZxJMdR7X/pubhtml?gid=1277129435&single=true&urp=gmail_link"
page <- read_html(url)
table <- html_table(page, fill = TRUE)
data_nyu <- table[[1]]
data_nyu <- data_nyu[-1, ]

name <- (data_nyu[1, ])

data_nyu <- data_nyu[-1, ]
data_nyu <- data_nyu[-1, ]
names(data_nyu) <- name

data_nyu <- data_nyu %>% clean_names()
data_nyu_state <- data_nyu %>% filter(grepl( "SUMMARY$", state ))

#fix an input error that makes a state join down the line not work
data_nyu_state <- data_nyu_state %>%
	mutate(state_field = ifelse(stringr::str_detect(state, "MARYLAND \\(MD SUMMARY"), "MARYLAND (MD) SUMMARY", state))
data_nyu_state$state_field <- sub(" CURRENT SUMMARY","",data_nyu_state$state_field)
data_nyu_state$state_field <- sub(" CURRENTSUMMARY","",data_nyu_state$state_field)	
data_nyu_state$state_field <- sub(" SUMMARY","",data_nyu_state$state_field)	
data_nyu_state$state_field <- sub(" CURRENT","",data_nyu_state$state_field)	

data_nyu_state$state_field <- stringr::str_sub(data_nyu_state$state_field, end = -6)
data_nyu_state$current_status <- as.factor(data_nyu_state$current_status)
readr::write_csv(data_nyu_state, paste("./data_log/data_nyu",lubridate::today(),".csv"))

#   ____________________________________________________________________________
#   Feature Creation - Turn Entries and Variables Into Scorables Features   ####


# variable comes in a list convert to string
data$how_long <- data$after_the_temporary_protection_ends_how_long_will_tenants_have_to_pay_the_rent_they_missed_during_the_emergency
data$how_long1 <- as.factor(sapply(data$how_long,function(x) ifelse(is.null(x),NA,x)))

data$end_date_31 <- as.numeric(sapply(data$end_date_31,function(x) ifelse(is.null(x),NA,x)))
data$end_date_31 <- lubridate::as_datetime(data$end_date_31)

data$reviewed_date <- as.numeric(sapply(data$reviewed_date,function(x) ifelse(is.null(x),NA,x)))
data$reviewed_date <- lubridate::as_datetime(data$reviewed_date)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Q1 Policy Type - How Are Tenants Protected Against Eviction             ####

data_fact <- data %>% select(how_are_tenants_protected_against_eviction )
data_fact$protect <- stringr::str_replace_all(as.character(data_fact$how_are_tenants_protected_against_eviction), 
																							stringr::fixed("Moratorium (landlords are not allowed to serve notices to tenants)") ,
																							"Moratorium")
data_fact$protect <- stringr::str_replace_all(as.character(data_fact$protect), 
																							stringr::fixed("Defense (tenants have a defense in court against eviction actions)") ,
																							"Defense")
data_fact$protect <- as.factor(data_fact$protect)

# tabulate and split google forms multiple selections
data_fact_protect <- mtabulate(strsplit(as.character(data_fact$protect), "\\s*,\\s*"))
names(data_fact_protect) <- paste0( "tenant_protection_", make_clean_names(names(data_fact_protect)))
data_fact_protect_rejoin <- data_fact_protect %>% select(tenant_protection_defense, tenant_protection_moratorium)



### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Q2 What Types of Evictions                                              ####

data_fact2 <- data %>% select(what_types_of_evictions_are_protected)
source(file = "./code_sourcing/code_factors.r")
#returns data_fact_evictions_rejoin

##  ............................................................................
##  rejoin and write out current data logs and factors                      ####

data_tab <- bind_cols(data, data_fact_protect_rejoin, data_fact_evictions_rejoin) %>% 
	select(-after_the_temporary_protection_ends_how_long_will_tenants_have_to_pay_the_rent_they_missed_during_the_emergency, -how_long	)

readr::write_csv(data_tab, paste("./data_log/data_aemp",lubridate::today(),"2.csv"))
data_log <- data %>% select_if(is.factor)  %>% purrr::map(levels)
rlist::list.save(data_log, paste('./variable_log/factor_list',lubridate::today(),'2.rdata'))


##  ............................................................................
##  Geocode Places and Counties                                             ####

data_tab$state <- trimws(toupper(data_tab$what_u_s_state_or_territory_is_it_in))

# uses correct municipality or state depending on what is blank or filled in
data_tab$geo <- ifelse( stringr::fixed(as.character(data_tab$state)) == 
	stringr::fixed(trimws(toupper(data_tab$where_does_this_protection_or_campaign_apply))),
	data_tab$state,
	paste(data_tab$where_does_this_protection_or_campaign_apply,  data_tab$state, sep = ", " ))

data_tab <- data_tab %>% mutate(geo = gsub("Ã±", "ñ", geo))

# read in previously geocoded data to reduce geocoding time
# change to latest version when updating on write
data_gc <- readr::read_csv("./geocode_log/geocodes_2020-06-10.csv") 

data_tab <- data_tab %>% left_join(data_gc, by = "geo")

# OSM geocoder + geocoding bank

data_tab_gc    <- data_tab %>% filter( !is.na(lat) )
data_tab_to_gc <- data_tab %>% filter( is.na(lat) )

if( nrow(data_tab_to_gc) != 0){
	data_tab_to_gc <- data_tab_to_gc %>%  tidygeocoder::geocode(geo, method='cascade') 
	data_tab2 <- bind_rows( data_tab_gc, data_tab_to_gc )
} else{
	data_tab2 <- bind_rows(data_tab_gc )	
}

# run this every once in a while
# readr::write_csv( (data_tab2 %>% select(geo, lat, long)), paste0("./geocode_log/geocodes_",lubridate::today(),'.csv'))


##  ............................................................................
##  Rejoin state legal data with geocoded aemp data                         ####

data_tab_nyu <- data_tab2 %>% left_join(data_nyu_state, by = c( "state" = "state_field" ) )

# sniff test / check check for unmatched states
#data_unmatched_state <- data_nyu_state %>% anti_join(data_tab, by = c( "state_field" = "state" ) )
#data_unmatched_state %>% View


#   ____________________________________________________________________________
#   POINT SCORING                                                           ####

source("./code_sourcing/code_points.r")


### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Creating Ranked Summary                                                 ####

data_tab_out <- bind_cols(data_tab_nyu, data_points1 %>% 
	select(pts_total), data_points2, data_points3, data_points4, 
	data_points5, data_points6, data_points7, data_points8, data_points9, data_points10, data_points11)


#   ____________________________________________________________________________
#   Data Reconciliation                                                    ####

data_tab_out$policy_type = case_when(stringr::fixed(data_tab_out$do_you_want_to_tell_us_about_eviction_protections) %in% c("Yes") ~ "Legistlative Eviction Protection", 
	stringr::fixed(data_tab_out$do_you_want_to_tell_us_about_an_rental_relief_protection) %in% c("Yes") ~ "Rental Relief Policy",
	stringr::fixed(data_tab_out$do_you_want_to_tell_us_about_a_court_law_enforcement_policy_change) %in% c("Yes") ~ "Court-Based Eviction Policy",
	TRUE ~ NA_character_)

# data_tab_out$
# recode 
# expication_date as court / 


data_export <- data_tab_out %>% select(municipality = geo, state, 
	Country = is_it_in_the_united_states_or_a_u_s_territory, 
	admin_scale = what_scale_does_it_apply_to_alcance_o_nivel_administrativo,
	lat, lng = long, passed = is_this_an_active_organizing_campaign_or_a_tenant_protection_that_has_been_enacted, 
	end_date_earliest = earliest_date_expiration, end_date_legist = end_date_31, end_date_rent_relief = end_date_36, end_date_court = end_date_43,
	policy_summary = tenant_protection_policy_summary,
	policy_type, link = link_to_source, resource = tenant_resources,
	state_level_legal_status = current_status, state_level_legal_summary = state_summary, 
	point_total = pts_total, starts_with("pts_"))

data_export$municipality <- stringi::stri_trans_totitle(sapply(strsplit(data_export$municipality,","), `[`, 1))
data_export$state <- stringi::stri_trans_totitle(data_export$state)
data_export$Country <- ifelse( data_export$Country == "Yes", "United States", NA)
data_export$ISO <- ifelse( data_export$Country == "United States", "USA", NA)
data_export$admin_scale = forcats::fct_recode( data_export$admin_scale, 
	"City" = "City // Ciudad",
	"County" = "County // Condado" ,
	"State" = "State // Estado",
	"State" = "Territory" # sorry!
	#Nation/ Country
	)
data_export$passed <- as.character(forcats::fct_recode( data_export$passed, 
	"FALSE" = "Active campaign",
	"FALSE" = "Relief Fund",
	"TRUE" =  "Existing tenant protection"
	))
data_export$passed <- as.logical(data_export$passed)
data_export$end_date_earliest <- as.character(data_export$end_date_earliest)
data_export$end_date_legist <- as.character(data_export$end_date_legist)
data_export$end_date_rent_relief <- as.character(data_export$end_date_rent_relief)
data_export$end_date_court <- as.character(data_export$end_date_court)

# data_export <- data_export[-nrow(data_export),] 

#   ____________________________________________________________________________
#   Florida County Data Using Community Justice Project  and Reconcile      ####

# source("./code_sourcing/code_florida.r", echo = TRUE) ## sourcing doesn't work?
data_fl1 <- air_select(sub_base, table_name = "Eviction Moratorium") %>% janitor::clean_names()
Sys.sleep(2)
data_fl2 <- air_select(sub_base, table_name = "AEMP Eviction") %>% janitor::clean_names()
Sys.sleep(2)

data_fl <- (data_fl1 %>% select(county, -id, -circuit, -number_of_renter_households, 
																-number_of_low_income_60_percent_ami_cost_burdened_renter_households, -slug, everything())) %>% 
	inner_join(data_fl2, c("county" = "county")) %>% select(- linked_file , -aemp_eviction, -id.x)

data_fl$geo <- ( paste(data_fl$county,  "County, Florida", sep = " " ))

# change to latest version when updating
data_fl_gc <- readr::read_csv("./geocode_log/fl_geocodes_2020-06-10.csv") 

data_fl <- data_fl %>% left_join( data_fl_gc, by = "geo")

data_fl_gc    <- data_fl %>% filter( !is.na(lat) )
data_fl_to_gc <- data_fl %>% filter( is.na(lat) )

if( nrow(data_fl_to_gc) != 0){
	data_fl_to_gc <- data_fl_to_gc %>%  tidygeocoder::geocode(geo, method='cascade') 
	data_fl2 <- bind_rows( data_fl_gc, data_fl_to_gc )
} else{
	data_fl2 <- bind_rows(data_fl_gc )	
}


data_fl2 <- data_fl2 %>% mutate(
	pt_1_1_evict_init = case_when( landlords_send_notice == "✖" ~ 8, TRUE ~ 0),
	pt_1_2_evict_init = case_when( TRUE ~ 2), #until June 2
	
	pt_2_1_protect =    case_when ( (bottom_line == "Evictions Suspended" | bottom_line == "Evictions Active, but Tenant Removal Paused") &
																		limited_to_non_payment == "✖" ~ 2, TRUE ~ 0),
	
	pt_2_2_protect =    case_when (  TRUE ~ 0),
	pt_2_3_protect =    case_when (  	limited_to_non_payment == "✖" ~ 2), #until June 2 or bottom line = evictions suspended or evictions active, but tenant removal paused
	pt_2_4_protect =    case_when (  TRUE ~ 0),
	pt_2_5_protect =    case_when ( (bottom_line == "Evictions Suspended" | 
																	 	bottom_line == "Evictions Active, but Tenant Removal Paused") &
																		limited_to_non_payment == "✖" & 
																		cause_evictions_allowed == "✓" ~ 5, TRUE ~ 0),
	
	pt_3_1_pending =    case_when ( landlord_files_for_default_judgment == "✖" | judge_rules_no_hearing_required == "✖"| 
																		clerk_issues_writ_of_possession == "✖" | sheriff_enforces_writ_of_possession == "✖" ~ 1, TRUE ~ 0 ),
	pt_3_2_pending =    case_when ( clerk_issues_writ_of_possession == "✖" | sheriff_enforces_writ_of_possession == "✖"  ~ -1, TRUE ~ 0 ),
	
	pt_4_6_tenant_do = case_when( TRUE ~ 2 ),
	pt_6_howlong = case_when( TRUE ~ -5 ), # 3 days - time b/w moratorium ending and notice period required by regular process
	
	pt_10_01_court = case_when( remote_hearings_allowed == "✓"  ~ -2, 	TRUE ~ 0),
	pt_10_02_court = case_when( bottom_line == "Evictions Suspended" ~ 3 ,	TRUE ~ 0),
	
	pt_10_03_court = case_when( emergency_exemption == "✓" ~ -.5, TRUE ~ 0	),  ## 
	pt_10_08_court = case_when( discretion_of_judge_exemption == "✓" ~ -.5, TRUE ~ 0),  ## 
	pt_10_09_court = case_when( landlord_files_for_eviction_in_court == "✖"  ~ 3,  TRUE ~ -3),
	pt_10_10_court = case_when( only_limits_writs == "✓"  ~ 3, TRUE ~ -3),
	pt_10_11_court = case_when( tenant_must_respond_and_pay_past_due_rent_to_court == "✖" ~  3, TRUE ~ -3),
	pt_10_12_court = case_when( clerk_issues_writ_of_possession == "✖" ~  3, TRUE ~ -3),
	pt_10_13_court = case_when( sheriff_enforces_writ_of_possession ==	 "✖"  ~  3, TRUE ~ -3),
	pt_10_14_court = case_when( cares_ao == "(✓)" | cares_ao == "✓" ~ 3, TRUE ~ 0))

# pt_11_1_obligations 

fl_data_points <- data_fl2 %>%  select(starts_with("pt"))
fl_data_points1 <- fl_data_points %>%  select(starts_with("pt")) %>% mutate(pts_total = rowSums(., na.rm =  TRUE))
fl_data_points2 <- fl_data_points %>%  select(starts_with("pt_1_")) %>% mutate(pts_eviction_initiation_tot_10 = rowSums(., na.rm =  TRUE))
fl_data_points3 <- fl_data_points %>%  select(starts_with("pt_2_")) %>% mutate(pts_eviction_protect_tot_04 = rowSums(., na.rm =  TRUE))
fl_data_points4 <- fl_data_points %>%  select(starts_with("pt_3_")) %>% mutate(pts_eviction_pending_tot_03 = rowSums(., na.rm =  TRUE))
fl_data_points5 <- fl_data_points %>%  select(starts_with("pt_4_")) %>% mutate(pts_tenant_action_tot_00 = rowSums(., na.rm =  TRUE))
# fl_data_points6 <- fl_data_points %>%  select(starts_with("pt_5_")) %>% mutate(pts_partial_rent_tot_01 = rowSums(., na.rm =  TRUE))
fl_data_points7 <- fl_data_points %>%  select(starts_with("pt_6_")) %>% mutate(pts_repayment_period_tot_05 = rowSums(., na.rm =  TRUE))
# fl_data_points8 <- fl_data_points %>%  select(starts_with("pt_7_")) %>% mutate(pts_latefees_tot_03 = rowSums(., na.rm =  TRUE))
# fl_data_points9 <- fl_data_points %>%  select(starts_with("pt_8_")) %>% mutate(pts_repayment_plan_tot_00 = rowSums(., na.rm =  TRUE))
fl_data_points10 <-fl_data_points %>%  select(starts_with("pt_10_")) %>% mutate(pts_courts_tot_15 = rowSums(., na.rm =  TRUE))
# fl_data_points11 <-fl_data_points %>%  select(starts_with("pt_10_")) %>% mutate(pts_renter_protection_tot_06 = rowSums(., na.rm =  TRUE))


# fl_data_points$rank <- cut(fl_data_points$pts_total, breaks = 3, labels = c(1,2,3),  names = TRUE)

data_fl_out <- bind_cols(data_fl2, fl_data_points1 %>% 
												 	select( pts_total), fl_data_points2, fl_data_points3, fl_data_points4, 
												 fl_data_points5, fl_data_points7, fl_data_points10)

readr::write_csv(as.data.frame(data_fl2 %>% select(-ao_file)), paste("./data_log/data_fl_in",lubridate::today(),".csv"))
readr::write_csv(as.data.frame(data_fl_out %>% select(-ao_file)), paste("./data_log/data_fl_out",lubridate::today(),".csv"))


#   ____________________________________________________________________________
#   Data Reconciliation                                                    ####

data_fl_out$policy_type = "Court or Law Enforcement_policy"
data_fl_out$state = "FLORIDA"															 
data_fl_out$admin_scale <-  "County"
data_fl_out$passed <- as.logical("TRUE")
data_fl_out$policy_type <- "Eviction Protection"
data_fl_out$resource <- "www.communityjusticeproject.com"
data_fl_out$Country = "United States"
data_fl_out$ISO = "USA"
data_fl_out$end_date_earliest <- data_fl_out$end_date
data_fl_out$end_date_court <- as.character( data_fl_out$end_date )

data_fl_out <- data_fl_out %>% left_join(data_nyu_state, by = c( "state" = "state_field" ) )
# data_fl_out$policy_summary
data_fl_out$state = "Florida"		
data_fl_out$note_out = ifelse( is.na(data_fl_out$note), 
															 data_fl_out$bottom_line, 
															 paste(data_fl_out$bottom_line, data_fl_out$note, sep = "\r\n") )		

# #hard code monroe county because centroid is in ocean.
# data_fl_out <- data_fl_out %>% mutate(lat = case_when(county == "Monroe" ~ 25.582937, TRUE ~ lat),
# 																			long = case_when(county == "Monroe" ~ -80.970822, TRUE ~ long) 					)

# run this every once in a while
# readr::write_csv( (data_fl_out %>% select(geo, lat, long)), paste0("./geocode_log/fl_geocodes_",lubridate::today(),'.csv'))


data_fl_out1 <- data_fl_out %>% select(municipality = county, state, 
																			 Country, ISO,
																			 admin_scale, point_total = pts_total,
																			 lat, lng = long, passed, end_date_earliest, end_date_court,
																			 policy_summary = note_out,
																			 policy_type, link = link_to_sources, resource,
																			 state_level_legal_status = current_status, state_level_legal_summary = state_summary, 
																			 point_total = pts_total, starts_with("pts_"))

data_export1 <- bind_rows(data_export, data_fl_out1)

data_export1$range <-  as.numeric(as.character(cut(data_export1$point_total, breaks = 3, labels = c(1,2,3),  names = TRUE)))


##  ............................................................................
##  International Data Input and Processing                                 ####
# download international data from first entry sheet, rename and merge


data_int <- read_sheet("https://docs.google.com/spreadsheets/d/1rvVllKDvzHtzSEphhrgFVMZRCbFCewfOfq3ccwPRa1c/edit#gid=608427658")
data_int <- janitor::clean_names(data_int)
data_int_s <- data_int %>% select(municipality, state, Country = country_5, ISO = iso, 
	admin_scale = administrative_scale, range,
	lng = longitude, lat = latitude, passed = has_the_legislation_been_passed, resource = resources,
	policy_summary = policy_description, link = link, resource = resources, policy_type = type_of_policy,
	-start_date, end_date_earliest = end_date, -other_feedback_17, -other_feedback_20, -timestamp, -email_address, 
	-country_19)
data_int_s$end_date_earliest <- as.factor(sapply(data_int_s$end_date_earliest,function(x) ifelse(is.null(x),NA,x)))

# data_int_s$end_date_earliest[11] <- NA
# data_int_s$end_date_earliest[79] <- NA
data_int_s$end_date_earliest <- as.numeric(as.character(data_int_s$end_date_earliest))

data_int_s$end_date_earliest <- as.character(lubridate::as_date(anytime::anytime( data_int_s$end_date_earliest )))

# gsubfn::gsubfn(data_int_s$municipality, list("á"="a", "é"="e", "ó"="o"), c("á","é","ó"))
data_int_s <- data_int_s %>% mutate(
	municipality = gsub("Ã©", "é", municipality), #QuÃ©bec , Québec
	municipality = gsub("Ã¨", "è", municipality),
	municipality = gsub("Ã£", "ã", municipality),
	municipality = gsub("Ã±", "ñ", municipality),
	
	state = gsub("Ã£", "ã", state),
	state = gsub("Ã©", "é", state),

	policy_summary = gsub("Ã¡", "á", policy_summary),
	policy_summary = gsub("Ã£", "ã", policy_summary), #"MaranhÃ£o", "Maranhão
	policy_summary = gsub("Ã©", "é", policy_summary), 
	policy_summary = gsub("Ã§", "ç", policy_summary),
	policy_summary = gsub("Ãµ", "õ", policy_summary),
	policy_summary = gsub("Ã¸", "ø", policy_summary), #"BaunehÃ¸jhallen", "Baunehøjhallen",)
	policy_summary = gsub("nÂ°11", "n°11",policy_summary))

data_int_filter <- data_int_s %>% filter(ISO != "USA" | (ISO == "USA" & admin_scale == "Country"))
data_int_filter$passed <- as.logical(data_int_filter$passed)

data_int_filter$resource <- NULL ## currently empty so doesn't let a bind happen


## geocode 
data_int_rest <- data_int_filter %>% filter(admin_scale != "City")
data_int_city <- data_int_filter %>% filter(admin_scale == "City", !is.na(lat) )
data_int_city_to_gc <- data_int_filter %>% filter(admin_scale == "City", is.na(lat) )

if( nrow(data_int_city_to_gc) != 0){
	data_int_city_to_gc$geo <- paste(data_int_city_to_gc$municipality, data_int_city_to_gc$Country)
	data_int_city_to_gc <- data_int_city_to_gc %>%  
		tidygeocoder::geocode(geo, method='cascade') %>% select(lng = long, -geo, everything() )
	data_int_gc <- bind_rows(data_int_city_to_gc, data_int_city, data_int_rest)
	} else{
		data_int_gc <- bind_rows(data_int_city, data_int_rest)	
	}

data_export_dom_int <- bind_rows( data_export1, data_int_gc )

data_export_dom_int$has_expired_protections <- case_when( lubridate::today() >= lubridate::as_date(data_export_dom_int$end_date_earliest) ~ "TRUE",
																												 lubridate::today() < lubridate::as_date(data_export_dom_int$end_date_earliest)~ "FALSE",
																													is.na(data_export_dom_int$end_date_earliest)~ "FALSE",
																													TRUE ~ "FALSE")

data_export_dom_int$end_date_earliest    <- ( lubridate::with_tz( data_export_dom_int$end_date_earliest, tzone = 'UTC'))
data_export_dom_int$end_date_legist      <- ( lubridate::with_tz( data_export_dom_int$end_date_legist, tzone = 'UTC'))
data_export_dom_int$end_date_rent_relief <- ( lubridate::with_tz( data_export_dom_int$end_date_rent_relief, tzone = 'UTC'))
data_export_dom_int$end_date_court       <- ( lubridate::with_tz( data_export_dom_int$end_date_court, tzone = 'UTC'))

data_export_dom_int <- data_export_dom_int %>% 
	mutate_all(as.character) %>% replace(., is.na(.), "")


#### repeat dual city / county jurisdictions ####
data_export_dom_int <- bind_rows(data_export_dom_int, 
	(data_export_dom_int %>% filter(municipality == "San Francisco") %>%
	mutate(admin_scale = "County")))


#### write out 
readr::write_excel_csv(data_export_dom_int, paste0("./data_out/data_scored",lubridate::today(),".csv"))
readr::write_excel_csv(data_export_dom_int, paste0( dropbox_env, "covid-map\\emergency_tenant_protections_scored.csv"))


## rent strike data

data_strike <- read_sheet("https://docs.google.com/spreadsheets/d/1rCZfNXO3gbl5H3cKhGXKIv3samJ1KC4nLhCwwZqrHvU/edit#gid=0")
data_strike <- janitor::clean_names(data_strike)

data_strike <- data_strike %>% 
	mutate_all(as.character) %>% replace(., is.na(.), "")

readr::write_excel_csv(data_strike, paste0( dropbox_env, "covid-map\\emergency_housing_actions.csv"))
