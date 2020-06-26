# string point interpolation 
# View(globalenv())
# load("C:\\Users\\azada\\OneDrive\\@Projects\\aemp\\covid_map_data\\.RData")
# library(dplyr)
# library(glue)


# verbose_if <-
#   function() {
#     
#     # create the function that will replace `if`
#     f <- function(cond, yes, no){
#       # remove modified if already
#       rm(`if`,envir = parent.frame())
#       
#       # break down the condition and print
#       print(breakdown_df(substitute(cond)))
#       
#       # reevaluate the call
#       eval.parent(sys.call())
#     }
#     # override `if` in the parent frame
#     assign("if", value = f,envir = parent.frame())
#   }
# 
# verbose_while <-
#   function() {
#     # create the function that will replace `while`
#     f <- function(cond, expr){
#       # remove modified if already
#       rm(`while`,envir = parent.frame())
#       
#       # reevaluate the call, printing the breakdown before going through expr
#       eval.parent(substitute({
#         print(breakdown_df(quote(cond)))
#         while(cond){
#           expr
#           print(breakdown_df(quote(cond), names = FALSE))
#           }
#         })
#         )
#     }
#     # override `if` in the parent frame
#     assign("while", value = f,envir = parent.frame())
#   }
# 

library(glue)


# Eviction Policies
# What Is the Protection 
# How the policies affect _'Eviction Initiations'_

data_tab1$inp_pt1_1 <- ifelse( data_tab1$pt_1_1_evict_init == 8, "(+8 pts) Landlords are not allowed to serve notice", "")
data_tab1$inp_pt1_2 <- ifelse( data_tab1$pt_1_2_evict_init == 2, "(+2 pts) Tenants have a defense in court against evictions", "")

