# An Introduction to Interactive Programming in Python (Part 2)
# Mini-project #6 - Blackjack
# by Andrew Yeh

import simplegui
import random

# load card sprite - 936x384 - source: jfitz.com
CARD_SIZE = (72, 96)
CARD_CENTER = (36, 48)
card_images = simplegui.load_image("http://storage.googleapis.com/codeskulptor-assets/cards_jfitz.png")

CARD_BACK_SIZE = (72, 96)
CARD_BACK_CENTER = (36, 48)
card_back = simplegui.load_image("http://storage.googleapis.com/codeskulptor-assets/card_jfitz_back.png")    

# initialize some useful global variables
in_play = False
outcome = ""
score_dealer = 0
score_player = 0

# define globals for cards
SUITS = ('C', 'S', 'H', 'D')
RANKS = ('A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K')
VALUES = {'A':1, '2':2, '3':3, '4':4, '5':5, '6':6, '7':7, '8':8, '9':9, 'T':10, 'J':10, 'Q':10, 'K':10}

# define card class
class Card:
    def __init__(self, suit, rank):
        if (suit in SUITS) and (rank in RANKS):
            self.suit = suit
            self.rank = rank
        else:
            self.suit = None
            self.rank = None
            print "Invalid card: ", suit, rank

    def __str__(self):
        return self.suit + self.rank

    def get_suit(self):
        return self.suit

    def get_rank(self):
        return self.rank

    def draw(self, canvas, pos):
        card_loc = (CARD_CENTER[0] + CARD_SIZE[0] * RANKS.index(self.rank), 
                    CARD_CENTER[1] + CARD_SIZE[1] * SUITS.index(self.suit))
        canvas.draw_image(card_images, card_loc, CARD_SIZE, [pos[0] + CARD_CENTER[0], pos[1] + CARD_CENTER[1]], CARD_SIZE)
        
# define hand class
class Hand:
    def __init__(self):
        # create Hand object
        self.hand = []

    def __str__(self):
        # return a string representation of a hand
        hand = ""
        for card in self.hand:
            hand += str(card) + " "
        return 'hand contains ' + hand

    def add_card(self, card):
        # add a card object to a hand
        self.hand.append(card)

    def get_value(self):
        # count aces as 1, if the hand has an ace, then add 10 to hand value if it doesn't bust
        # compute the value of the hand, see Blackjack video
        hand_value = 0
        rank_list = []
        for card in self.hand:
            rank = card.get_rank()
            rank_list.append(rank) 
            hand_value += VALUES[rank]
        
        if 'A' not in rank_list:
            return hand_value
        else:
            if hand_value + 10 <= 21:
                return hand_value + 10
            else:
                return hand_value
            
    def draw(self, canvas, pos):
        # draw a hand on the canvas, use the draw method for cards
        card_num = 0
        for card in self.hand:
            rank = card.get_rank()
            suit = card.get_suit()
            card_loc = (CARD_CENTER[0] + CARD_SIZE[0] * RANKS.index(rank), 
                    CARD_CENTER[1] + CARD_SIZE[1] * SUITS.index(suit))
            card.draw(canvas, [pos[0] + CARD_SIZE[0] * card_num * 1.15, pos[1]])
            card_num += 1
        
# define deck class 
class Deck:
    def __init__(self):
        # create a Deck object
        self.deck = []
        [self.deck.append(Card(suit, rank)) for suit in SUITS for rank in RANKS]
       
    def shuffle(self):
        # shuffle the deck using random.shuffle()
        random.shuffle(self.deck)
        
    def deal_card(self):
        # deal a card object from the deck
        return self.deck.pop()
    
    def __str__(self):
        # return a string representation of a deck
        deck = ""
        for card in self.deck:
            deck += str(card) + " "
        return 'deck contains ' + deck

#define event handlers for buttons
def deal():
    global outcome, in_play, deck, hand_dealer, hand_player, score_dealer, question

    # if "Deal" button is clicked during the middle of a round, dealer wins.
    if in_play:
        outcome = "Dealer wins."
        score_dealer += 1
        in_play = False   
    else:
        outcome = ""
        
        # create the deck of cards & shuffle the deck
        deck = Deck()
        deck.shuffle()
    
        # initialize dealer & player hands
        hand_dealer = Hand()
        hand_player = Hand()
        num_cards = 2
        
        # deal cards to both dealer and player
        for i in range(num_cards):
            hand_dealer.add_card(deck.deal_card())
            hand_player.add_card(deck.deal_card())    
