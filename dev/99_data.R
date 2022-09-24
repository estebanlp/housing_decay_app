radioB_question <- data.frame(
  question = c("Is this house showing signs of roof damage?", "Is this house showing signs of roof damage?","Is this house showing signs of roof damage?",
               "Is this house showing signs of foundation defects?","Is this house showing signs of foundation defects?","Is this house showing signs of foundation defects?",
               "Is this house showing signs of exterior wall damage?","Is this house showing signs of exterior wall damage?","Is this house showing signs of exterior wall damage?"),
  option =  c("Yes","No","Not visible","Yes","No","Not visible","Yes","No","Not visible"),
  input_type = c("mc","mc","mc","mc","mc","mc","mc","mc","mc"),
  input_id = c("house_decay","house_decay","house_decay",
               "foundation_decay","foundation_decay","foundation_decay",
               "exterior_wall_decay","exterior_wall_decay","exterior_wall_decay"),
  dependence = NA,
  dependence_value = NA,
  required = c(TRUE,TRUE,TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
)

usethis::use_data(radioB_question)

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
