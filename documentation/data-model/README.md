# AEMP COVID-19 Map: Data Model

This document decribes the data model for the COVID-19 map application.
Check out the directory `data-model` to access the visual representation.
[Work-in-progress: this is going to change soon](aemp-datasources-v1.png).

## Data Sources

1. Rent strike (AEMP) 

2. Domestic policy data (AEMP)
	
	2.1. Florida counties' data (source: Community Justice Project)
	
	2.2. State-level legal data (source: Emily Benfer)
	
3. International policy data (AEMP)

4. Eviction data (coming up)

5. Brazilian data (at KO Carto):
	
	5.1. Housing justice action data
	5.2. Legislation data
		
## Carto data sources

- Policy Data
- Housing Justice Action (rent strike) Data
- Evictions (UPCOMING!)

## Data Dictionary

- RENT STRIKE table:
    includes information about housing justice action
    - Type: string, housing action type
    - Strike_Status: string, active / not active
    - Date: timestamp, data of start of an action
    - Location: string, location of the action
    - Latitude: signed float, coordinate
    - Longitude: signed float, coordinate
    - Why: text, motivation / reasons for action
    - Resources: text, URL with legal resources or groups working on the group

---

- GLOBAL LEGISLATION table:
   includes information about protection legislation at a global level
   - Timestamp: unix epoch, entry date
   - Email: str, email of contributor
   - Address: str, 
   - Municipality: str, policy location
   - State: str, policy location
   - Country: str, policy location
   - ISO: char(3), ISO code for country
   - Administrative Scale: char, city/county/state/federal policy level
   - Latitude: float, coordinate
   - Longitude: float, coordinate
   - Range: int, policy strength score
   - Eviction_Status: str, have evictions been resumed?
   - Policy Description: text, policy description
   - Start Date: str, date of promulgation of a policy
   - End Date: str, end date of promulgation of a policy
   - Link: str, link w/ further info on a policy
   - Other: text, addtional comments about the policy
   - Feedback: text, feedback from the data contributors
   - Resource: str, URL with details about the supporting org. 
   - Country: str, country for the specific policy
   - Other Feedback: text, additional feedback on the policy

---

