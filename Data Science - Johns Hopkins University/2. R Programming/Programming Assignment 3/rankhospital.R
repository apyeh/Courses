# R Programming
# Programming Assignment 3, Part 3
# by Andrew Yeh

## The "rankhospital" function ranks hospitals by outcome in a state
## The arguments are the state, outcome, and desired ranking.

rankhospital <- function(state, outcome, num = "best") {

        ## Read outcome data
        data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        valid_states <- data[,7]
        valid_outcomes <- c("heart attack", "heart failure", "pneumonia")
        
        ## Check that state and outcome are valid
        if (state %in% valid_states == FALSE) {
                stop("invalid state")
        }
        
        if (outcome %in% valid_outcomes == FALSE) {
                stop("invalid outcome")
        }
        
        ## Select data for the selected state
        data_state <- subset(data, State == state)
        
        ## Select column for the selected outcome
        column_outcome <- switch(outcome, "heart attack"=11, "heart failure"=17, "pneumonia"=23)
        
        ## Remove rows that do not have available data for selected outcome
        data_state_nna <- data_state[data_state[,column_outcome] != "Not Available",]
        
        ## Convert num to numerical value if num = either "best"or "worst"
        num <- switch(as.character(num), "best"=1, "worst"=nrow(data_state_nna), num)
        
        ## Check if requested rank is outside of range of number of hospitals
        if (num > nrow(data_state_nna)) {
                return(NA)
        }
        else {
        ## Order hospitals based on outcome ranking first and then alphabetical order
 
                outcome_values <- as.numeric(data_state_nna[[column_outcome]])

                hospital_names <- data_state_nna[["Hospital.Name"]]
        
                data_state_nna_sorted <- data_state_nna[order(outcome_values, hospital_names, decreasing = FALSE, na.last=NA), ]

                data_state_nna_sorted[num,2]
        }
}