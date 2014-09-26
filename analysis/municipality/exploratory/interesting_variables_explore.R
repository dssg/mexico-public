### Documentation
# Script that just explores and plots a bunch of the interesting variables and factors that came out of our municipality modeling efforts that came out of "model_municipalities.R", "model_iteration_output.R", and "model_variations.R". Most of our findings and finalized plots are in our decks


library(RPostgreSQL)
library(dplyr)
library(Hmisc)
library(ggplot2)
library(wordcloud)
library(reshape2)
library(tree)
library(rpart)
db <- dbConnect(dbDriver("PostgreSQL"),
                host='',
                dbname='mexico',
                user='',
                password=''
)

data <- dbGetQuery(db, "SELECT * FROM nick.municipality_model_data")
row.names(data) <- data$municipality
data <- data[,!(names(data) %in% c("death_rt", "pct_maternal_deaths"))]
data <- data[complete.cases(data[,c('municipality', 'pop_total', 'pob_tot')]),]

### Set up additional variables
data <- within(data,{
  pct_rural_lcl <- rural_localities/n_localities
  pct_urban_lcl <- urban_localities/n_localities
  doctors_per_cap <- doctors/pop_total
  gyn_per_cap <- gynecologists/pop_total
  pct_gyn <- gynecologists/doctors
  pct_urban_pop <- urban_pop/pob_tot
  pct_rural_pop <- rural_pop/pob_tot
  pct_rural1_pop <- rural1_pop/pob_tot
  pct_rural2_pop <- rural2_pop/pob_tot
  pct_rural3_pop <- rural3_pop/pob_tot
  pct_rural4_pop <- rural4_pop/pob_tot
  rural_inst_per_rcap <- rural_institutions/rural_pop
  urban_inst_per_ucap <- urban_institutions/urban_pop
  rural_inst_per_cap <- rural_institutions/pop_total
  urban_inst_per_cap <- urban_institutions/pop_total
  preg_beds_per_pop_birth <- pregnancy_beds/pop_birth
  pct_other_institutions <- other_institutions/num_institutions
  pct_imss_institutions <- imss_institutions/num_institutions
  pct_issste_institutions <- issste_institutions/num_institutions
  pct_ssa_institutions <- ssa_institutions/num_institutions
  pct_opportunitidades_institutions <- opportunidades_institutions/num_institutions
  ssa_inst_per_ins <- ssa_institutions / ((pct_sp_insured/100)*pop_total)
  imss_inst_per_ins <- imss_institutions / ((pct_imss_insured/100)*pop_total)
  issste_inst_per_ins <- issste_institutions / ((pct_issste_insured/100)*pop_total)
  imss_issste_per_ins <- (imss_institutions + issste_institutions) / (((pct_imss_insured + pct_issste_insured)/100)*pop_total)
  opportunidades_inst_per_cap <- opportunidades_institutions / pop_total
  pct_attended_birth_doctor <- attended_birth_doctor / births
  pct_attended_birth_nurse <- attended_birth_nurse / births
  pct_attended_birth_midwife <- attended_birth_midwife / births
  pct_attended_birth_unspecified <- attended_birth_unspecified / births
  pct_birth_normal <- birth_procedure_normal / births
  pct_birth_cesarean <- birth_procedure_cesarean / births
  pct_birth_forceps <- birth_procedure_forceps / births
  pct_birth_other <- birth_procedure_other / births
  pct_birth_unspecified <- birth_procedure_unspecified / births
  pct_fetus_single <- fetus_single / births
  pct_fetus_twins <- fetus_twins / births
  pct_fetus_three_plus <- fetus_three_plus / births
  pct_fetus_unspecified <- fetus_unspecified / births
  pct_insurance_none <- insurance_none / births
  pct_insurance_imss_issste <- (insurance_imss + insurance_issste) / births
  pct_insurance_sp <- insurance_sp / births
  pct_insurance_opportunidades <- insurance_opportunidades / births
  pct_insurance_other <- insurance_other / births
  pct_insurance_unspecified <- insurance_unspecified / births
  pct_prenatal_yes <- prenatal_yes / births
  pct_prenatal_no <- prenatal_no / births
  pct_prenatal_unspecified <- prenatal_unspecified / births
  pct_first_prenatal_tri_no <- first_prenatal_tri_no / births
  pct_first_prenatal_tri_1 <- first_prenatal_tri_1 / births
  pct_first_prenatal_tri_2 <- first_prenatal_tri_2 / births
  pct_first_prenatal_tri_3 <- first_prenatal_tri_3 / births
  pct_first_prenatal_tri_ignored <- first_prenatal_tri_ignored / births
  avg_first_prenatal_tri <- (1*first_prenatal_tri_1 + 2*first_prenatal_tri_2 + 3*first_prenatal_tri_3) / (first_prenatal_tri_1 + first_prenatal_tri_2 + first_prenatal_tri_3)
})
# Impute missing/erroneus values
data <- within(data,{
  imss_issste_per_ins <- impute(imss_issste_per_ins, 0)
  issste_inst_per_ins <- impute(issste_inst_per_ins, 0)
  imss_inst_per_ins <- impute(imss_inst_per_ins, 0)
  ssa_inst_per_ins <- impute(ssa_inst_per_ins, 0)
  pct_opportunitidades_institutions <- impute(pct_opportunitidades_institutions, 0)
  pct_ssa_institutions <- impute(pct_ssa_institutions, 0)
  pct_issste_institutions <- impute(pct_issste_institutions, 0)
  pct_imss_institutions <- impute(pct_imss_institutions, 0)
  pct_other_institutions <- impute(pct_other_institutions, 0)
  urban_inst_per_ucap <- impute(urban_inst_per_ucap, 0)
  rural_inst_per_rcap <- impute(rural_inst_per_rcap, 0)
  pct_gyn <- impute(pct_gyn, 0)
  urban_clue_distance <- impute(urban_clue_distance, max)
  rural_clue_distance <- impute(rural_clue_distance, max)
  urban_loc_distance <- impute(urban_loc_distance, max)
  rural_loc_distance <- impute(rural_loc_distance, max)
  urban_basico_distance <- impute(urban_basico_distance, max)
  rural_basico_distance <- impute(rural_basico_distance, max)
  ssa_inst_per_ins[is.finite(ssa_inst_per_ins)==FALSE] <- max(ssa_inst_per_ins[is.finite(ssa_inst_per_ins)==TRUE])
  pct_no_contraceptive <- impute(pct_no_contraceptive, median)
  pct_contraceptive <- impute(pct_contraceptive, median)
  pct_md_pregnancy <- impute(pct_md_pregnancy, 0)
  pct_md_birth <- impute(pct_md_birth, 0)
  pct_md_puerperium <- impute(pct_md_puerperium, 0)
  pct_md_b_o10 <- impute(pct_md_b_o10, 0)      
  pct_md_b_o60 <- impute(pct_md_b_o60, 0)
  pct_md_b_o94 <- impute(pct_md_b_o94, 0)
  pct_md_b_o30 <- impute(pct_md_b_o30, 0)        
  pct_md_b_o85 <- impute(pct_md_b_o85, 0)
  pct_md_b_o00 <- impute(pct_md_b_o00, 0)
  pct_md_b_o20 <- impute(pct_md_b_o20, 0)
  pct_md_b_other <- impute(pct_md_b_other, 0)
  sp_mismatch <- impute(sp_mismatch, 0)
  opportunidades_mismatch <- impute(opportunidades_mismatch, 0)
  iio_mismatch <- impute(iio_mismatch, 0)     
})
for(column in names(data)){
  if(class(data[column]) == "impute"){
    data[column] <<- as.numeric(data[column])
  }
}
data$mmrate <- with(data, deaths/(pop_birth*4) * 1000)
#dbWriteTable(db, name = "full_model_data", value = data, overwrite=TRUE)
#wordcloud(names(data), scale=c(1,1))