- Domestic Data:
    Contains data on US protection legislation
     - AEMP gdoc (... indicates additional characters in title)
     - after_the_temporary_protection_ends_how_long_will_tenants_have_to_pay_... - character
     - how_are_tenants_protected_against_eviction - string
     - how_much_time_do_tenants_have_to_notify_their_landlords - string
     - what_types_of_evictions_are_protected - string
     - what_u_s_state_or_territory_is_it_in - string
     - where_does_this_protection_or_campaign_apply - string
     - does_the_notification_have_to_be_in_writing - string
     - do_tenants_have_to_provide_documentation_... - string
     - when_do_tenants_have_to_provide_documentation - string
     - what_does_the_law_say_about_paying_part_of_the_rent - string
     - can_landlords_charge_late_fees_or_interest_on_missed_rent_payments - string
     - what_does_the_policy_say_about_repayment_plans - string
     - are_courts_holding_eviction_proceedings - string
     - will_courts_issue_writs_of_possession_i_e_order_the_tenant_to_leave - string
     - will_law_enforcement_act_on_writs_of_possession_... - string
     - is_there_a_ban_on_rent_increases - string
     - can_tenants_pay_some_or_all_of_their_rent_out_of_their_security_deposit - string
     - do_you_want_to_tell_us_about_eviction_protections - string
     - do_you_want_to_tell_us_about_an_rental_relief_protection - string
     - do_you_want_to_tell_us_about_a_court_law_enforcement_policy_change - string
     - is_it_in_the_united_states_or_a_u_s_territory - string
     - is_this_an_active_organizing_campaign_or_a_tenant_protection_that_has_been_enacted - string
     - tenant_protection_policy_summary - string
     - link_to_source - string
     - tenant_resources - string
     - court_l_e_policy_end_date_explanation - string
     - can_landlords_evict_tenants_if_they_haven_t_completely_paid_the_missed_rent - string
     - end_date_31 -  POSIXct - (moratorium)
     - end_date_36 -  POSIXct - (rental protection)
     - end_date_43 -  POSIXct - (law enforcement / court)
     - timestamp - POSIXct
     - reviewed_date - POSIXct
     - name_nombre_xing_ming - string
     - organization_organizacion_ji_gou - string
     - email_address_correo_electronico_dian_zi_you_jian_de_zhi - string
     - current_evictions_desalojos_actuales_dang_qian_qu_zhu - string
     - would_you_like_to_help_us_fill_in_more_details_about_this_protection_... - string
     - what_scale_does_it_apply_to_... - string
     - what_specific_country_does_this_policy_apply_to_... - boolean - TRUE FALSE
     - what_sub_national_jurisdiction_does_this_apply_to_... - boolean - TRUE FALSE
     - what_scale_is_this_jurisdiction_... - boolean - TRUE FALSE
     - do_tenants_have_to_notify_their_landlords_... - string
     - start_date_fecha_de_inicio_kai_shi_ri_qi_32  - POSIXct - (moratoria)
     - admin_protection_expiration - string
     - start_date_fecha_de_inicio_kai_shi_ri_qi_36 - POSIXct -  (rental protection)
     - admin_rental_relief_expiration - string
     - is_there_a_ban_on_fees_for_late_rent_... - string
     - start_date_fecha_de_inicio_kai_shi_ri_qi_43 - POSIXct - (law enforcement)
     - admin_court_date_expiration - list
     - please_write_a_short_description_here_... - string
     - protections_end_date_explanation_... - string
     - rental_relief_end_date_explanation_... - string
     - is_this_an_update_and_or_correction_... - string
     - which_location_state_county_or_city_needs_to_be_updated_... - boolean - TRUE FALSE
     - what_needs_to_be_changed_updated_or_fixed_... - boolean - TRUE FALSE
     - is_it_a_policy_or_a_campaign_... - boolean - TRUE FALSE
     - x57 - boolean - TRUE FALSE
     - earliest_date_expiration - POSIXct
     - count_of_expiration - numeric - Num: 0 to 1
     - order_value - numeric - Num: 1 to 343
     - how_long - list
     - how_long1 - factor

---
      
- State Level 
  -  x2 - integer
  -  state - string
  -  current_status - factor
  -  state_summary - string
  -  source_of_action - string
  -  name_of_source - string
  -  type_of_action - string
  -  order_declaration_affects_residential_eviction_civil_proceedings - string
  -  hyperlink_to_source_not_included_in_state_summary_row - string
  -  date_of_issue - string
  -  effective_date - string
  -  expiration_date - string
  -  date_moratorium_began_to_lift - string
  -  expired_replaced - string
  -  prohibits_law_enforcement_from_executing_new_and_past_orders_of_eviction - string
  -  status_of_non_emergency_civil_court_proceedings - string
  -  remote_hearings_allowed_in_non_emergency_civil_cases - string
  -  applies_to_civil_cases_which_should_include_eviction_cases - string
  -  applies_to_eviction_cases_directly - string
  -  applies_to_commercial_eviction_directly - string
  -  applies_to_foreclosure_or_foreclosure_eviction_cases_directly - string
  -  exempts_criminal_activity_damage_to_property_emergency_nuisance_or_cases_to_protect_public_health_from_eviction_freeze - string
  -  only_applies_to_certain_eviction_cases - string
  -  if_limited_to_certain_eviction_cases_the_freeze_only_applies_to_these_cases_stage_in_the_process - string
  -  tolls_extends_or_stays_court_deadlines - string
  -  date_to_which_deadlines_are_tolled - string
  -  suspends_all_five_stages_of_eviction_notice_filing_hearing_ruling_execution - string
  -  x1_suspends_notice_of_eviction_to_tenant - string
  -  x2_suspends_filing_of_eviction_claim - string
  -  x3_suspends_hearings_on_eviction - string
  -  x4_stays_order_judgment_or_writ_of_eviction - string
  -  x5_suspends_enforcement_of_new_order_of_eviction - string
  -  prohibits_issuance_of_late_fees_to_landlord - string
  -  requires_certification_that_property_is_not_covered_under_cares_act_moratorium - string
  -  order_declaration_discusses_effect_of_housing_on_public_health - string
  -  order_declaration_discusses_economic_consequences_on_housing - string
  -  model_order - string
  -  brief_summary_of_what_order_does - string
  -  moratorium_extended_past_emergency_declaration - string
  -  free_utility_reconnection - string
  -  no_utility_disconnection - string
  -  no_reporting_to_credit_bureau - string
  -  grace_period_to_pay_rent - string
  -  length_of_time_for_grace_period - string
  -  no_late_fees - string
  -  length_of_time_for_no_late_fees - string
  -  legal_counsel_for_tenants - string
  -  no_rent_raises - string
  -  length_of_time_for_no_rent_raises - string
  -  foreclosure_moratorium - string
  -  length_of_time_for_foreclosure_moratorium - string
  -  housing_stabilization - string
  -  length_of_time_for_housing_stabilization_mm_dd_yyyy - string

