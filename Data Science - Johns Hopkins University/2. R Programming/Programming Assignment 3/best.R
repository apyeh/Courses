# R Programming
# Programming Assignment 3, Part 2

## The "best" function finds the best hospital in a state for a particular outcome.
## The arguments are the state and outcome.


best <- function(state, outcome) {

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
        
        ## Return hospital name in specified state with lowest 30-day death rate
        rows_considered <- as.numeric(data_state_nna[, column_outcome])
        
        rows_min <- which(rows_considered == min(rows_considered))
        hospitals_best <- data_state_nna[rows_min, 2]
        
        ## In case of ties, return best hospital based on alphabetical order
        if (length(hospitals_best) > 1) {
                hospitals_sorted <- sort(hospitals_best)
                hospitals_sorted[1]
        }
        else {
                hospitals_best
        }
}