data.no0 <- subset(data, deaths > 0)
data.atleast1000 <- subset(data, pop_total > 10000)

## Decile plot function
plotDeciles <- function(dataset, var_name, dep_var_name, measure){
  variable <- dataset[[var_name]]
  dep_var <- dataset[[dep_var_name]]
  splits <- with(dataset, cut(variable, 
                              breaks=quantile(variable, probs=seq(0,1, by=0.1)), 
                              include.lowest=TRUE, labels=FALSE))
  dep_var_median <- median(dep_var)
  dep_var_mean <- mean(dep_var)
  summary_mean <- aggregate(dep_var, list(decile=splits), mean)
  summary_median <- aggregate(dep_var, list(decile=splits), median)
  summary_n <- aggregate(dep_var, list(decile=splits), length)
  summary_above_median <- aggregate(dataset$mmr[dep_var > dep_var_median], list(decile=splits[dep_var > dep_var_median]), length)
  summary_above_mean <- aggregate(dataset$mmr[dep_var > dep_var_mean], list(decile=splits[dep_var > dep_var_mean]), length)
  summary <- summary_mean
  names(summary) <- c("decile", "mean")
  summary$median <- summary_median$x
  summary$n <- summary_n$x
  summary$pct_above_median <- summary_above_median$x / summary$n * 100
  summary$pct_above_mean <- summary_above_mean$x / summary$n * 100
  
  if(measure=="mean"){
    return(ggplot(summary, aes(factor(decile), mean)) + geom_bar(stat="identity") + labs(title=paste(var_name, "vs.", dep_var_name), x=paste(var_name, "decile"), y=paste("mean", dep_var_name)))
  } else if(measure=="median"){
    return(ggplot(summary, aes(factor(decile), median)) + geom_bar(stat="identity") + labs(title=paste(var_name, "vs.", dep_var_name), x=paste(var_name, "decile"), y=paste("median", dep_var_name)))
  } else if(measure=="pct_above_median"){
    return(ggplot(summary, aes(factor(decile), pct_above_median)) + geom_bar(stat="identity") + labs(title=paste(var_name, "vs.", dep_var_name), x=paste(var_name, "decile"), y=paste("Percent above median", dep_var_name)))
  } else if(measure=="pct_above_mean"){
    return(ggplot(summary, aes(factor(decile), pct_above_mean)) + geom_bar(stat="identity") + labs(title=paste(var_name, "vs.", dep_var_name), x=paste(var_name, "decile"), y=paste("Percent above mean", dep_var_name)))
  } else if(measure=="boxplot"){
    dataset$dep_var <- dataset[[dep_var_name]]
    dataset$splits <- with(dataset, cut(variable, 
                                        breaks=quantile(dataset[[var_name]], probs=seq(0,1, by=0.1)), 
                                        include.lowest=TRUE, labels=FALSE))
    return(ggplot(dataset, aes(factor(splits), dep_var)) + geom_boxplot() + labs(title=paste(var_name, "vs.", dep_var_name), x=paste(var_name, "decile"), y=paste("distribution of ", dep_var_name)))
  }
}

