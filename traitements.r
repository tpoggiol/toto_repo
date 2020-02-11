# Chargement des packages et librairies

#install.packages("RPostgreSQL", repos='http://cran.us.r-project.org')
library(RPostgreSQL)
#install.packages("dplyr", repos='http://cran.us.r-project.org')
library(dplyr)

# Connection a la base de donnees Postgres

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "lizmap", host = "localhost", port = 5432, user = "postgres", password = "postgres")

# Recuperation des colonnes de la table en BDD

data_sel <- dbGetQuery(con, 
"
	 select gid, osm_id, code, fclass, name, gestionnaire, note_public, note_critique, type_critique, occupation  
	 from poi84 where code in (select code from poi84 group by fclass, code having count(fclass) > 100);
")

variance <- aov(occupation ~ fclass , data=data_sel)
summary(variance)

group_by(data_sel, fclass) %>%
	summarise(
		mean = mean(occupation, na.rm = TRUE),
)