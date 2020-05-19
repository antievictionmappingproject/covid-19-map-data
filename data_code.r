
# devtools::install_github("tidyverse/googlesheets4") run once installs
# install.packages('rlist', 'tidygeocoder', 'tidyverse', 'qdapTools', 'jsonlite', 'rvest')

library(googlesheets4)
library(dplyr)
library(janitor)
library(tidygeocoder)
library(qdapTools)
library(jsonlite)
library(rvest)

lev_of <- function(x) {levels(as.factor(x) )}
'%!in%' <- function(x,y)!('%in%'(x,y))

## put your own dropbox folder and sheet locations in .env
source(".env")

#   ____________________________________________________________________________
#   Read AEMP Data and Wait for Interactive Authentication                  ####

# run read_sheet command once interactively to auth each session 
# and then you can run the rest of the code in one go, 
data <- read_sheet(gsheet_env)

#   ____________________________________________________________________________
#   RUN AGAIN                                                               ####
data <- janitor::clean_names(data)

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
	mutate(state = ifelse(stringr::str_detect(state, "MARYLAND \\(MD SUMMARY"), "MARYLAND (MD) SUMMARY", state))
data_nyu_state$state_field <- stringr::str_sub(data_nyu_state$state, end = -14 )
data_nyu_state$current_status <- as.factor(data_nyu_state$current_status)
readr::write_csv(data_nyu_state, paste("./data_log/data_nyu",lubridate::today(),".csv"))

#   ____________________________________________________________________________
#   Feature Creation - Turn Entries and Variables Into Scorables Features   ####


# variable comes in a list convert to string
data$how_long <- data$after_the_temporary_protection_ends_how_long_will_tenants_have_to_pay_the_rent_they_missed_during_the_emergency
data$how_long1 <- as.factor(sapply(data$how_long,function(x) ifelse(is.null(x),NA,x)))

data$end_date_31 <- as.numeric(sapply(data$end_date_31,function(x) ifelse(is.null(x),NA,x)))
data$end_date_31 <- lubridate::as_datetime(data$end_date_31)

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Q1 Policy Type - How Are Tenants Protected Against Eviction             ####

data_fact <- data %>% select(how_are_tenants_protected_against_eviction )
data_fact$protect <- stringr::str_replace_all(as.character(data_fact$how_are_tenants_protected_against_eviction), 
																							stringr::fixed("Moratorium (landlords are not allowed to serve notices to tenants)") ,"Moratorium")
data_fact$protect <- stringr::str_replace_all(as.character(data_fact$protect), 
																							stringr::fixed("Defense (tenants have a defense in court against eviction actions)") ,"Defense")
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
data_tab$geo <- ifelse( stringr::fixed(as.character(data_tab$state)) == 
	stringr::fixed(trimws(toupper(data_tab$where_does_this_protection_or_campaign_apply))),
	data_tab$state,
	paste(data_tab$where_does_this_protection_or_campaign_apply,  data_tab$state, sep = ", " ))

data_tab <- data_tab %>% mutate(geo = gsub("Ã±", "ñ", geo))
 

data_tab <-  data_tab %>% tidygeocoder::geocode(geo, method='cascade')


##  ............................................................................
##  Rejoin state legal data with geocoded aemp data                         ####

data_tab_nyu <- data_tab %>% left_join(data_nyu_state, by = c( "state" = "state_field" ) )

# sniff test / check check for unmatched states
#data_unmatched_state <- data_nyu_state %>% anti_join(data_tab, by = c( "state_field" = "state" ) )
#data_unmatched_state %>% View


#   ____________________________________________________________________________
#   POINT SCORING                                                           ####

source("./code_sourcing/code_points.r")


### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Creating Ranked Summary                                                 ####


data_points1$rank <- cut(data_points1$pts_total, breaks = 3, labels = c(1,2,3),  names = TRUE)

data_tab_out <- bind_cols(data_tab_nyu, data_points1 %>% 
	select(rank, pts_total), data_points2, data_points3, data_points4, 
	data_points5, data_points6, data_points7, data_points8, data_points9, data_points10, data_points11)


#   ____________________________________________________________________________
#   Data Reconcilliation                                                    ####

data_tab_out$policy_type = case_when(stringr::fixed(data_tab_out$do_you_want_to_tell_us_about_eviction_protections) %in% c("Yes") ~ "Eviction Protection", 
	stringr::fixed(data_tab_out$do_you_want_to_tell_us_about_an_rental_relief_protection) %in% c("Yes") ~ "Renter Relief",
	stringr::fixed(data_tab_out$do_you_want_to_tell_us_about_a_court_law_enforcement_policy_change) %in% c("Yes") ~ "Court or Law Enforcement_policy",
	TRUE ~ NA_character_)

data_export <- data_tab_out %>% select(municipality = geo, state, 
	Country = is_it_in_the_united_states_or_a_u_s_territory, 
	admin_scale = what_scale_does_it_apply_to_alcance_o_nivel_administrativo,
	lat, lng = long, passed = is_this_an_active_organizing_campaign_or_a_tenant_protection_that_has_been_enacted, 
	policy_summary = tenant_protection_policy_summary,
	range = rank, policy_type, link = link_to_source, resource = tenant_resources,
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
data_export$range <- as.numeric(as.character(data_export$range))


##  ............................................................................
##  International Data Input and Processing                                 ####
# download international data from first entry sheet, rename and merge


data_int <- read_sheet("https://docs.google.com/spreadsheets/d/1rvVllKDvzHtzSEphhrgFVMZRCbFCewfOfq3ccwPRa1c/edit#gid=608427658")
data_int <- janitor::clean_names(data_int)
data_int_s <- data_int %>% select(municipality, state, Country = country_5, ISO = iso, 
	admin_scale = administrative_scale, range,
	lng = longitude, lat = latitude, passed = has_the_legislation_been_passed, resource = resources,
	policy_summary = policy_description, link = link, resource = resources, policy_type = type_of_policy,
	-start_date, -end_date, -other_feedback_17, -other_feedback_20, -timestamp, -email_address, 
	-country_19)

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
## TODO recode international policy type


data_export_dom_int <- bind_rows( data_export, data_int_filter )
data_export_dom_int <- data_export_dom_int %>% 
	mutate_all(as.character) %>% replace(., is.na(.), "")

#### repeat dual city / county jurisdictions ####
data_export_dom_int <- bind_rows(data_export_dom_int, 
	(data_export_dom_int %>% filter(municipality == "San Francisco") %>%
	mutate(admin_scale = "County")))


#### write out 
readr::write_excel_csv(data_export_dom_int, paste0("./data_out/data_scored",lubridate::today(),".csv"))
readr::write_excel_csv(data_export_dom_int, paste0( dropbox_env, "covid-map\\emergency_tenant_protections_scored.csv"))