nice_theme <- theme(axis.text=element_text(size=20),
                    axis.title=element_text(size=24),
                    title=element_text(size=24),
                    legend.text=element_text(size=20))

# DISC 10
with(data, plot(disc10_r, mmrate))
with(data, cor(disc10_r, mmrate))
plotDeciles(data, "disc10_r", "mmrate", "pct_above_median")
plotDeciles(data.no0, "disc10_r", "mmrate", "pct_above_median")
plotDeciles(data.atleast1000, "disc10_r", "mmrate", "pct_above_median")
plotDeciles(data.atleast1000, "disc10_r", "mmrate", "boxplot")

# Margination
plotDeciles(data, "margination", "mmrate", "pct_above_mean") + nice_theme + labs(title=NULL, y="Percent Above Mean MMRate", x="Margination Decile")
plotDeciles(data.no0, "margination", "mmrate", "pct_above_mean")
plotDeciles(data.atleast1000, "margination", "mmrate", "pct_above_mean")
plotDeciles(data.atleast1000, "margination", "mmrate", "pct_above_median")

# Viv41
plotDeciles(data, "viv41_r", "mmrate", "pct_above_mean")
plotDeciles(data, "viv41_r", "margination", "pct_above_mean")

# Edu 20
plotDeciles(data, "edu20_r", "mmrate", "pct_above_mean") + nice_theme + labs(title=NULL, y="Percent Above Mean MMRate", x="Percentage of Females Aged 8-14 Who Are Literate (Deciled)")
plotDeciles(data, "edu20_r", "margination", "pct_above_mean")
ggplot(data, aes(edu20_r, margination)) + geom_point() + nice_theme
plot(data$edu20_r, data$margination)

