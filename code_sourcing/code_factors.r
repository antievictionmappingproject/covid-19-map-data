
## no fault
data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$what_types_of_evictions_are_protected), 
																											stringr::fixed("No-fault evictions (evictions that are not based on anything the tenant did)"), 
																											"no_fault")

data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("No-cause evictions"), 
																											"no_fault")

## just cause 
data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("no_fault evictions. (Landlords may still file just-cause evictions, including no-fault evictions. Just-cause eviction protections are extended to condos, duplexes, income-restricted affordable housing, single-family homes, and rooms rented in single-family homes.)") ,
																											"no_fault")

data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("no_fault. (Landlords may still file just-cause evictions, including no-fault evictions. Just-cause eviction protections are extended to condos, duplexes, income-restricted affordable housing, single-family homes, and rooms rented in single-family homes.)"), 
																											"no_fault")

# nonpayment 
data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("Evictions for non-payment of rent related to COVID-19"), 
																											"nonpayment")

data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("Evictions for non-payment of rent"), 
																											"nonpayment")
# all evictions
data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("All evictions"), 
																											"all_evictions")

data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("all_evictions not covered under CARES"), 
																											"all_evictions")

data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("all_evictions, Except when the tenant poses an imminent threat to the health or safety of other occupants of the property, and such threat is stated in the notice as the grounds for the eviction"), 
																											"all_evictions")

data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("Eviction proceedings requiring compliance with the Landlord and Tenant Act of 1951 and the Manufactured Home Community Rights Act"), 
																											"all_evictions")


#other#
data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("Evictions for unauthorized occupants, pets, or nuisance related to COVID-19"), 
																											"covid_other_evictions")

data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("All financial evictions from city-owned housing as coronavirus concerns rise"), 
																											"nonpayment_public_subsidized")

#public properties

data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("all_evictions in city owned property"), 
																											"all_evictions_public_subsidized")

#foreclosures
data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("Foreclosure"), "foreclosures")
data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("Mortgage foreclosures"), "foreclosures")


## health and safety types ## RECHECK FOR NEW FACTORS 
data_fact2$eviction_types <- stringr::str_replace_all(as.character(data_fact2$eviction_types), 
																											stringr::fixed("Except when the tenant poses an imminent threat to the health or safety of other occupants of the property, and such threat is stated in the notice as the grounds for the eviction") ,
																											"except_health_safety")


data_fact_evictions <- mtabulate(strsplit(as.character(data_fact2$eviction_types), "\\s*,\\s*"))
names(data_fact_evictions) <- paste0( "eviction_protection_", make_clean_names(names(data_fact_evictions)))

data_fact_evictions_rejoin <-data_fact_evictions %>% 
	select(
		eviction_protection_all_evictions,
    eviction_protection_covid_other_evictions,
    eviction_protection_foreclosures,
    # eviction_protection_i_dont_know,
    eviction_protection_no_fault,
    eviction_protection_nonpayment,
    # eviction_protection_nonpayment_covid,
		eviction_protection_all_evictions_public_subsidized,
    eviction_protection_nonpayment_public_subsidized)

		