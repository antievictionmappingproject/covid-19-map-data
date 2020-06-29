

data_tab_nyu %>% mutate_if(is.factor, as.character) -> data_tab1

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_1_1_evict_init = case_when( tenant_protection_moratorium == 1 ~ 8, 
									   is.na(tenant_protection_moratorium) ~ 0, 
									   TRUE ~ 0),
		pt_1_2_evict_init = case_when( tenant_protection_defense == 1 ~ 2, 
									   is.na(tenant_protection_defense) ~0 , 
									   TRUE ~ 0),
		pt_2_1_protect = case_when ( eviction_protection_no_fault 	== 1 ~ 2, 
									 is.na(eviction_protection_no_fault) ~ 0 , 
									 TRUE ~ 0),
		pt_2_2_protect = case_when ( (eviction_protection_covid_other_evictions == 1 |
										current_status %in% c("COVID-19 Hardship Eviction Cases Suspended")) ~ .5, 
									 is.na( eviction_protection_covid_other_evictions ) ~ 0, TRUE ~ 0),
		pt_2_3_protect = case_when ( (eviction_protection_nonpayment == 1 | 
									 current_status %in% c("Nonpayment Eviction Enforcement Suspended",
															"Nonpayment Eviction Cases and Enforcement Suspended",
															"Civil Cases Suspended",
															"Eviction Cases & Enforcement Suspended",
															"Civil Cases & Eviction Enforcement Suspended",
															"Eviction Cases Suspended",
															"Eviction Cases & Nonpayment Eviction Enforcement Suspended"
									 ))~ 2, 
									is.na(eviction_protection_nonpayment ) ~0 , 
									TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_2_4_protect = case_when ( eviction_protection_covid_other_evictions == 1 ~ .5, 
									is.na(eviction_protection_covid_other_evictions) ~0 , 
									TRUE ~ 0),
		pt_2_5_protect = case_when ( (eviction_protection_all_evictions == 1 |
					current_status %in% c("Civil Cases Suspended",
										  "Civil Cases & Eviction Enforcement Suspended",
										  "Eviction Cases Suspended",
										  "Eviction Cases & Nonpayment Eviction Enforcement Suspended"	)) ~ 5, 
					is.na(eviction_protection_all_evictions) ~0 , 
					TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(		
		pt_3_1_pending = case_when( (current_status %in% 
			c( "Civil Cases & Eviction Enforcement Suspended",
					"Civil Cases Suspended",
					"COVID-19 Eviction Enforcement Suspended",
					"COVID-19 Hardship Eviction Cases Suspended",
					"COVID-19 Related Eviction Cases Suspended",
					"Eviction Cases & Enforcement Suspended",
					"Eviction Cases and Nonpayment Eviction Enforcement Suspended",
					"Eviction Cases Suspended",
					"Eviction Enforcement Suspended",
					"Nonpayment Eviction Cases and Enforcement Suspended",
					"Nonpayment Eviction Enforcement Suspended") | 
			order_declaration_affects_residential_eviction_civil_proceedings %in%
			c(	'COVID-19 Related', 'Y')) ~ 1, 
			TRUE ~ 0))

data_tab1 <- data_tab1 %>% 	mutate(		
	pt_3_2_pending = case_when( remote_hearings_allowed_in_non_emergency_civil_cases %in% 
																c('Y' ) ~ 1,
																TRUE ~ 0),
	pt_3_3_pending = case_when( tolls_extends_or_stays_court_deadlines %in% 
																c('Y') ~ 1, 
																TRUE ~ 0))

data_tab1 <- data_tab1 %>% 	mutate(		
	pt_4_1_tenant_do = case_when( does_the_notification_have_to_be_in_writing %in% 
									c("Yes", "Yes // Si", "Yes, but email or text is okay", "Yes, but email or text is okay // Si, por correo electrónico o texto está bien" )	~ as.numeric(-1), 
									TRUE ~ 0 ),
	pt_4_2_tenant_do = case_when( how_much_time_do_tenants_have_to_notify_their_landlords %in% 
					c("At least 7 days before rent is due", 
						"Within 7 days after rent is due"   , "Within 7 days after rent is due // 7 días después del vencimiento de la renta",
						"Within 10 days after rent is due"  ,
						"Within 14 days after rent is due" ,
						"Within 14 days of the date that rent is due", 
						"Within 14 days of receipt of written notice from the landlord of the existence of the City’s ordinance, unless the totality of the circumstances warrant a longer reasonable period of time.",
						"Within 14 days of receipt of written notice from the landlord of the existence of the Cityâ€™s ordinance, unless the totality of the circumstances warrant a longer reasonable period of time." , 
						"14 days after landlord issues a written notice of amount of rent due."  , 
						"Within 30 days after rent is due" , 
						"Before the expiration of a 3-day notice issued by the landlord for nonpayment of rent" , 
						"Before the Notice of Termination (for non-payment of rent) expires" ) ~ 0, 
				
					how_much_time_do_tenants_have_to_notify_their_landlords %in% 
					c("Before the day the rent is due.", "On or before the day rent is due // Antes o el día de vencimiento de la renta",
						"On or before the day rent is due",
						"Within 5 days after rent is due" ) ~ -1,
				TRUE ~ 0 ))

data_tab1 <- data_tab1 %>% 	mutate(		
	pt_4_3_tenant_do = case_when( do_tenants_have_to_provide_documentation_of_their_need_for_the_protection_e_g_that_they_cant_afford_to_pay_rent %in% 
				c("Yes", "Yes // Si",
					"Yes, but a signed self-certification is acceptable if necessary") ~ -3, 
					TRUE ~ 0 ),
	pt_4_4_tenant_do = case_when( when_do_tenants_have_to_provide_documentation %in% 
				c(
					"After notifying the landlord",
					"When they notify their landlord", 
					"When they notify their landlord // Cuando ellos le notifiquen a los propietarios" ,
					"When they repay their missed rent" ,
					"3 days after",
					"Within three business days of receiving a required notice of rent delinquency from the landlord.",
					"With 7 days of notifying landlord",
					"7 days",
					"Within seven days of said notice.",
					"Within one week of notifying their landlord" ,
					"14 days",
					"Within 14 days",
					"Within 14 days after rent is due"  , 
					"within 14 days of receiving a form from landlord about nonpayment of rent",
					"Within 14 days of providing notice, or within such time as possible due to events outside of the tenant’s reasonable control but in no event more than 21 days",
					"Within 15 days after rent is due",
					"within fourteen (14) days of receiving the written notice from the landlord.",
					"30 days",
					"30 days after rent was due",
					"Within 30 days of the rent due date" ,
					"Within 30 days after notifying their landlord", 
					"Within 30 days after the rent is due" , 
					"within fourteen (14) days of receiving the written notice from the landlord." ,
					"Within one week of notifying their landlord",
					"Within three business days of receiving a required notice of rent delinquency from the landlord.",
					"In order to qualify for these protections, tenants must provide documentation or a sworn statement demonstrating financial hardship within 45 days of receiving a request from their landlord or 30 days of the end of the state of emergency, whichever is later.",
					"No later than the time upon payment of back-due rent",
					"Tenants must notify landlords in writing before rent is due, each time rent is due and for rents due between 3/27/20 and 4/1/20 by 4/7/20, and document inability to pay within 2 weeks of each notice.",
					"upon request of landlord respond to landlord with any reasonably available supporting documentation of their need for relief and acknowledge that all contractual terms of the lease remain in effect."
					) ~ -1.5, 
					TRUE ~ 0 ),
	
	pt_4_5_tenant_do = case_when( when_do_tenants_have_to_provide_documentation %in% 
				c (
					"When they repay their missed rent" , 
					"No later than the time upon payment of back-due rent" ) ~ -.5, 
				when_do_tenants_have_to_provide_documentation %in% c("There is no mention of any need to provide documentation for non-payment of rent.")  ~ 0,
				TRUE ~ 0 ),
	
	pt_4_6_tenant_do = case_when( do_tenants_have_to_provide_documentation_of_their_need_for_the_protection_e_g_that_they_cant_afford_to_pay_rent %in% 
					c("Yes, but a signed self-certification is acceptable if necessary" ,  
						"There is no mention of any need to notify landlords of non-payment of rent.", 
						"Not specified",
						"No" ) ~ 2, 
				TRUE ~ 0 ))

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_5_1_part_rent = case_when( what_does_the_law_say_about_paying_part_of_the_rent  %in% 
									c( "Tenants must pay as much of the rent as possible",
										 "Tenants must pay as much of the rent as possible // Los inquilinos deben de pagar lo mas que puedan de su renta"   ) ~ -2, 
									TRUE ~ 0),
		# pt_5_2_part_rent = case_when( %in% , -1  0)
		pt_5_3_part_rent = case_when( what_does_the_law_say_about_paying_part_of_the_rent %in% 
				c("There shall be a rebuttable presumption that the tenant paid that portion of the rent that the tenant was reasonably able to pay if the tenant paid at least 50% of the monthly rent." , 
					"Tenants can choose to make partial payments, and the landlord must accept them"   , 
					"Housing agency will work with the property management company it contracts with on rent forbearance.",
					"tenants are encouraged to pay as much as they can" ) ~  1, 
					TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(	
		pt_6_1_how_long = case_when( how_long1 %in% c( 'Tenants never have to pay back rent' )~ 5, 
									TRUE ~ 0),
		pt_6_2_how_long = case_when( how_long1 %in% c('One year' , '12 months', 'One year') ~ 0, TRUE ~ 0),
		pt_6_3_how_long = case_when( how_long1 %in% c(
			"Tenants have until September 17th, 2020." ,
			'Until December 31, 2020',
			'1606694400',
			'120' ,
			'120 days' ,
			"Tenants who were afforded eviction protection under this Resolution shall have up to 120 days after the expiration of the Governor’s Executive Order N-28-20, including any extensions, to pay their landlord all unpaid rent",
			'Tenants who were afforded eviction protection under this Resolution shall have up to 120 days after the expiration of the Governorâ€™s Executive Order N-28-20, including any extensions, to pay their landlord all unpaid rent' ,
			'Up to 120 days after the expiration of the ordinance.' , 
			'Within 120 days after the emergency order terminates' , 
			#180 days
			'180 days', 
			'Within 180 days after the emergency ordinance expires' ,
			'Within 180 days of termination of the State of Emergency, or within 180 days of the date upon which an extension of the ordinance expires, whichever is later.' , 
			'Within 180 days of the expiration of the emergency ordinance' , 
			"210 days" ,
			"4 months",
			#6 month codes
			"The tenant must pay back rent within six months of the expiration of the local emergency" ,
			'6 months' , 
			'6 months after emergency' ,
			"six months" ,
			"Six months",
			"six months after the state of emergency expires" ,
			'six months after the date this Order expires or is terminated',   
			"Within six months",  
			'Within 6 months after the emergency order expires' , 
			'within 6 months after the end of the emergency' , 
			"Within six (6) months after expiration of local emergency",
			'within six months after the emergency order expires' , 
			'Within six months after the emergency order expires', 
			'Within six months following the expiration of the emergency period') 
			~ -1, TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(			
		pt_6_4_how_long = case_when( how_long1 %in% c('3 months',
			"Within two months after the emergency ordinance expires", 
			'Within 90 days after the emergency ordinance terminates' , 
			'60 days' ,
			"60 days after the state of emergency ends",
			"Within 60 days of expiration of the local ordinance",
			"Tenants have 60 days to pay rent after state of emergency is lifted" ,
			"90 days" ,
			"90 days for each month of rent missed" ,
			'90 days to repay 50% of outstanding rent and 180 days to pay 100% of outstanding rent' ,
			'at least 90 days but no more than 180 days' ,  
			'Within 90 days after the emergency ordinance terminates',
			"Within three (3) months after expiration of ordinance"
		)
		~ -3, TRUE ~ 0))
data_tab1 <- data_tab1 %>% 
	mutate(	
		pt_6_5_how_long = case_when( how_long1 %in% c('Tenants have to pay back rent immediately, unless there is a payment plan'  , 
						'immediately after the emergency ends, unless they create a payment plan',
						"6 months with 6 even installments beginning 30 days after moratorium is lifted.") 
				~ -4, TRUE ~ 0),
		pt_6_6_how_long = case_when( how_long1 %in% c('Not specified', 'When the order ends') 
																 ~ -5, TRUE ~ 0))


data_tab1 <- data_tab1 %>% 
		mutate(
			pt_8_1_fees= case_when(  can_landlords_charge_late_fees_or_interest_on_missed_rent_payments %in% c( "No, they can't charge late fees or interest",
																																																					"No, they can't charge late fees or interest // No, ellos no pueden cobrar cargo por retraso ni interés"	)  ~ 3,  
															 can_landlords_charge_late_fees_or_interest_on_missed_rent_payments %in% c('Yes, they can charge interest') ~ -1,
								can_landlords_charge_late_fees_or_interest_on_missed_rent_payments %in% c('Yes, they can charge late fees') ~ -2,
								can_landlords_charge_late_fees_or_interest_on_missed_rent_payments %in% c('Yes, they can charge late fees and interest' ) ~ -3, 
								TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_9_1_repay = case_when ( what_does_the_policy_say_about_repayment_plans %in% 
					c('\"The City Administrator may issue regulations, guidance, and forms as needed to implement this Ordinance, including but not limited to guidelines for repayment of back rent.\"' ,  
						"Landlords and tenants may agree, in writing, to a repayment period that is longer than 180 days.",    
						"Tenants and landlords are encouraged to agree on a repayment plan",
						"Tenants and landlords are encouraged to agree on a repayment plan // Los inquilinos y los propietarios están motivados a ponerse de acuerdo sobre un plan de pago",
						"Tenants and landlords are encouraged to agree on a repayment plan, but, in the absence of the agreement to such a plan, The policy creates a default or standard repayment plan in which total of all delayed payment shall be repayed in 4 equal payments to be paid in 30 day intervals beginning the day after the ordinance expires.",
						"Tenants and landlords can agree on a repayment plan (weekly, biweekly, or monthly), but must do so either before the emergency order ends or within 90 days of the first missed rent payment.",
						"The policy creates a default or standard repayment plan",
						"A landlord must offer you a reasonable payment plan if you cannot pay the rent. This has to be based on your own circumstances. The same payment plan to the entire building doesn't count." ,
						"Neither the County moratorium or Executive Order 20-13 require a tenant to sign a repayment plan or promissory note in order to be protected from eviction due to non-payment of rent during this time.  Tenants do need to notify their landlord as soon as reasonably possible.",
						"Landlors are \"strongly encouraged\" to tenants after the period of local emergency" 
					) 	~ -.5, TRUE ~ 0),
		
		pt_9_2_repay = case_when (what_does_the_policy_say_about_repayment_plans %in%
						c("Landlords who don't want to renew a lease because the tenant didn't pay rent or late fees during the emergency period must FIRST give the tenant a chance to propose a reasonable repayment plan. A proposed plan is considered \"reasonable\" if: all missed rent would be paid back within 12 months of the agreement;  the tenant will be able to afford to make those payments on schedule; and the tenant would continue to pay their future rent in full.",
							"Tenants and landlords are encouraged to agree on a repayment plan",  
							"Tenants and landlords are encouraged to agree on a repayment plan // Los inquilinos y los propietarios están motivados a ponerse de acuerdo sobre un plan de pago",
							"Landlords and tenants may agree, in writing, to a repayment period that is longer than 180 days."
						) 
					~ -.5, TRUE ~ 0),
		pt_9_3_repay = case_when (what_does_the_policy_say_about_repayment_plans %in%
						c("Tenants and landlords can agree on a repayment plan (weekly, biweekly, or monthly), but must do so either before the emergency order ends or within 90 days of the first missed rent payment.",
							"Landlords who don't want to renew a lease because the tenant didn't pay rent or late fees during the emergency period must FIRST give the tenant a chance to propose a reasonable repayment plan. A proposed plan is considered \"reasonable\" if: all missed rent would be paid back within 12 months of the agreement;  the tenant will be able to afford to make those payments on schedule; and the tenant would continue to pay their future rent in full." 
							  ) 
							~ -.5, TRUE ~ 0),
		pt_9_4_repay = case_when (what_does_the_policy_say_about_repayment_plans %in%
						c("The policy creates a default or standard repayment plan" , 
							"Landlords can require tenants to follow a repayment plan",
							"A landlord must offer you a reasonable payment plan if you cannot pay the rent. This has to be based on your own circumstances. The same payment plan to the entire building doesn't count.",
							"Tenants and landlords are encouraged to agree on a repayment plan, but, in the absence of the agreement to such a plan, The policy creates a default or standard repayment plan in which total of all delayed payment shall be repayed in 4 equal payments to be paid in 30 day intervals beginning the day after the ordinance expires.",
							"Tenant must pay suspended rent within six months of the termination of the COVID-19 local emergency" ) 
						~ -1, TRUE ~ 0))
# pt_8_1_late_evict = case_when

## landlord obligations to tenant
# pt11_1
# pt11_2
# pt11_3
# pt11_4

data_tab1 <- data_tab1 %>% 
	mutate(
	pt_10_01_court = case_when( are_courts_holding_eviction_proceedings %in% 
																c("Yes, courts have limited proceedings but may still allow evictions",
																	"Yes, courts have limited proceedings but may still allow evictions. Landlords are required to file a verification form along with any eviction complaint for nonpayment of rent filed before July 25, 2020. The verification form must say whether the tenant’s home is exempt from the eviction protection created by the CARES Act.",
																	"There was a suspension of cases through May 17. May have resumed."   ) ~  -2,
						 remote_hearings_allowed_in_non_emergency_civil_cases %in% c("Y") ~ -2, 
						 TRUE ~ 0),
		pt_10_02_court = case_when( are_courts_holding_eviction_proceedings %in% 
						 	c("No, courts specifically suspended eviction proceedings" , 
								"No, courts suspended non-emergency civil proceedings",
								"No") ~  3, 
						 x3_suspends_hearings_on_eviction %in% c("Y") ~ 3 ,
						 TRUE ~ 0))
# pt_10_03_court = case_when( ~ -.5, TRUE ~  TRUE ~ 0),

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_10_04_court = case_when( exempts_criminal_activity_damage_to_property_emergency_nuisance_or_cases_to_protect_public_health_from_eviction_freeze %in% c("Y") ~ -.5, TRUE ~ 0),
		# pt_10_05_court = case_when( exempts_criminal_activity_damage_to_property_emergency_nuisance_or_cases_to_protect_public_health_from_eviction_freeze %in% c("Y")~ -.5, TRUE ~ 0),
		# pt_10_06_court = case_when( exempts_criminal_activity_damage_to_property_emergency_nuisance_or_cases_to_protect_public_health_from_eviction_freeze %in% c("Y")~ -.5, TRUE ~ 0),
		# pt_10_07_court = case_when( exempts_criminal_activity_damage_to_property_emergency_nuisance_or_cases_to_protect_public_health_from_eviction_freeze %in% c("Y")~ -.5, TRUE ~ 0),
		pt_10_08_court = case_when( x3_suspends_hearings_on_eviction %in% c("Local Discretion" ) ~ -.5,
															 x4_stays_order_judgment_or_writ_of_eviction %in% c("Local Discretion" ) ~ -.5, TRUE ~ 0),
		pt_10_09_court = case_when( x2_suspends_filing_of_eviction_claim %in%  c("Y", "In Effect Y")~ 3, TRUE ~ -3),
		pt_10_10_court = case_when( x3_suspends_hearings_on_eviction %in% c("Y", "In Effect Y") ~  3, TRUE ~ -3),
		pt_10_11_court = case_when( tolls_extends_or_stays_court_deadlines %in% c("Y", "In Effect Y") ~  1, TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_10_12_court = case_when( will_courts_issue_writs_of_possession_i_e_order_the_tenant_to_leave %in% 
		 	c("No",
		 		"Courts will not issue evictions in foreclosure cases.") ~  3,
    x4_stays_order_judgment_or_writ_of_eviction %in% 	
			 	c("Y", "In Effect Y", "COVID-19 Related")  ~ 3,
		 TRUE ~ -3))

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_10_13_court = case_when( will_law_enforcement_act_on_writs_of_possession_i_e_forcibly_remove_tenants_from_their_homes %in% 
		 	c("Yes") ~  -3,
		 x5_suspends_enforcement_of_new_order_of_eviction  %in%
		 	c("Y", "In Effect Y", "COVID-19 Related") ~ 3,
		 TRUE ~ -3))

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_10_14_court = case_when( requires_certification_that_property_is_not_covered_under_cares_act_moratorium %in% c("Yes") ~3,
		 TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(
		pt_11_1_renter_prot = case_when( is_there_a_ban_on_rent_increases %in%
			 	c("Yes",
			 		"Yes, for all housing",
			 		"Yes, but for tenants under quarantine, self-quarantine, or experiencing loss of income due to COVID-19.",
			 		"Yes, excluding residents in newer apartment buildings, those who rent from non-corporate landlords, and those who rent space in their landlordsâ€™ homes.",
			 		"Yes, excluding residents in newer apartment buildings, those who rent from non-corporate landlords, and those who rent space in their landlords’ homes.",
			 		"Yes, for all housing",
			 		"The City Council also approved an anti-price gouging ordinance limiting price increases on many items, including rent, to 10% above the pre-emergency price.")
			 ~  3, TRUE ~ 0))
data_tab1 <- data_tab1 %>% 
	mutate(
		pt_11_2_renter_prot = case_when( is_there_a_ban_on_rent_increases %in%
			 	c( "Yes, but only on rent-controlled housing") ~ -2, TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(		pt_11_4_renter_prot = case_when( can_landlords_charge_late_fees_or_interest_on_missed_rent_payments %in% 
					c("No, they can't charge late fees or interest",
						"No, they can't charge late fees or interest // No, ellos no pueden cobrar cargo por retraso ni interés") ~  1,
						prohibits_issuance_of_late_fees_to_landlord %in% c('Y') ~ 1,
						TRUE ~ 0))

data_tab1 <- data_tab1 %>% 
	mutate(		pt_11_5_renter_prot = case_when( can_tenants_pay_some_or_all_of_their_rent_out_of_their_security_deposit %in%
					c("Yes") ~  2, 
					what_does_the_policy_say_about_repayment_plans %in% 
							c("A landlord may not recover rent that is delayed for reasons stated in this Order if the landlord has already obtained compensation for the rent through federal or state government relief funds or other programs that provide such compensation. A landlord of a residential tenant may not, during the term of this Order or thereafter, charge or collect interest that would accrue on such rent during the term of this Order or for twelve months thereafter.") 
					~ 2,
					TRUE ~ 0))


##  ####
## add landlord obligations once completed


# lets add!
data_points  <- data_tab1   %>%  select(starts_with("pt"))
data_points1 <- data_points %>%  select(starts_with("pt"   )) %>% mutate(pts_total = rowSums(. , na.rm = TRUE))
data_points2 <- data_points %>%  select(starts_with("pt_1_")) %>% mutate(pts_eviction_initiation_tot_10 = rowSums(. , na.rm = TRUE))
data_points3 <- data_points %>%  select(starts_with("pt_2_")) %>% mutate(pts_eviction_protect_tot_04 = rowSums(. , na.rm = TRUE))
data_points4 <- data_points %>%  select(starts_with("pt_3_")) %>% mutate(pts_eviction_pending_tot_03  = rowSums(. , na.rm = TRUE))
data_points5 <- data_points %>%  select(starts_with("pt_4_")) %>% mutate(pts_tenant_action_tot_00 = rowSums(. , na.rm = TRUE))
data_points6 <- data_points %>%  select(starts_with("pt_5_")) %>% mutate(pts_partial_rent_tot_01 = rowSums(. , na.rm = TRUE))
data_points7 <- data_points %>%  select(starts_with("pt_6_")) %>% mutate(pts_repayment_period_tot_05 = rowSums(. , na.rm = TRUE))
data_points8 <- data_points %>%  select(starts_with("pt_8_")) %>% mutate(pts_latefees_tot_03 = rowSums(. , na.rm = TRUE))
data_points9 <- data_points %>%  select(starts_with("pt_9_")) %>% mutate(pts_repayment_plan_tot_00 = rowSums(. , na.rm = TRUE))
data_points10 <- data_points %>% select(starts_with("pt_10_")) %>% mutate(pts_courts_tot_15 = rowSums(. , na.rm = TRUE))
data_points11 <- data_points %>% select(starts_with("pt_11_")) %>% mutate(pts_renter_protection_tot_06 = rowSums(. , na.rm = TRUE))