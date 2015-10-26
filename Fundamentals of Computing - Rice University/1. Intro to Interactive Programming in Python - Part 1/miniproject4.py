# Implementation of classic arcade game Pong

import simplegui
import random

# initialize globals - pos and vel encode vertical info for paddles
WIDTH = 600
HEIGHT = 400       
BALL_RADIUS = 20
PAD_WIDTH = 8
PAD_HEIGHT = 80
HALF_PAD_WIDTH = PAD_WIDTH / 2
HALF_PAD_HEIGHT = PAD_HEIGHT / 2
LEFT = False
RIGHT = True

acc = 8 # acceleration of paddles in pixels per update (1/60 seconds)

ball_pos = [WIDTH / 2, HEIGHT / 2]
ball_vel = [5, 0] # pixels per update (1/60 seconds)

paddle1_pos = HEIGHT /2 - PAD_HEIGHT /2
paddle2_pos = HEIGHT /2 - PAD_HEIGHT /2
paddle1_vel = [0, 0]
paddle2_vel = [0, 0]

score1 = 0
score2 = 0

# initialize ball_pos and ball_vel for new bal in middle of table
# if direction is RIGHT, the ball's velocity is upper right, else upper left

def spawn_ball(direction):
    global ball_pos, ball_vel # these are vectors stored as lists
    ball_pos = [WIDTH / 2, HEIGHT / 2]
    ball_vel = [2, 0]
    
    if direction == RIGHT:
        ball_vel[0] = random.randrange(120, 240)/60 # pixels per update (1/60 seconds)
        ball_vel[1] = - random.randrange(60, 180)/60 # pixels per update (1/60 seconds)
    elif direction == LEFT:
        ball_vel[0] = - random.randrange(120, 240)/60 # pixels per update (1/60 seconds)
        ball_vel[1] = - random.randrange(60, 180)/60 # pixels per update (1/60 seconds)
        
# define event handlers
def new_game():
    global paddle1_pos, paddle2_pos, paddle1_vel, paddle2_vel  # these are numbers
    global score1, score2  # these are ints
    # reset scores
    score1 = 0
    score2 = 0
    # reset paddle positions
    paddle1_pos = HEIGHT /2 - PAD_HEIGHT /2
    paddle2_pos = HEIGHT /2 - PAD_HEIGHT /2
    # spawn ball
    spawn_ball(random.choice([LEFT, RIGHT]))
    
def draw(canvas):
    global score1, score2, paddle1_pos, paddle2_pos, ball_pos, ball_vel
    global paddle1_vel, paddle2_vel
 
    # draw mid line and gutters
    canvas.draw_line([WIDTH / 2, 0],[WIDTH / 2, HEIGHT], 1, "White")
    canvas.draw_line([PAD_WIDTH, 0],[PAD_WIDTH, HEIGHT], 1, "White")
    canvas.draw_line([WIDTH - PAD_WIDTH, 0],[WIDTH - PAD_WIDTH, HEIGHT], 1, "White")
        
    # update ball position
    ball_pos[0] += ball_vel[0]
    ball_pos[1] += ball_vel[1]

    # collide and reflect off of top hand bottom of canvas
    if ball_pos[1] <= BALL_RADIUS or ball_pos[1] >= (HEIGHT - BALL_RADIUS):
        ball_vel[1] = - ball_vel[1]
    
    # draw ball
    canvas.draw_circle(ball_pos, BALL_RADIUS, 2, "Yellow", "Yellow")
    
    # update paddle's vertical position, keep paddle on the screen
    paddle1_pos_update = paddle1_pos + paddle1_vel[1]
    paddle2_pos_update = paddle2_pos + paddle2_vel[1]
    
    if paddle1_pos_update >= -5 and paddle1_pos_update <= (HEIGHT - PAD_HEIGHT):
        paddle1_pos += paddle1_vel[1]
        
    if paddle2_pos_update >= -5 and paddle2_pos_update <= (HEIGHT - PAD_HEIGHT):
        paddle2_pos += paddle2_vel[1]
    
    # draw paddles
    canvas.draw_line((HALF_PAD_WIDTH, paddle1_pos), (HALF_PAD_WIDTH, paddle1_pos + PAD_HEIGHT), PAD_WIDTH, 'Red')
    canvas.draw_line((WIDTH - HALF_PAD_WIDTH, paddle2_pos), (WIDTH - HALF_PAD_WIDTH, paddle2_pos + PAD_HEIGHT), PAD_WIDTH, 'Blue')

    # determine whether paddle and ball collide    
    if ball_pos[0] <= BALL_RADIUS + PAD_WIDTH:  # left gutter
        if paddle1_pos - BALL_RADIUS <= ball_pos[1] <= paddle1_pos + PAD_HEIGHT + BALL_RADIUS: # left paddle
            ball_vel[0] = -ball_vel[0] * 1.1 # increase ball velocity by 10% after each paddle strike
        else:
            score2 += 1
            spawn_ball(RIGHT)
            
    elif ball_pos[0] >= WIDTH - BALL_RADIUS - PAD_WIDTH:  # right gutter
        if paddle2_pos - BALL_RADIUS <= ball_pos[1] <= paddle2_pos + PAD_HEIGHT + BALL_RADIUS: # right paddle
            ball_vel[0] = -ball_vel[0] * 1.1 # increase ball velocity by 10% after each paddle strike
        else:
            score1 += 1
            spawn_ball(LEFT)
    
    # draw scores
    canvas.draw_text(str(score1), (WIDTH / 2 - 75, 100), 42, 'Red', 'sans-serif')
    canvas.draw_text(str(score2), (WIDTH / 2 + 50, 100), 42, 'Blue', 'sans-serif')
    
def keydown(key):
    global paddle1_vel, paddle2_vel, acc
    if key==simplegui.KEY_MAP["w"]:
        paddle1_vel[1] -= acc
    elif key==simplegui.KEY_MAP["s"]:
        paddle1_vel[1] += acc
    elif key==simplegui.KEY_MAP["up"]:
        paddle2_vel[1] -= acc
    elif key==simplegui.KEY_MAP["down"]:
        paddle2_vel[1] += acc
    
def keyup(key):
    global paddle1_vel, paddle2_vel, acc
    if key==simplegui.KEY_MAP["w"]:
        paddle1_vel[1] = 0
    elif key==simplegui.KEY_MAP["s"]:
        paddle1_vel[1] = 0
    elif key==simplegui.KEY_MAP["up"]:
        paddle2_vel[1] = 0
    elif key==simplegui.KEY_MAP["down"]:
        paddle2_vel[1] = 0

def button_handler():
    new_game()

# create frame
frame = simplegui.create_frame("Pong", WIDTH, HEIGHT)
frame.set_draw_handler(draw)
frame.set_keydown_handler(keydown)
frame.set_keyup_handler(keyup)
frame.add_button('Restart', button_handler, 100)

# start frame
new_game()
frame.start()