# Pct Birth Normal / Cesarean
plotDeciles(data, "pct_birth_normal", "mmrate", "pct_above_mean")
plotDeciles(data, "pct_birth_cesarean", "mmrate", "pct_above_mean")
plotDeciles(data, "pct_birth_cesarean", "margination", "pct_above_mean")
with(data, plot(pct_birth_cesarean, margination))
with(data, plot(avg_prenatal_consults, pct_birth_cesarean))
with(data, plot(pct_prenatal_yes, pct_birth_cesarean))

# Pct Rural4 Pop
plotDeciles(data, "margination", "pct_rural4_pop", "pct_above_mean")

# Insurance None
plotDeciles(data, "pct_insurance_none", "mmrate", "pct_above_mean")
with(data, plot(pct_insurance_none, mmrate))
with(data.no0, plot(pct_insurance_none, mmrate))
with(data.atleast1000, plot(pct_insurance_none, mmrate))

# Pct_md_puerperium
with(data, plot(pct_md_puerperium, mmrate))

# Prenatal Care
plotDeciles(data, "pct_prenatal_yes", "mmrate", "pct_above_mean") + nice_theme + labs(title=NULL, y="Percent Above Mean MMRate", x="Percentage of Births That Received Prenatal Care (Deciled)")
plotDeciles(data, "pct_prenatal_yes", "margination", "pct_above_mean")
plotDeciles(data, "avg_prenatal_consults", "mmrate", "pct_above_mean")
plotDeciles(data, "avg_prenatal_consults", "margination", "pct_above_mean") + nice_theme + labs(title=NULL, y="Percent Above Mean MMRate", x="Average Prenatal Consults (Deciled)")
with(data, plot(pct_prenatal_yes, mmrate))
with(data, plot(avg_prenatal_consults, mmrate))
# WHAT'S THAT MUNICIPALITY!?

# Insurance None
plotDeciles(data, "pct_insurance_none", "mmrate", "pct_above_mean") + nice_theme + labs(title=NULL, y="Percent Above Mean MMRate", x="Percentage of Births That Occurred Without Insurance (Deciled)")
plotDeciles(data, "pct_insurance_none", "margination", "pct_above_mean")

plotDeciles(data, "rural_inst_per_cap", "mmrate", "pct_above_mean")
rural_inst_per_cap

# Prenatal by margination decile
data$margination_decile <- with(data, cut(margination, 
                                          breaks=quantile(margination, probs=seq(0,1, by=0.1)), 
                                          include.lowest=TRUE, labels=FALSE))
data$margination_quintile <- with(data, cut(margination, 
                                            breaks=quantile(margination, probs=seq(0,1, by=0.2)), 
                                            include.lowest=TRUE, labels=FALSE))
aggregate(avg_prenatal_consults~margination_quintile, data, mean)
aggregate(pct_first_prenatal_tri_1~margination_quintile, data, mean)

### PLOT IF PRENATAL CARE BY MARGINATION DECILE HOLDS TRUE
data$dep <- with(data, deaths/pop_birth)
test1 <- glm(dep~margination_decile + avg_prenatal_consults, data=data, weights=pop_birth, family="binomial")
summary(test1)
test2 <- glm(dep~margination + avg_prenatal_consults, data=data, weights=pop_birth, family="binomial")
summary(test2)

