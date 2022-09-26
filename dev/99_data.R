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

matrix_question <- tibble(
  question = c(
    rep("Q6a: Does these images look Safe", 4),
    rep("Q6b: Does these images look Lively", 4),
    rep("Q6c: Does these images look Beautiful", 4),
    rep("Q6d: Does these images look Wealthy", 4),
    rep("Q6e: Does these images look Boring", 4),
    rep("Q6f: Does these images look Depressing", 4)
  ),
  option =  rep(c(
    "1- Agree",
    "2 - Neutral",
    "3 - Disagree",
    "4 - Cannot tell"
  ), 6),
  input_type = "matrix",
  # input_type = "mc",
  input_id = "ranks",
  # input_id = c(
  #   rep("q6_safe", 4),
  #   rep("q6_lively", 4),
  #   rep("q6_beautiful", 4),
  #   rep("q6_wealthy", 4),
  #   rep("q6_boring", 4),
  #   rep("q6_depressing", 4)
  # ),
  required = TRUE,
  dependence = NA,
  dependence_value = NA
)

usethis::use_data(matrix_question, overwrite = T)

####

#index creator
# treated<-paste0(0:81,"/")
# control<-paste0(0:81,"_n/")
# control2<-NULL
# for(a in 0:81){
#   control2<-c(control2,paste0(control[a+1],dir(control[a+1])))
# }

# images <- gsub("inst/app/images/", "images/", list.dirs("inst/app/images"))
# images <- images[images != "inst/app/images"]

images <- paste0("images/",
               list.files("inst/app/images", pattern = "jpg", recursive = T))

images <- unique(gsub("/sideA\\.jpg|/sideB\\.jpg|/target\\.jpg", "", images))

ds <- data.frame(
  # h_id=paste0("images/",c(treated,control2)),
  h_id = images,
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

usethis::use_data(ds, overwrite = T)
