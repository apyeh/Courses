# "Guess the number" mini-project
# input will come from buttons and an input field
# all output for the game will be printed in the console

import simplegui
import random
import math


# initialize global variables used in your code here
# set default number range to 0-100
num_range = 100
num_guesses = 0

# helper function to start and restart the game
def new_game():
    global num_guesses
    global num_range
    global secret_number
    
    num_guesses = int(math.ceil(math.log(num_range + 1, 2)))
    secret_number = random.randrange(1, num_range)
    print "New game! Enter a guess between 0 and %d." %num_range
    print "You have %d guesses to guess the correct number." %num_guesses
    print
 
# define event handlers for control panel

def range100():
    """ button that changes the range to [0,100) and
    starts a new game"""
    global num_range
    num_range = 100
    new_game()

def range1000():
    """ button that changes the range to [0,1000) and
    starts a new game""" 
    global num_range
    num_range = 1000
    new_game()
    
def input_guess(guess):
    global num_guesses
        
    guess = int(guess)
    print "Guess was", guess
    
    if guess == secret_number:
        print "Correct!"
        print
        new_game()
    elif secret_number < guess < num_range:
        print "Lower"
        num_guesses -= 1
        print num_guesses, "guesses remaining"
        print
    elif 0 < guess < secret_number:
        print "Higher"
        num_guesses -= 1
        print num_guesses, "guesses remaining"
        print
    else:
        print "Guess is outside of range. Please guess a number between 0 and %d." %num_range
        print
        
    if num_guesses == 0:
        print "Out of guesses.. game over. The number was %d." %secret_number
        print
        new_game()

    
# create frame
frame = simplegui.create_frame("Guess the number", 200, 200)

# create control elements for window
frame.add_button("Range is [0, 100)", range100, 200)
frame.add_button("Range is [0, 1000)", range1000, 200)
frame.add_input("Enter a guess", input_guess, 200)

frame.start()

# call new_game 
new_game()