ggplot(subset(data, margination_quintile==1 & deaths >= 3), aes(avg_prenatal_consults, mmrate)) + geom_point() +
  geom_smooth(method="lm", se=FALSE) + nice_theme + labs(x="Average Prenatal Consults", y="MMRate") + coord_cartesian(ylim=c(0,.2))
test3 <- rpart(mmrate ~ avg_prenatal_consults + margination, data=data)
printcp(test3)
plot(test3)
text(test3, use.n=TRUE, all=TRUE, cex=.8)
pruned.test3 <- prune(test3, cp=0.019093)
plot(pruned.test3)
text(pruned.test3)
printcp(test3)
plotcp(test3)
test4 <- tree(mmrate ~ avg_prenatal_consults + margination, data=data)
plot(test4)
text(test4)


### Prenatal Data
temp.data <- dbGetQuery(db, "SELECT * FROM nick.prenatal_care_municipal2")
prenatal.data <- subset(data, select=c("municipality", "nom_ent", "nom_mun", "margination", "deaths", "pop_total"))
prenatal.data <- merge(prenatal.data, temp.data, all.x=TRUE, by="municipality")
prenatal.data <- within(prenatal.data, {
  none_pct_first_prenatal_tri_no <- none_first_prenatal_tri_no / none_insurance_births
  none_pct_first_prenatal_tri_1 <- none_first_prenatal_tri_1 / none_insurance_births
  none_pct_first_prenatal_tri_2 <- none_first_prenatal_tri_2 / none_insurance_births
  none_pct_first_prenatal_tri_3 <- none_first_prenatal_tri_3 / none_insurance_births
  none_pct_first_prenatal_tri_ignored <- none_first_prenatal_tri_ignored / none_insurance_births
  none_avg_first_prenatal_tri <- (1*none_first_prenatal_tri_1 + 2*none_first_prenatal_tri_2 + 3*none_first_prenatal_tri_3) / (none_first_prenatal_tri_1 + none_first_prenatal_tri_2 + none_first_prenatal_tri_3)
  imss_pct_first_prenatal_tri_no <- imss_first_prenatal_tri_no / imss_insurance_births
  imss_pct_first_prenatal_tri_1 <- imss_first_prenatal_tri_1 / imss_insurance_births
  imss_pct_first_prenatal_tri_2 <- imss_first_prenatal_tri_2 / imss_insurance_births
  imss_pct_first_prenatal_tri_3 <- imss_first_prenatal_tri_3 / imss_insurance_births
  imss_pct_first_prenatal_tri_ignored <- imss_first_prenatal_tri_ignored / imss_insurance_births
  imss_avg_first_prenatal_tri <- (1*imss_first_prenatal_tri_1 + 2*imss_first_prenatal_tri_2 + 3*imss_first_prenatal_tri_3) / (imss_first_prenatal_tri_1 + imss_first_prenatal_tri_2 + imss_first_prenatal_tri_3)
  issste_pct_first_prenatal_tri_no <- issste_first_prenatal_tri_no / issste_insurance_births
  issste_pct_first_prenatal_tri_1 <- issste_first_prenatal_tri_1 / issste_insurance_births
  issste_pct_first_prenatal_tri_2 <- issste_first_prenatal_tri_2 / issste_insurance_births
  issste_pct_first_prenatal_tri_3 <- issste_first_prenatal_tri_3 / issste_insurance_births
  issste_pct_first_prenatal_tri_ignored <- issste_first_prenatal_tri_ignored / issste_insurance_births
  issste_avg_first_prenatal_tri <- (1*issste_first_prenatal_tri_1 + 2*issste_first_prenatal_tri_2 + 3*issste_first_prenatal_tri_3) / (issste_first_prenatal_tri_1 + issste_first_prenatal_tri_2 + issste_first_prenatal_tri_3)
  other_pct_first_prenatal_tri_no <- other_first_prenatal_tri_no / other_insurance_births
  other_pct_first_prenatal_tri_1 <- other_first_prenatal_tri_1 / other_insurance_births
  other_pct_first_prenatal_tri_2 <- other_first_prenatal_tri_2 / other_insurance_births
  other_pct_first_prenatal_tri_3 <- other_first_prenatal_tri_3 / other_insurance_births
  other_pct_first_prenatal_tri_ignored <- other_first_prenatal_tri_ignored / other_insurance_births
  other_avg_first_prenatal_tri <- (1*other_first_prenatal_tri_1 + 2*other_first_prenatal_tri_2 + 3*other_first_prenatal_tri_3) / (other_first_prenatal_tri_1 + other_first_prenatal_tri_2 + other_first_prenatal_tri_3)
  unspecified_pct_first_prenatal_tri_no <- unspecified_first_prenatal_tri_no / unspecified_insurance_births
  unspecified_pct_first_prenatal_tri_1 <- unspecified_first_prenatal_tri_1 / unspecified_insurance_births
  unspecified_pct_first_prenatal_tri_2 <- unspecified_first_prenatal_tri_2 / unspecified_insurance_births
  unspecified_pct_first_prenatal_tri_3 <- unspecified_first_prenatal_tri_3 / unspecified_insurance_births
  unspecified_pct_first_prenatal_tri_ignored <- unspecified_first_prenatal_tri_ignored / unspecified_insurance_births
  unspecified_avg_first_prenatal_tri <- (1*unspecified_first_prenatal_tri_1 + 2*unspecified_first_prenatal_tri_2 + 3*unspecified_first_prenatal_tri_3) / (unspecified_first_prenatal_tri_1 + unspecified_first_prenatal_tri_2 + unspecified_first_prenatal_tri_3)
  sp_pct_first_prenatal_tri_no <- sp_first_prenatal_tri_no / sp_insurance_births
  sp_pct_first_prenatal_tri_1 <- sp_first_prenatal_tri_1 / sp_insurance_births
  sp_pct_first_prenatal_tri_2 <- sp_first_prenatal_tri_2 / sp_insurance_births
  sp_pct_first_prenatal_tri_3 <- sp_first_prenatal_tri_3 / sp_insurance_births
  sp_pct_first_prenatal_tri_ignored <- sp_first_prenatal_tri_ignored / sp_insurance_births
  sp_avg_first_prenatal_tri <- (1*sp_first_prenatal_tri_1 + 2*sp_first_prenatal_tri_2 + 3*sp_first_prenatal_tri_3) / (sp_first_prenatal_tri_1 + sp_first_prenatal_tri_2 + sp_first_prenatal_tri_3)
  oportunidades_pct_first_prenatal_tri_no <- oportunidades_first_prenatal_tri_no / oportunidades_insurance_births
  oportunidades_pct_first_prenatal_tri_1 <- oportunidades_first_prenatal_tri_1 / oportunidades_insurance_births
  oportunidades_pct_first_prenatal_tri_2 <- oportunidades_first_prenatal_tri_2 / oportunidades_insurance_births
  oportunidades_pct_first_prenatal_tri_3 <- oportunidades_first_prenatal_tri_3 / oportunidades_insurance_births
  oportunidades_pct_first_prenatal_tri_ignored <- oportunidades_first_prenatal_tri_ignored / oportunidades_insurance_births
  oportunidades_avg_first_prenatal_tri <- (1*oportunidades_first_prenatal_tri_1 + 2*oportunidades_first_prenatal_tri_2 + 3*oportunidades_first_prenatal_tri_3) / (oportunidades_first_prenatal_tri_1 + oportunidades_first_prenatal_tri_2 + oportunidades_first_prenatal_tri_3)
  margination_decile <- cut(margination, 
                            breaks=quantile(margination, probs=seq(0,1, by=0.1)), 
                            include.lowest=TRUE, labels=FALSE)
  margination_quintile <- cut(margination, 
                            breaks=quantile(margination, probs=seq(0,1, by=0.2)), 
                            include.lowest=TRUE, labels=FALSE)
})
#dbWriteTable(db, name = "prenatal_insurance_data", value = prenatal.data, overwrite=TRUE)

