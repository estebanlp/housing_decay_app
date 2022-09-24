library(dplyr)

q1 <- tibble(
  question = rep("Q1: Is this house showing signs of decay?", 3),
  option =  c(
    "1- Yes",
    "2 - No",
    "3 - Not visible"
  ),
  input_type = c("mc"),
  input_id = rep("house_decay", 3),
  required = TRUE
)

q2_q5 <- tibble(
  question = c(
    rep("Q2: Is this house showing signs of roof damage?", 4),
    rep("Q3: Is this house showing signs of windows and doors damage?", 4),
    rep("Q4: Is this house showing signs of walls damage?", 4),
    rep("Q5: Is this house showing signs of foundation damage?", 4)
  ),
  option =  rep(c(
    "1 - Good",
    "2 - Moderate",
    "3 - Severe",
    "4 - Not visible"
  ), 4),
  input_type = c("mc"),
  input_id = c(
    rep("roof_damage", 4),
    rep("windowsdoors_damage", 4),
    rep("walls_damage", 4),
    rep("foundation_damage", 4)
  ),
  dependence = NA,
  dependence_value = NA,
  required = TRUE
)

radioB_question <- bind_rows(q1, q2_q5)

usethis::use_data(radioB_question, overwrite = T)

####

#index creator
treated<-paste0(0:81,"/")
control<-paste0(0:81,"_n/")

control2<-NULL
for(a in 0:81){
  control2<-c(control2,paste0(control[a+1],dir(control[a+1])))
}

ds <- data.frame(
  h_id=paste0("images/",c(treated,control2)),
  HD_d=NA, # missing please add (in comments in line 24)
  roof=NA,
  wds=NA, # missing please add
  walls=NA,
  foundation=NA,
  d1=NA, # missing please add as a matrix question
  d2=NA,
  d3=NA,
  d4=NA,
  d5=NA,
  d6=NA
)

usethis::use_data(ds)
