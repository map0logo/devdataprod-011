library(xlsx)
library(lubridate)
# Data taken from http://www.ine.gob.ve/documentos/Economia/IndicedePreciosalconsumidor/xls/PorCiudades/4_6_3.xls
wb <- loadWorkbook("4_6_3.xls")

numberOfSheets <- wb$getNumberOfSheets()
sheets <- getSheets(wb)
sheetsNames <- names(sheets)
sheetsNames[72: 75] <- c("Abr-2008", "Mar-2008", "Feb-2008", "Ene-2008")
sheetsNames <- tolower(sheetsNames)

library(zoo)
dates <- as.Date(as.yearmon(sheetsNames, "%b-%Y"))
rm(data)
data <- read.xlsx2(file = "4_6_3.xls", sheetIndex = 1,
                   startRow = 11, endRow = 25, header = TRUE)
data$date <- dates[1]

for (sheetIdx in 2:numberOfSheets){
    if (sheetIdx >=60 & sheetIdx <= 73){
        df <- read.xlsx2(file = "4_6_3.xls", sheetIndex = sheetIdx,
                         startRow = 12, endRow = 26, header = TRUE)
    } else {
        df <- read.xlsx2(file = "4_6_3.xls", sheetIndex = sheetIdx,
                         startRow = 11, endRow = 25, header = TRUE)
    }
    df$date <- dates[sheetIdx]
    names(df) <- names(data)
    data <- rbind(data, df)
}

# remove trailing blanks
group <- toupper(gsub("[[:space:]]*$", "", data$X.))
# toupper fix misstyped "General" to "GENERAL"
data$group <- as.factor(group)
data$X. <- NULL

# gsub() remove commas used as decimal separators, as.numeric() removes blanks
data$Nacional <- as.numeric(gsub(",", ".", as.character(data$Nacional)))
data$Caracas <- as.numeric(gsub(",", ".", as.character(data$Caracas)))
data$Maracay <- as.numeric(gsub(",", ".", as.character(data$Maracay)))
data$Ciudad..Guayana <- as.numeric(gsub(",", ".", as.character(data$Ciudad..Guayana)))
data$Barcelona.Puerto.La.Cruz <- as.numeric(gsub(",", ".", as.character(data$Barcelona.Puerto.La.Cruz)))
data$Valencia <- as.numeric(gsub(",", ".", as.character(data$Valencia)))
data$Barquisimeto <- as.numeric(gsub(",", ".", as.character(data$Barquisimeto)))
data$Maracaibo <- as.numeric(gsub(",", ".", as.character(data$Maracaibo)))
data$Mérida <- as.numeric(gsub(",", ".", as.character(data$Mérida)))
data$Maturín <- as.numeric(gsub(",", ".", as.character(data$Maturín)))
data$San.Cristóbal <- as.numeric(gsub(",", ".", as.character(data$San.Cristóbal)))
data$Resto..Nacional <- as.numeric(gsub(",", ".", as.character(data$Resto..Nacional)))

save(data, file = "data.Rdata")
