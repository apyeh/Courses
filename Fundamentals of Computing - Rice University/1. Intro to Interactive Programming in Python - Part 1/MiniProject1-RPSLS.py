# An Introduction to Interactive Programming in Python (Part 1)
# Rock-paper-scissors-lizard-Spock
# by Andrew Yeh


# The key idea of this program is to equate the strings
# "rock", "paper", "scissors", "lizard", "Spock" to numbers
# as follows:
#
# 0 - rock
# 1 - Spock
# 2 - paper
# 3 - lizard
# 4 - scissors

# helper functions

# Import 'random' module. random.randrange will be used later in rpsls function.
import random

# Function name_to_number converts player's choice to a number

# convert name to number using if/elif/else
# don't forget to return the result!

def name_to_number(name):
    if name == "rock":
        return 0
    elif name == "Spock":
        return 1
    elif name == "paper":
        return 2
    elif name == "lizard":
        return 3
    elif name == "scissors":
        return 4
    else:
        return "Invalid entry. Try Again."

    
# Function number_to_name converts computer's number choice to a name

# convert number to a name using if/elif/else
# don't forget to return the result!
 
def number_to_name(number):
    if number == 0:
        return "rock"
    elif number == 1:
        return "Spock"
    elif number == 2:
        return "paper"
    elif number == 3:
        return "lizard"
    elif number == 4:
        return "scissors"
    else:
        return "Invalid entry. Try Again."
    
    

def rpsls(player_choice): 
    
    # print a blank line to separate consecutive games
    print
    
    # print out the message for the player's choice
    print "Player chooses", player_choice
    
    # convert the player's choice to player_number using the function name_to_number()
    player_number = name_to_number(player_choice)
    
    # check if player_number is valid
    if type(player_number) is str:
        print "Invalid entry. Try Again."
        return
    
    # compute random guess for comp_number using random.randrange()
    comp_number = random.randrange(0, 5)
    
    # convert comp_number to comp_choice using the function number_to_name()
    comp_choice = number_to_name(comp_number)
    
    # print out the message for computer's choice
    print "Computer chooses", comp_choice   
    
    # compute difference of comp_number and player_number modulo five
    pcdiff = (player_number - comp_number) % 5
    
    # use if/elif/else to determine winner, print winner message
    if pcdiff == 0:
        print "Player and computer tie!"
    elif pcdiff in (1, 2):
        print "Player wins!"
    elif pcdiff in (3, 4):
        print "Computer wins!"

        
# test the code - THESE CALLS MUST BE PRESENT IN SUBMITTED CODE
rpsls("rock")
rpsls("Spock")
rpsls("paper")
rpsls("lizard")
rpsls("scissors")

# always remember to check your completed program against the grading rubric