imss.v.sp.consults <- aggregate(cbind(imss_avg_prenatal_consults, sp_avg_prenatal_consults)~margination_quintile, subset(prenatal.data, deaths>=3), mean)
imss.v.sp.prenatal.tri <- aggregate(cbind(imss_avg_first_prenatal_tri, sp_avg_first_prenatal_tri)~margination_quintile, subset(prenatal.data, deaths>=3), mean)
imss.v.sp.consults2 <- melt(imss.v.sp.consults, id.vars="margination_quintile", variable.name="insurance", value.name="mean")
imss.v.sp.prenatal.tri2 <- melt(imss.v.sp.prenatal.tri, id.vars="margination_quintile", variable.name="insurance", value.name="mean")
imss.v.sp.prenatal.tri.1 <- aggregate(cbind(imss_pct_first_prenatal_tri_1, sp_pct_first_prenatal_tri_1)~margination_quintile, subset(prenatal.data, deaths>=3), mean)
imss.v.sp.prenatal.tri.1.2 <- melt(imss.v.sp.prenatal.tri.1, id.vars="margination_quintile", variable.name="insurance", value.name="mean")
ggplot(imss.v.sp.prenatal.tri2, aes(as.factor(margination_quintile), mean, fill=as.factor(insurance))) + geom_bar(stat="identity", position="dodge") + nice_theme + 
  labs(x="Margination Quintile", y="Average Trimester of First Prenatal Consult") + scale_fill_discrete(name="Insurance", labels=c("IMSS", "Seguro Popular")) +
  coord_cartesian(ylim = c(1, 1.5)) + geom_text(aes(as.factor(margination_quintile), mean, fill=as.factor(insurance), label=round(mean,1)), position=position_dodge(width=1), vjust=-.5, size=9)
