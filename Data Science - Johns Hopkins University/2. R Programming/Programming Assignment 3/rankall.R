# R Programming
# Programming Assignment 3, Part 4
# by Andrew Yeh

## The "rankhall" function returns hospitals by desired ranking
## in a particular outcome for all states
## The arguments are the outcome and desired ranking.

rankall <- function(outcome, num = "best") {
        ## Read outcome data
        ## Check that state and outcome are valid
        ## For each state, find the hospital of the given rank
        ## Return a data frame with the hospital names and the
        ## (abbreviated) state name
}

rankall <- function(outcome, num = "best") {

        ## Read outcome data
        data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        valid_states <- sort(unique(data[,7]))
        
        valid_outcomes <- c("heart attack", "heart failure", "pneumonia")
        
        ## Check that outcome is valid
        if (outcome %in% valid_outcomes == FALSE) {
                stop("invalid outcome")
        }
                
        ## Select column for the selected outcome
        column_outcome <- switch(outcome, "heart attack"=11, "heart failure"=17, "pneumonia"=23)
                       
        ## Order hospitals based on outcome ranking first and then alphabetical order
              
        ## Initialize vector to hold hospital names
        hospital <- character(0)
                
        for (i in seq_along(valid_states)) {
                            
                ## Select data for the state
                data_state <- subset(data, State == valid_states[i])
        
                ## Remove rows that do not have available data for selected outcome                
                data_state_nna <- data_state[data_state[,column_outcome] != "Not Available",]
                                
                outcome_values <- as.numeric(data_state_nna[[column_outcome]])
                        
                hospital_names <- data_state_nna[["Hospital.Name"]]
        
                data_state_nna_sorted <- data_state_nna[order(outcome_values, hospital_names, decreasing = FALSE, na.last=NA), ]
                
                ## Convert num to numerical value if num = either "best"or "worst"
                this.num = num
                if (this.num == "best") this.num = 1
                if (this.num == 'worst') this.num = nrow(data_state_nna_sorted)
                
                hospital[i] <- data_state_nna_sorted[this.num,2]
        }
        data.frame(hospital=hospital, state=valid_states, row.names=valid_states)
}