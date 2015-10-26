# An Introduction to Interactive Programming in Python (Part 2)
# implementation of card game - Memory
# by Andrew Yeh

import simplegui
import random

# state keeps track of how many cards are exposed
state = 0

# turns keeps track of the number of turns taken
turns = 0

# create deck of cards
num_cards = 16
list1 = range(1, num_cards/2 + 1)
list2 = range(1, num_cards/2 + 1)
deck = list1 + list2

# load card images; each image is 265 x 426 pixels
img_1 = simplegui.load_image("http://googledrive.com/host/0B6hSlLWW-BjQfmI5ekVoRUg3T21pWngwcmRzOFJHX19EUGtFWTVtMmVaUWVUc25QaTZ6X3c/1H.png")
img_2 = simplegui.load_image("http://googledrive.com/host/0B6hSlLWW-BjQfmI5ekVoRUg3T21pWngwcmRzOFJHX19EUGtFWTVtMmVaUWVUc25QaTZ6X3c/2H.png")
img_3 = simplegui.load_image("http://googledrive.com/host/0B6hSlLWW-BjQfmI5ekVoRUg3T21pWngwcmRzOFJHX19EUGtFWTVtMmVaUWVUc25QaTZ6X3c/3H.png")
img_4 = simplegui.load_image("http://googledrive.com/host/0B6hSlLWW-BjQfmI5ekVoRUg3T21pWngwcmRzOFJHX19EUGtFWTVtMmVaUWVUc25QaTZ6X3c/4H.png")
img_5 = simplegui.load_image("http://googledrive.com/host/0B6hSlLWW-BjQfmI5ekVoRUg3T21pWngwcmRzOFJHX19EUGtFWTVtMmVaUWVUc25QaTZ6X3c/5H.png")
img_6 = simplegui.load_image("http://googledrive.com/host/0B6hSlLWW-BjQfmI5ekVoRUg3T21pWngwcmRzOFJHX19EUGtFWTVtMmVaUWVUc25QaTZ6X3c/6H.png")
img_7 = simplegui.load_image("http://googledrive.com/host/0B6hSlLWW-BjQfmI5ekVoRUg3T21pWngwcmRzOFJHX19EUGtFWTVtMmVaUWVUc25QaTZ6X3c/7H.png")
img_8 = simplegui.load_image("http://googledrive.com/host/0B6hSlLWW-BjQfmI5ekVoRUg3T21pWngwcmRzOFJHX19EUGtFWTVtMmVaUWVUc25QaTZ6X3c/8H.png")

img_width = 265
img_height = 426

# scale down card image size by this factor
scale = 4

# canvas size
can_width = img_width // scale * num_cards
can_height = img_height // scale

# card size
card_size = [img_width // scale, img_height // scale]

# randomly shuffle the deck
random.shuffle(deck)							

# list to keep track of whether or not cards are exposed
exposed = [False] * num_cards

# helper function to initialize globals
def new_game():
    global exposed, state, turns
    state = 0						# reset state to zero
    random.shuffle(deck)			# shuffle the deck of cards
    turns = 0						# reset turns to zero.
    label.set_text("Turns = 0")
    exposed = [False] * num_cards	# reset all cards to not being exposed

# define event handlers
def mouseclick(pos):
    global click_pos, card1_idx, card2_idx, state, turns

    click_pos = list(pos)
    clicked_card_idx = click_pos[0] // card_size[0]
    
    if state == 0:					# no cards are exposed
        if not exposed[clicked_card_idx]:
            card1_idx = clicked_card_idx
            exposed[card1_idx] = True
            state = 1           
    elif state == 1:				# 1 card is exposed
        if not exposed[clicked_card_idx]:
            card2_idx = clicked_card_idx
            exposed[card2_idx] = True
            state = 2
            turns += 1
            turns_label = "Turns = %d" %turns
            label.set_text(turns_label)         
    else:							# 2 cards are exposed
        if not exposed[clicked_card_idx]:
            if deck[card1_idx] != deck[card2_idx]:
                exposed[card1_idx] = False
                exposed[card2_idx] = False            
            card1_idx = clicked_card_idx
            exposed[card1_idx] = True
            state = 1

# draw cards   
def draw(canvas):
    for card_idx in range(len(deck)):
        if exposed[card_idx]:
            card = deck[card_idx]
            img_center = [img_width/2, img_height/2]
            img_size = [img_width, img_height]
            card_center = [card_idx * card_size[0] + card_size[0]/2, card_size[1]/2]
            if card == 1:
                canvas.draw_image(img_1, img_center, img_size, card_center, card_size)
            elif card == 2:
                canvas.draw_image(img_2, img_center, img_size, card_center, card_size)
            elif card == 3:
                canvas.draw_image(img_3, img_center, img_size, card_center, card_size)
            elif card == 4:
                canvas.draw_image(img_4, img_center, img_size, card_center, card_size)
            elif card == 5:
                canvas.draw_image(img_5, img_center, img_size, card_center, card_size)
            elif card == 6:
                canvas.draw_image(img_6, img_center, img_size, card_center, card_size)
            elif card == 7:
                canvas.draw_image(img_7, img_center, img_size, card_center, card_size)
            elif card == 8:
                canvas.draw_image(img_8, img_center, img_size, card_center, card_size)                
        else:
            card_pos_x = card_idx * card_size[0] + card_size[0]/2
            canvas.draw_line([card_pos_x, 0], [card_pos_x, can_height], card_size[0] - 2, 'Green')

# create frame and add a button and labels
frame = simplegui.create_frame("Memory", can_width, can_height)
frame.add_button("Reset", new_game)
label = frame.add_label("Turns = 0")

# register event handlers
frame.set_mouseclick_handler(mouseclick)
frame.set_draw_handler(draw)

# get things rolling
new_game()
frame.start()