ggplot(imss.v.sp.consults2, aes(as.factor(margination_quintile), mean, fill=as.factor(insurance))) + geom_bar(stat="identity", position="dodge") + nice_theme + 
  labs(x="Margination Quintile", y="Average Number of Prenatal Consults") + scale_fill_discrete(name="Insurance", labels=c("IMSS", "Seguro Popular")) + 
  coord_cartesian(ylim = c(5, 9)) + geom_text(aes(as.factor(margination_quintile), mean, fill=as.factor(insurance), label=round(mean,1)), position=position_dodge(width=1), vjust=-.5, size=9)
ggplot(imss.v.sp.prenatal.tri.1.2, aes(as.factor(margination_quintile), mean*100, fill=as.factor(insurance))) + geom_bar(stat="identity", position="dodge") + nice_theme + 
  labs(x="Margination Quintile", y="Percent of Births with Prenatal Care in \n First Trimester") + scale_fill_discrete(name="Insurance", labels=c("IMSS", "Seguro Popular")) + 
  coord_cartesian(ylim = c(0, 100)) + geom_text(aes(as.factor(margination_quintile), mean*100, fill=as.factor(insurance), label=round(mean*100,0)), position=position_dodge(width=1), vjust=-.5, size=9)


imss.v.sp.consults2$type <- "consults"
imss.v.sp.prenatal.tri2$type <- "prenatal_tri"
imss.v.sp <- rbind(imss.v.sp.consults2, imss.v.sp.prenatal.tri2)
ggplot(imss.v.sp, aes(as.factor(margination_decile), mean, fill=as.factor(insurance))) + geom_bar(stat="identity", position="dodge") + facet_grid(type~., scales="free_y")

prenatal.test1 <- subset(prenatal.data, select=c("margination_decile", "imss_avg_prenatal_consults", "sp_avg_prenatal_consults"))
prenatal.test1 <- melt(prenatal.test1, id.vars="margination_decile", variable.name="insurance", value.name="consults")
ggplot(prenatal.test1, aes(as.factor(margination_decile), consults, fill=as.factor(insurance))) + geom_boxplot() + nice_theme + labs(x="Margination Decile", y="Average Trimester of First Prenatal Consult") + scale_fill_discrete(name="Insurance", labels=c("IMSS", "Seguro Popular"))
