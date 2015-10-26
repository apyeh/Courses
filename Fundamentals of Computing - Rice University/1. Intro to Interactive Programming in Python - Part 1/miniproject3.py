# "Stopwatch: The Game"

# everytime stopwatch ticks (0.1s), global variable counter
# should be updated by 1.

import simplegui

# define global variables
t = 0
interval = 100
position_score = [150, 25]
x = 0
y = 0
A = 0
B = 0
C = 0
D = 0
score = str(x) + "/" + str(y)
position_time = [60, 110]
timer_in_progress = False


# define helper function format that converts time
# in tenths of seconds into formatted string A:BC.D
def format(t):
    global A, B, C, D
    # obtain digit corresponding to minutes
    A = t // 600
    # obtain digit corresponding to tens of seconds
    B = ((t // 10) % 60) // 10
    # obtain digit corresponding to single seconds
    C = ((t // 10) % 60) % 10
    # obtain digit corresponding to tenths of seconds
    D = int(round((t / 10.0 - int(t / 10.0)) * 10))
    time = str(A) + ":" + str(B) + str(C) + "." + str(D)
    return time

# define event handlers for buttons; "Start", "Stop", "Reset"
def start():
    timer.start()
    
def stop():
    global score
    timer_in_progress = timer.is_running()
    """ update score only if timer is running when 'stop'
    button is pressed."""
    if timer_in_progress:
        timer.stop()
        score = update_score()
 
def reset():
    global t, x, y, score
    timer.stop()
    t = 0
    x = 0
    y = 0
    score = str(x) + "/" + str(y)

# define scoring portion
def update_score():
    global D, x, y
    y += 1
    if D == 0: x += 1
    score = str(x) + "/" + str(y)
    return score

# define event handler for timer with 0.1 sec interval
def timer_handler():
    global t, A
    """ Set max time that timer can run to 10 minutes. If less
    than 10 minutes, update global counter t by 1 for every time
    stopwatch ticks """
    if A < 10:
        t += 1
        format(t)
    else:
        timer.stop()
        
# define draw handler
def draw(canvas):
    canvas.draw_text(score, position_score, 24, "Green")
    """ if less than 10 minutes, text is white, else if timer has
    reached 10 minutes, text is red."""
    if A < 10:
        text_color = "White"
    else:
        text_color = "Red"
    canvas.draw_text(format(t), position_time, 36, text_color)
        
# create frame
frame = simplegui.create_frame("Stopwatch", 200, 200)
timer = simplegui.create_timer(interval, timer_handler)

# register event handlers
frame.add_button("Start", start, 75)
frame.add_button("Stop", stop, 75)
frame.add_button("Reset", reset, 75)
frame.set_draw_handler(draw)


# start frame
frame.start()

# Please remember to review the grading rubric