data_tab1$glue_out_1 <- glue("
Eviction Initiations:
{data_points2$pts_eviction_initiation_tot_10} pts out of 10 maximum points were given.
{data_tab1$inp_pt1_1}
{data_tab1$inp_pt1_2}

                             ")

# Eviction Protections

data_tab1$inp_pt2_5 <- ifelse( data_tab1$ pt_2_5_protect == 5,  "(+5 pts) all evictions blocked", "")
data_tab1$inp_pt2_1 <- ifelse( data_tab1$ pt_2_1_protect == 1,  "(+2 pts) no-fault evictions blocked", "")
data_tab1$inp_pt2_2 <- ifelse( data_tab1$ pt_2_3_protect == 2,  "(+2 pts) no evictions for non-payment of rent / non-payment related to the pandemic", "")
data_tab1$inp_pt2_3 <- ifelse( data_tab1$ pt_2_2_protect == .5, "(+0.5 pts) no evictions when anyone in the household is ill, under isolation, or in quarantine", "")
data_tab1$inp_pt2_4 <- ifelse( data_tab1$ pt_2_4_protect == .5, "(+0.5 pts) no evictions for unauthorized occupants, pets, or nuisance related to the pandemic.", "")

data_tab1$glue_out_2 <- glue("
Eviction Protections: 
{data_points3$pts_eviction_protect_tot_04} pts out of 5 maximum points were given.
{data_tab1$inp_pt2_5}
{data_tab1$inp_pt2_1}
{data_tab1$inp_pt2_2}
{data_tab1$inp_pt2_3}
{data_tab1$inp_pt2_4}

                             ")

# What is the status of pending evictions?

# "Out of 3 possible points," pts_eviction_pending_tot_03 "pts were awarded."
data_tab1$inp_pt3_1 <- ifelse( data_tab1$ pt_3_1_pending == 1 , "(+1 pt) Evictions already in court process are stayed", "")
data_tab1$inp_pt3_2 <- ifelse( data_tab1$ pt_3_2_pending == 1 , "(+1 pt) Notices that were pending when this order took effect are frozen until the order ends.", "")
data_tab1$inp_pt3_3 <- ifelse( data_tab1$ pt_3_3_pending == 1 , "(+1 pt) this applies retroactively to any notices issued since (check the local ordinance).", "")

data_tab1$glue_out_3 <- glue("
Status of pending evictions: 
{data_points4$pts_eviction_pending_tot_03} pts were given out of 3 maximum points.
{data_tab1$inp_pt3_1}
{data_tab1$inp_pt3_2}
{data_tab1$inp_pt3_3}

")

# What does the tenant have to do? 
data_tab1$inp_pt4_1 <- ifelse( data_tab1$pt_4_1_tenant_do == -1,	    "(-1 pts) Tenants must notify their landlord that they can’t afford to pay." , "" )
data_tab1$inp_pt4_2 <- case_when( data_tab1$pt_4_2_tenant_do == 0 ~   "( 0 pts) 7+ days after the rent being due",
                                  data_tab1$pt_4_2_tenant_do == -1 ~  "(-1 pt) less than 7 days after rent being due, or before rent is due")
data_tab1$inp_pt4_3 <- ifelse( data_tab1$pt_4_3_tenant_do == -3,	    "(-3 pts) Tenants must provide documentation to support their claim", "")
data_tab1$inp_pt4_4 <- ifelse( data_tab1$pt_4_4_tenant_do == -1.5,    "(-1.5 pts) within a specified number of days after giving this notice.", "")
data_tab1$inp_pt4_5 <- ifelse( data_tab1$pt_4_5_tenant_do == -.5,	    "(-0.5 pts) when the repayment period begins.", "")
data_tab1$inp_pt4_6 <- ifelse( data_tab1$pt_4_6_tenant_do == 2,	      "(+2 pts) If tenants don’t have documentation, they can sign a statement instead", "")

data_tab1$glue_out_4 <- glue("
What does the tenant have to do?
{data_points5$pts_tenant_action_tot_00} pts were removed out of maximum 7 penalty points:
{data_tab1$inp_pt4_1}
{data_tab1$inp_pt4_2}
{data_tab1$inp_pt4_3}
{data_tab1$inp_pt4_4}
{data_tab1$inp_pt4_5}
{data_tab1$inp_pt4_6}

                             ")

# partial rent
# data_tab1$pts_partial_rent_tot_01
data_tab1$inp_pt5_1 <- ifelse(data_tab1$pt_5_1_part_rent == -2, "(-2 pts) Tenants must pay as much of their rent as possible.", "")
# -1	NA	which the city defines as the full rent minus the documented change in income.
data_tab1$inp_pt5_3 <- ifelse(data_tab1$pt_5_3_part_rent == 1,	 "(+1 pt) Tenants can make a partial payment, and the landlord must accept it." , "")

data_tab1$glue_out_5 <- glue("
Partial Rent:
{data_points6$pts_partial_rent_tot_01} pts: were given / removed of (-3 to +1 possible points).
{data_tab1$inp_pt5_1}
{data_tab1$inp_pt5_3}

                             ")


# repayment period
# pts_repayment_period_tot_05
# (exclusively variable)		After the order ends, tenants will have ___ days/months to make up any rent they missed during the emergency. 
data_tab1$inp_pt6_1 <- ifelse( data_tab1$pt_6_1_how_long == 5,		"(+5 pts) After the order ends, tenants never have to pay back" ,"" )
data_tab1$inp_pt6_2 <- ifelse( data_tab1$pt_6_2_how_long == 0,		"( 0 pts) After the order ends, tenants have 1 year or more after order ends" ,"" )
data_tab1$inp_pt6_3 <- ifelse( data_tab1$pt_6_3_how_long == -1,		"(-1 pt) After the order ends, tenants have 120 or more days" ,"" )
data_tab1$inp_pt6_4 <- ifelse( data_tab1$pt_6_4_how_long == -3,		"(-3 pts) After the order ends, tenants have 60 to 119 days" ,"" )
data_tab1$inp_pt6_5 <- ifelse( data_tab1$pt_6_5_how_long == -4,		"(-4 pts) After the order ends, tenants have 30 days" ,"" )
data_tab1$inp_pt6_6 <- ifelse( data_tab1$pt_6_6_how_long == -5,		"(-5 pts) After the order ends, tenants have to immediately pay back" ,"" )
# data_tab1$pt_6_1_how_long == 0		The law doesn’t say how long tenants have to repay their rent.

data_tab1$glue_out_6 <- glue("
Repayment Period 
{data_points7$pts_repayment_period_tot_05} pts were given / removed of (-5 to +5 possible points)
{data_tab1$inp_pt6_1}{data_tab1$inp_pt6_2}{data_tab1$inp_pt6_3}{data_tab1$inp_pt6_4}{data_tab1$inp_pt6_5}{data_tab1$inp_pt6_6} the missed rent.

                             ")

# late fees
# pts_latefees_tot_03
data_tab1$inp_pt8_1 <- ifelse(data_tab1$pt_8_1_fees == 3, "(+3 pts) Late fees and interest cannot be charged", "")
data_tab1$inp_pt8_2 <- ifelse(data_tab1$pt_8_1_fees == -2,"(-2 pts) Landlords can charge late fees.", "")
data_tab1$inp_pt8_3 <- ifelse(data_tab1$pt_8_1_fees == -3,"(-3 pts) Landlords can charge late fees and interest.", "")
data_tab1$inp_pt8_4 <- ifelse(data_tab1$pt_8_1_fees == -1,"(-3 pts) Landlords can charge interest.", "")

data_tab1$glue_out_8 <- glue("
Late Fees:
{data_points8$pts_latefees_tot_03} pts were given / removed of (-3 to +3 possible points)
{data_tab1$inp_pt8_1}{data_tab1$inp_pt8_2}{data_tab1$inp_pt8_3}{data_tab1$inp_pt8_4}
                             
")

# later evictions

# Repayment Plan
# pts_repayment_plan_tot_00
# data_tab1$inp_pt_8_1 <- ifelse(data_tab1$pt_8_1_repay == 0	 ,"( 0 pts)	 The payment can be made incrementally.", "")
data_tab1$inp_pt_9_1 <- ifelse(data_tab1$pt_9_1_repay == -.5 ,"(-.5 pts) Landlords and tenants are encouraged to agree to a repayment plan", "")
data_tab1$inp_pt_9_2 <- ifelse(data_tab1$pt_9_2_repay == -.5 ,"(-.5 pts) within a certain num. of days of the first missed rent payment.", "")
data_tab1$inp_pt_9_3 <- ifelse(data_tab1$pt_9_3_repay == -.5 ,"(-.5 pts) before the order ends.", "")
data_tab1$inp_pt_9_4 <- ifelse(data_tab1$pt_9_4_repay == -1 , "(-1 pts) The policy creates a default or standard repayment plan", "")

# pt_8_5_repay == -2 to 0		If they don’t, there is a default requirement.

data_tab1$glue_out_7 <- glue("
Repayment Plans:
{data_points9$pts_repayment_plan_tot_00} were removed of (0 to -2.5 possible pts)
{data_tab1$inp_pt_9_4}
{data_tab1$inp_pt_9_1}{data_tab1$inp_pt_9_2}{data_tab1$inp_pt_9_3}


                             ")

# Courts
# pts_courts_tot_15
# -14 to 16 
data_tab1$inpt_10_01_court <- ifelse (data_tab1$pt_10_01_court ==	-2,	"(-2 pts) Courts have limited in-person proceedings, but evictions may go forward with remote hearings.", "")
data_tab1$inpt_10_02_court <- ifelse (data_tab1$pt_10_02_court ==	3	,	"(3 pts) Courts have suspended eviction proceedings", "")
# pt_10_03_court	-0.5	except “emergencies”
data_tab1$inpt_10_04_court <- ifelse (data_tab1$pt_10_04_court ==	-0.5,	"(-0.5 pts) except alleged criminal activity", "")
# pt_10_05_court	-0.5	except a nuisance
# pt_10_06_court	-0.5	except a threat to public health or safety
# pt_10_07_court	-0.5	except violence or substantial property damage
data_tab1$inpt_10_08_court <- ifelse (data_tab1$pt_10_08_court ==	-0.5,	"(-0.5 pts) at the discretion of the judge." ,"")
data_tab1$inpt_10_09_court <- case_when( data_tab1$pt_10_09_court == -3 ~  "(-3 pts) Courts will accept filings for new eviction cases.",
            data_tab1$pt_10_09_court == 3	~	"(3 pts) Courts will not accept filings for new eviction cases.",
            TRUE ~ "")          
data_tab1$inpt_10_10_court <- case_when( data_tab1$pt_10_10_court	== 3	 ~	"(3 pts) Courts will issue summons requiring tenants to appear in court.",
            data_tab1$pt_10_10_court ==	-3 ~	"(-3 pts) Courts will not issue summons requiring tenants to appear in court.",
            TRUE ~ "")
data_tab1$inpt_10_11_court <- ifelse (data_tab1$pt_10_11_court ==	1	,	"(1 pts) Tenants have more time to respond" ,"")
data_tab1$inpt_10_12_court <- case_when (data_tab1$pt_10_12_court ==	3	~	"(3 pts) Courts will not issue writs of possession.",
                                data_tab1$pt_10_12_court ==	-3	~	"(-3 pts) Courts will issue writs of possession.",
                                  TRUE ~ "")
data_tab1$inpt_10_13_court <- case_when (data_tab1$pt_10_13_court ==	-3 ~		"(-3 pts) Law enforcement will  enforce writs to remove tenants from their homes",
                                  data_tab1$pt_10_13_court ==	3 ~		"(3 pts) Law enforcement will not enforce writs to remove tenants from their homes",
                                  TRUE ~ "")
data_tab1$inpt_10_14_court <- ifelse (data_tab1$pt_10_14_court ==	2,		"(2 pts) Landlord must certify that property is not subject to the CARES Act moratorium", "")

data_tab1$glue_out_8 <- glue("
Court Processes:
{data_points10$pts_courts_tot_15} pts were given / removed of (-14 to +16 possible points)
{data_tab1$inpt_10_01_court}
{data_tab1$inpt_10_02_court}{data_tab1$inpt_10_04_court} {data_tab1$inpt_10_08_court}
{data_tab1$inpt_10_09_court}
{data_tab1$inpt_10_10_court}
{data_tab1$inpt_10_11_court}
{data_tab1$inpt_10_12_court}
{data_tab1$inpt_10_13_court}
{data_tab1$inpt_10_14_court}

                             ")

#Renter Protection
# pts_renter_protection_tot_06
# 7			
data_tab1$inpt_11_1_renter_prot <- ifelse(data_tab1$pt_11_1_renter_prot == 3,		"(+3 pts) Landlords cannot increase rents", "")
data_tab1$inpt_11_2_renter_prot <- ifelse(data_tab1$pt_11_2_renter_prot == -2,	"(-2 pts) on rent-controlled housing only", "")
data_tab1$inpt_11_4_renter_prot <- ifelse(data_tab1$pt_11_4_renter_prot == 1,		"(+1 pts) There is a ban on late rent fees", "")
data_tab1$inpt_11_5_renter_prot <- ifelse(data_tab1$pt_11_5_renter_prot == 2,		"(+2 pts) Tenants can use security deposits to pay rent", "")
# pt_11_3_renter_prot # +1	NA	Retroactive: Any rent increases issued since [MM]/[DD]/2020 are invalid.

data_tab1$glue_out_9 <- glue("
Renter Protections
{data_points11$pts_renter_protection_tot_06} out of 7 maximum points
{data_tab1$inpt_11_1_renter_prot}{data_tab1$inpt_11_2_renter_prot}
{data_tab1$inpt_11_4_renter_prot}
{data_tab1$inpt_11_5_renter_prot}

                             ")

# Landlord obligations to tenants	5			
# 		+3	NA	Landlords who violate this order can be sued for injunctive relief and damages.
# 		+1	NA	Landlords are required to notify tenants of these protections
# 		+0.5	NA	within 30 days after they go into effect.
# 		+0.5	NA	in writing (either by posting it at the property, through mail or email, or alongside any notice served).


# glue the glues

data_tab1$explanation_all <- glue("
Total Points: {data_points1$pts_total}

{data_tab1$glue_out_1}
{data_tab1$glue_out_2}
{data_tab1$glue_out_3}
{data_tab1$glue_out_4}
{data_tab1$glue_out_5}
{data_tab1$glue_out_6}
{data_tab1$glue_out_7}
{data_tab1$glue_out_8}
{data_tab1$glue_out_9}
                                  ") 

# data_tab1$explanation_all2 <-  gsub('\\n[2, 10]', "\\n", data_tab1$explanation_all)
# data_tab1$explanation_all2<- gsub("/[\\r\\n]+/", "", data_tab1$explanation_all)

# data_tab1$explanation_all2<- gsub("^\\n{1,}\\$", "", data_tab1$explanation_all)

data_tab1$explanation_all2<- gsub("^\\n{1,}$", "", data_tab1$explanation_all)
data_tab1$explanation_all2<- gsub("^\\n{1,}$", "", data_tab1$explanation_all2)

data_tab1$explanation_all2<- gsub("\\n\\n", "\n", data_tab1$explanation_all)


data_explainer_out <- bind_cols(( data_tab1 %>% select(geo, state )), data_points1 %>% select(pts_total), data_tab1 %>% select(explanation_all2))

write.csv( data_explainer_out, "data_explan.csv",)