---
 	
* Florida Counties Table 1 
   - id - int 
   - county - character
   - number_of_renter_households - integer - Num: 604 to 451763
   - number_of_low_income_60_percent_ami_cost_burdened_renter_households - integer - Num: 125 to 134723
   - circuit - character
   - rent_past_due - character
   - landlord_files_for_eviction_in_court - character
   - landlords_send_notice - character
   - clerk_issues_summons - character
   - tenant_is_served_eviction_papers - character
   - is_the_clerk_accepting_rent_posting_in_person - character
   - tenant_must_respond_and_pay_past_due_rent_to_court - character
   - sheriff_enforces_writ_of_possession - character
   - link_to_sources - character
   - note - character
   - bottom_line - character
   - clerk_issues_writ_of_possession - character
   - clerk_website - character
   - circuit_court_website - character
   - legal_aid - character
   - slug - character
   - landlord_files_for_default_judgment - character
   - judge_rules_no_hearing_required - character
   - note_to_file - character
   - small_businesses_included - boolean - TRUE FALSE
   - aemp_eviction - list
   - last_changed - character
   - end_date - character
   - created_time - character
 
* Florida Counties Table 2
   - id - int 
   - county - character
   - circuit - character
   - linked_file - list
   - limited_to_non_payment - character
   - cause_evictions_allowed - character
   - remote_hearings_allowed - character
   - emergency_exemption - character
   - discretion_of_judge_exemption - character
   - commercial_included - character
   - only_limits_writs - character
   - ao_link - character
   - ao_file - list
   - eviction_moratorium_copy - list
   - cares_ao - character
   - ao_cares_notes - character
   - created_time - character

---    

## Carto Moratorium Policy Data 

Currently, it combines several Gapps tables + Airtable tables: domestic + international + state-level + Florida counties from Airtable. This is going to change as the data model is simplified and the tables are migrated to one backend service (Airtable).


  - municipality - character
  - state - character
  - Country - character
  - admin_scale - character
  - lat - float
  - lng - float 
  - passed - boolean
  - end_date_earliest - POSIXct
  - end_date_legist - POSIXct
  - end_date_rent_relief - POSIXct
  - end_date_court - POSIXct
  - policy_summary - character
  - policy_type - character
  - link - character
  - resource - character
  - state_level_legal_status - character
  - state_level_legal_summary - character
  - point_total - numeric
  - pts_eviction_initiation_tot_10 - numeric
  - pts_eviction_protect_tot_04 - numeric
  - pts_eviction_pending_tot_03 - numeric
  - pts_tenant_action_tot_00 - numeric
  - pts_partial_rent_tot_01 - numeric
  - pts_repayment_period_tot_05 - numeric
  - pts_latefees_tot_03 - numeric
  - pts_repayment_plan_tot_00 - numeric
  - pts_courts_tot_15 - numeric
  - pts_renter_protection_tot_06 - numeric
  - ISO - character
  - range - numeric
  - end_date - Date(char)
  - has_expired_protections - boolean
  - bool_legist_exist - boolean
  - bool_rent_relief_exist - boolean
  - bool_court_exist - boolean

---
Last update: Aug 25, 2020

Sign-off: Azad and LF
