working_directory <- "C:/Users/chise/Desktop/matlab-analysis-on-operant-reinforcement/"
path_names <- "screen_data/line_names_Ymaze_occupancy.txt"
path_data <- "screen_data/screen_occupancy.txt"
line_names <- read.table(paste0(working_directory,path_names),header = TRUE)
effect_occupancy_compact <- read.table(paste0(working_directory,path_data),header = TRUE)

meanss <-NULL
stds <-NULL
n <-NULL

for (i in 1:length(effect_occupancy_compact)){
  
  meanss[i] <-mean(effect_occupancy_compact[,i],na.rm = TRUE)
  stds[i] <-sd(effect_occupancy_compact[,i],na.rm = TRUE)
  n[i] <-length(effect_occupancy_compact[!is.na(effect_occupancy_compact[,i]),i])
  
}

line_names$means <- meanss
line_names$std <- stds
line_names$n <- n
line_names$se <- line_names$std / sqrt(line_names$n)

line_names_clean <- line_names[c(-5,-24,-25,-29,-34,-35,-48),]
effect_occupancy_clean <- effect_occupancy_compact[,c(-5,-24,-25,-29,-34,-35,-48),]
line_names_clean$Treatment <-  ifelse(grepl("rpa1", line_names_clean$V1, ignore.case = T), "Control", ifelse (grepl("Co", line_names_clean$V1, ignore.case = T), "Control Co", "Experimental"))

line_names_clean$Treatment <- ordered(line_names_clean$Treatment, levels = c("Experimental","Control")) 

new_order <- order(line_names_clean$means, decreasing = T)
line_names_clean <- line_names_clean[new_order,]
effect_occupancy_clean <- effect_occupancy_clean[,new_order]
effect_occupancy_clean <- effect_occupancy_clean[,c(12,41,1:11,13:40)]
line_names_clean$rank <- grepl("rpa1", line_names_clean[[1]])*1
new_order <- order(line_names_clean$rank, decreasing = T)
line_names_clean <- line_names_clean[new_order,]

###### Order the Tmaze data in the way the line_names_clean table is ordered. It looks fine in the Global environment and in the plots. However opening the table the order isn?t there

levels <- as.character(line_names_clean$V1)
effect_occupancy <- NULL
effect_occupancy$Fly.line <- factor(rep(levels,each=120),levels = levels)
effect_occupancy$PI <- c(as.matrix(effect_occupancy_clean))#, mode = "numeric", length = (41*120))


# Save in vector graphics
setEPS()
postscript("Occupancy_screen_Y-mazes.eps")

barCenters <- barplot(height = line_names_clean$means,
                      names.arg = line_names_clean$V1,
                      beside = true, las = 2,ylim=c(-1,1),
                      cex.names = 0.7,
                      main = "Occupancy screen Y-mazes",
                      ylab = "Occupancy rate",
                      border = "black", axes = TRUE)

# Specify the groupings. We use srt = 45 for a
# 45 degree string rotation
text(x = barCenters, y = par("usr")[3] - 1, srt = 45,
     adj = 1, labels = line_names_clean$V1, xpd = TRUE)

segments(barCenters, line_names_clean$means - line_names_clean$se, barCenters,
         line_names_clean$means + line_names_clean$se , lwd = 1.5)


dev.off()
