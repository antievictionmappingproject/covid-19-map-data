#### extra code ####


#### ####
# lev_of(data_nyu_state$current_status) #
# 
# lev_of(data_nyu_state$status_of_non_emergency_court_proceedings)
# 
# lev_of(data_nyu_state$prohibits_law_enforcement_from_executing_new_and_past_orders_of_eviction)
# lev_of(data_nyu_state$ status_of_non_emergency_court_proceedings)
# lev_of(data_nyu_state$ remote_hearings_allowed_in_non_emergency_civil_cases)
# lev_of(data_nyu_state$ applies_to_eviction_cases_directly)
# lev_of(data_nyu_state$ applies_to_civil_cases_which_should_include_eviction_cases)
# lev_of(data_nyu_state$ only_applies_to_certain_eviction_cases)
# lev_of(data_nyu_state$ if_limited_to_certain_eviction_cases_the_freeze_only_applies_to_these_cases_stage_in_the_process)
# lev_of(data_nyu_state$tolls_extends_or_stays_court_deadlines ) #local disc
# lev_of(data_nyu_state$date_to_which_deadlines_are_tolled )
# lev_of(data_nyu_state$suspends_all_five_stages_of_eviction_notice_filing_hearing_ruling_execution )
# lev_of(data_nyu_state$ x1_suspends_notice_of_eviction_to_tenant)
# lev_of(data_nyu_state$ x2_suspends_filing_of_eviction_claim)
# lev_of(data_nyu_state$ x3_suspends_hearings_on_eviction)
# lev_of(data_nyu_state$ x4_stays_order_judgment_or_writ_of_eviction)
# lev_of(data_nyu_state$ x5_suspends_enforcement_of_new_order_of_eviction)
# lev_of(data_nyu_state$ prohibits_issuance_of_late_fees_to_landlord)
# # lev_of(data_nyu_state$ brief_summary_of_what_order_does	)
# vtable::vtable(data_nyu_state)
# write_csv(data_nyu_state, "states_nyu.csv")
# names(data_nyu_state) %>% clipr::write_clip()


# ssid <- as_sheets_id("https://docs.google.com/spreadsheets/d/1PCPWLyyreBHMqRmqM5RiUb0xB6Ja_ADf85t5r79Bp3E/edit#gid=29259935")
# unclass(ssid)
# data_ex <- data
	

# data$is_this_an_active_organizing_campaign_or_a_tenant_protection_that_has_been_enacted <- as.factor(data$is_this_an_active_organizing_campaign_or_a_tenant_protection_that_has_been_enacted)
# data$what_scale_does_it_apply_to_alcance_o_nivel_administrativo <- as.factor(data$what_scale_does_it_apply_to_alcance_o_nivel_administrativo)
# 
# data$how_are_tenants_protected_against_eviction <- as.factor( data$ how_are_tenants_protected_against_eviction)
# data$what_types_of_evictions_are_protected <- as.factor( data$ what_types_of_evictions_are_protected)
# data$do_tenants_have_to_notify_their_landlords_that_they_will_be_invoking_a_protection_e_g_not_paying_rent <- as.factor( data$ do_tenants_have_to_notify_their_landlords_that_they_will_be_invoking_a_protection_e_g_not_paying_rent)
# data$how_much_time_do_tenants_have_to_notify_their_landlords <- as.factor( data$ how_much_time_do_tenants_have_to_notify_their_landlords)
# data$does_the_notification_have_to_be_in_writing <- as.factor( data$ does_the_notification_have_to_be_in_writing)
# data$do_tenants_have_to_provide_documentation_of_their_need_for_the_protection_e_g_that_they_cant_afford_to_pay_rent <- as.factor( data$ do_tenants_have_to_provide_documentation_of_their_need_for_the_protection_e_g_that_they_cant_afford_to_pay_rent)
# data$what_does_the_law_say_about_paying_part_of_the_rent <- as.factor( data$ what_does_the_law_say_about_paying_part_of_the_rent)
# 
# data$can_landlords_charge_late_fees_or_interest_on_missed_rent_payments <- as.factor( data$ can_landlords_charge_late_fees_or_interest_on_missed_rent_payments)
# data$what_does_the_policy_say_about_repayment_plans <- as.factor( data$ what_does_the_policy_say_about_repayment_plans)
# data$can_landlords_evict_tenants_if_they_havena_t_completely_paid_the_missed_rent_by_the_end_of_the_repayment_period <- as.factor( data$ can_landlords_evict_tenants_if_they_havena_t_completely_paid_the_missed_rent_by_the_end_of_the_repayment_period)
# data$is_there_a_ban_on_rent_increases <- as.factor( data$ is_there_a_ban_on_rent_increases)
# data$is_there_a_ban_on_fees_for_late_rent <- as.factor( data$ is_there_a_ban_on_fees_for_late_rent)
# data$can_tenants_pay_some_or_all_of_their_rent_out_of_their_security_deposit <- as.factor( data$ can_tenants_pay_some_or_all_of_their_rent_out_of_their_security_deposit)
# data$are_courts_holding_eviction_proceedings <- as.factor( data$ are_courts_holding_eviction_proceedings)
# data$will_courts_issue_writs_of_possession_i_e_order_the_tenant_to_leave <- as.factor( data$ will_courts_issue_writs_of_possession_i_e_order_the_tenant_to_leave)
# data$will_law_enforcement_act_on_writs_of_possession_i_e_forcibly_remove_tenants_from_their_homes <- as.factor( data$ will_law_enforcement_act_on_writs_of_possession_i_e_forcibly_remove_tenants_from_their_homes)