#	        print "Dealer's", hand_dealer
#	        print "Player's", hand_player
    
        # player's hand is in play    
        in_play = True

def hit():
    global in_play, outcome, score_dealer

    # if the hand is in play, hit the player
    if in_play:
        if hand_player.get_value() <= 21:
            hand_player.add_card(deck.deal_card())
#            print hand_player
            
    # if busted, assign a message to outcome, update in_play and score
        if hand_player.get_value() > 21:
            outcome = "Sorry, you busted. Dealer wins."
            score_dealer += 1
            in_play = False
    
def stand():
    global in_play, outcome, score_dealer, score_player

    # if player has already busted, return reminder that that's the case.
    if hand_player.get_value() > 21:
        outcome = "Sorry, you busted. Dealer wins."   

    # if hand is in play, repeatedly hit dealer until his hand has value 17 or more
    elif in_play:
        while hand_dealer.get_value() < 17:
            hand_dealer.add_card(deck.deal_card())
#          	 print "Dealer's", hand_dealer
                
        # determine outcome, update in_play and score
        if hand_dealer.get_value() > 21:
            outcome = "Dealer busted. You win!"
            score_player += 1
            in_play = False
        else:
            if hand_player.get_value() < hand_dealer.get_value():
                outcome = "Dealer wins."
                score_dealer += 1
                in_play = False
            elif hand_player.get_value() == hand_dealer.get_value():
                outcome = "Tied. Dealer wins."
                score_dealer += 1
                in_play = False
            else:
                outcome = "You win!"
                score_player += 1
                in_play = False
    
# draw handler    
def draw(canvas):
    global in_play
    
    dealer_color = 'Orange'
    player_color = 'Cyan'

    dealer_pos = [100, 225]
    player_pos = [100, 425]
    hand_dealer.draw(canvas, dealer_pos)
    hand_player.draw(canvas, player_pos)
    
    # Title of game, indicator of which cards belong to dealer and player
    canvas.draw_text('BLACKJACK', [180, 50], 40, 'Black', 'sans-serif')
    if in_play:
        canvas.draw_text('Dealer', [dealer_pos[0], dealer_pos[1] - 25], 24, dealer_color, 'sans-serif')
    else:
        canvas.draw_text('Dealer has ' + str(hand_dealer.get_value()) + '.', [dealer_pos[0], dealer_pos[1] - 25], 24, dealer_color, 'sans-serif')        
    canvas.draw_text('Player has ' + str(hand_player.get_value()) + ':', [player_pos[0], player_pos[1] - 25], 24, player_color, 'sans-serif')

    # Questions to ask depending on if player's hand is still being played
    # Also, draw the back side of a card over dealer's hole card if player's hand
    # is still being played
    if in_play:
        question = 'Hit or Stand?'
        canvas.draw_image(card_back, [CARD_BACK_CENTER[0] + CARD_BACK_SIZE[0], CARD_BACK_CENTER[1]], CARD_BACK_SIZE, [dealer_pos[0] + CARD_CENTER[0], dealer_pos[1] + CARD_CENTER[1]], CARD_BACK_SIZE)
    else:
        question = 'New deal?'
        
    # Display what the outcome of round of play is    
    canvas.draw_text(question, [player_pos[0] + 165, player_pos[1] - 25], 24, player_color, 'sans-serif')
    canvas.draw_text(outcome, [player_pos[0], 150], 24, 'White', 'sans-serif')

    # Display dealer & player scores 
    canvas.draw_text("SCORE: ", [180, 90], 24, 'Black', 'sans-serif')
    canvas.draw_line([280, 82] , [325, 82], 35, dealer_color)
    canvas.draw_line([335, 82] , [380, 82], 35, player_color)
    canvas.draw_text(str(score_dealer), [290, 90], 24, 'Black', 'sans-serif')
    canvas.draw_text(str(score_player), [345, 90], 24, 'Black', 'sans-serif')
    
# initialization frame
frame = simplegui.create_frame("Blackjack", 600, 600)
frame.set_canvas_background("Green")

#create buttons and canvas callback
frame.add_button("Deal", deal, 200)
frame.add_button("Hit",  hit, 200)
frame.add_button("Stand", stand, 200)
frame.set_draw_handler(draw)


# get things rolling
deal()
frame.start()


# remember to review the gradic rubric