## show levels multiple answers 
# lev_of(data$how_are_tenants_protected_against_eviction)
# lev_of(data$what_types_of_evictions_are_protected)


# hard code mariana island TK edit in original sheet ZZZ remove
# data_tab <- data_tab %>% 
# 	mutate(where_does_this_protection_or_campaign_apply = ifelse(stringr::str_detect(what_u_s_state_or_territory_is_it_in, "Northern Mariana Islands"), "Northern Mariana Islands", where_does_this_protection_or_campaign_apply))
# 
# #again mariana island
# 
# data_tab <- data_tab %>% 
# 	mutate(geo = ifelse(stringr::str_detect(what_u_s_state_or_territory_is_it_in, "Northern Mariana Islands"), "NORTHERN MARIANA ISLANDS", geo))


# data_viz <- data_tab %>% select(geo)


## uses geocodio, which fails on counties ####
## needs a geocod.io api key
# geocode <- gio_batch_geocode(data_tab$geo)

#### us census bureau ####
# 
# latitude = list()
# longitude = list()
# 
# # extract geocode
# for (n in 1:NROW(geocode)) {  
# 	latitude[n] = geocode[n,]$response_results[[1]]$location.lat[1]
# 	longitude[n] = geocode[n,]$response_results[[1]]$location.lng[1]
# }
# 
# latitude1 = (sapply(latitude, function(x) ifelse(is.null(x),NA,x)))
# longitude1 = (sapply(longitude, function(x) ifelse(is.null(x),NA,x)))
# 
# data_tab$lat <- latitude1
# data_tab$long <- longitude1



# names(data_export) %>% clipr::write_clip()


## name comparison
# df_og <- readr::read_csv("C:\\Users\\azada\\Dropbox (Anti-Eviction Mapping Project)\\AMP\\covid-map\\emergency_tenant_protections_current_do_not_edit_me - Sheet1.csv")
# writeClipboard(names(df_og))
# 
# c("municipality",
#   "state",
#   "Country",
#   "ISO",
#   "admin_scale",
#   "lat",
#   "lon",
#   "passed",
#   "range",
#   "policy_type",
#   "policy_summary",
#   "start",
#   "end",
#   "link")
# 
# 
# 
# 
# 
# 
# 
# 
# read_sheet(ssid)
# library(ggplot2)
# (gap_dribble <- drive_get('NEW Emergency Tenant Protections Map Submission (Responses)'))
# 
# # 		
# 
# 
# pt_1_evict_init = case_when(
# 		tenant_protection_moratorium == 1 & tenant_protection_defense == 1 ~ 10,
# 		tenant_protection_moratorium == 1 ~ 8,
# 		tenant_protection_defense == 1 ~ 2,
# 		TRUE ~ 0	),
# 	pt_2_evict_protect = case_when(
# 		
# 		eviction_protection_no_fault == 1 
# 		eviction_protection_nonpayment_covid == 1
# 		eviction_protection_covid_other_evictions == 1
# 		eviction_protection_all_evictions == 1
# 		
# 		

)

)




# 
# 
# 
# # write out and back in to try to clear up encoding issues ugh
# 
# data$lat[data$lat == "NULL"] <- NA
# data$lon[data$lon == "NULL"] <- NA
# 
# data$start[data$start == "NULL"] <- NA
# data$end[data$end == "NULL"] <- NA
# 
# # hack to avoid doing character detection - unix dateformat is 10 characters, so avoiding all 10 character values
# # and pulling them back in at end for start and end
# data$start1 <- data$start
# for (n in 1:length(data$start1)){
# 	if(nchar(n) != 10) {n <- NA}
# }
# 
# data$end1 <- data$end
# for (n in 1:length(data$end1)){
# 	if(nchar(n) != 10) {n <- NA}
# }
# 
# data$start1 <- as.character((as.POSIXct(as.numeric(as.character(data$start1)),origin="1970-01-01",tz="GMT")))
# data$end1 <- as.character(as.POSIXct(as.numeric(as.character(data$end1)),origin="1970-01-01",tz="GMT"))
# 
# data$start2 <- data$start1
# data$end2 <- data$end1
# 
# data$start2[is.na(data$start2)] <- data$start[is.na(data$start2)]
# data$end2[is.na(data$end1)] <- data$end[is.na(data$end2)]
# 
# data$start <- NULL
# data$start1 <- NULL
# data$end <- NULL
# data$end1 <- NULL


# data$start3 <- unlist(data$start2)
# data$end3 <- unlist(data$end2)
# 
# data$start2 <- NULL
# data$end2 <- NULL
# 
# data <- dplyr::rename(data, start = start3) 
# data <- dplyr::rename(data, end = end3) 
# write.csv(data, "emergency_tenant_protections_carto.csv", row.names = F)
