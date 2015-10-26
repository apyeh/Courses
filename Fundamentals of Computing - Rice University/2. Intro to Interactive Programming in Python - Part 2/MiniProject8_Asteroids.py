# program template for Spaceship
import simplegui
import math
import random

# globals for user interface
WIDTH = 800
HEIGHT = 600
score = 0
lives = 3
time = 0
ANGLE_ACC = 0.15				# incremental amount that angular velocity in increased by 
VEL_ACC = 0.2					# acceleration factor for the velocity vector
FRICTION = 0.02					# friction constant to dampen velocity vector
ASTEROID_VEL = 3				# maximum asteroid velocity
ASTEROID_ANGLE_VEL = 2			# maximum asteroid angular velocity
MISSILE_ACC = 10				# acceleration factor for the missile velocity vector
LIVES_POS = [50, 50]			# position of Lives text
SCORE_POS = [WIDTH - 125, 50]	# position of Score text

class ImageInfo:
    def __init__(self, center, size, radius = 0, lifespan = None, animated = False):
        self.center = center
        self.size = size
        self.radius = radius
        if lifespan:
            self.lifespan = lifespan
        else:
            self.lifespan = float('inf')
        self.animated = animated

    def get_center(self):
        return self.center

    def get_size(self):
        return self.size

    def get_radius(self):
        return self.radius

    def get_lifespan(self):
        return self.lifespan

    def get_animated(self):
        return self.animated

    
# art assets created by Kim Lathrop, may be freely re-used in non-commercial projects, please credit Kim
    
# debris images - debris1_brown.png, debris2_brown.png, debris3_brown.png, debris4_brown.png
#                 debris1_blue.png, debris2_blue.png, debris3_blue.png, debris4_blue.png, debris_blend.png
debris_info = ImageInfo([320, 240], [640, 480])
debris_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/debris2_blue.png")

# nebula images - nebula_brown.png, nebula_blue.png
nebula_info = ImageInfo([400, 300], [800, 600])
nebula_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/nebula_blue.f2014.png")

# splash image
splash_info = ImageInfo([200, 150], [400, 300])
splash_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/splash.png")

# ship image
ship_info = ImageInfo([45, 45], [90, 90], 35)
ship_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/double_ship.png")

# missile image - shot1.png, shot2.png, shot3.png
missile_info = ImageInfo([5,5], [10, 10], 3, 50)
missile_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/shot2.png")

# asteroid images - asteroid_blue.png, asteroid_brown.png, asteroid_blend.png
asteroid_info = ImageInfo([45, 45], [90, 90], 40)
asteroid_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/asteroid_blue.png")

# animated explosion - explosion_orange.png, explosion_blue.png, explosion_blue2.png, explosion_alpha.png
explosion_info = ImageInfo([64, 64], [128, 128], 17, 24, True)
explosion_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/explosion_alpha.png")

# sound assets purchased from sounddogs.com, please do not redistribute
soundtrack = simplegui.load_sound("http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/soundtrack.mp3")
missile_sound = simplegui.load_sound("http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/missile.mp3")
missile_sound.set_volume(.5)
ship_thrust_sound = simplegui.load_sound("http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/thrust.mp3")
explosion_sound = simplegui.load_sound("http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/explosion.mp3")

# helper functions to handle transformations
def angle_to_vector(ang):
    return [math.cos(ang), math.sin(ang)]

def dist(p,q):
    return math.sqrt((p[0] - q[0]) ** 2+(p[1] - q[1]) ** 2)

# Ship class
class Ship:
    def __init__(self, pos, vel, angle, image, info):
        self.pos = [pos[0],pos[1]]
        self.vel = [vel[0],vel[1]]
        self.thrust = False
        self.angle = angle
        self.angle_vel = 0
        self.image = image
        self.image_center = info.get_center()
        self.image_size = info.get_size()
        self.radius = info.get_radius()
        
    def draw(self,canvas):
        if self.thrust == False:
            canvas.draw_image(ship_image, ship_info.get_center(), ship_info.get_size(),
                  self.pos, self.image_size, self.angle)
        elif self.thrust == True:
            ship_center = [ship_info.get_center()[0] + ship_info.get_size()[0], ship_info.get_center()[1]]
            canvas.draw_image(ship_image, ship_center , ship_info.get_size(),
                  self.pos, self.image_size, self.angle)
        
    def update(self):
        global forward
        
        # update ship's position
        self.pos[0] += self.vel[0]
        self.pos[1] += self.vel[1]

        # wrap ship's position around screen when ship moves off screen edge
        self.pos[0] %= WIDTH
        self.pos[1] %= HEIGHT

        # update ship's angle
        self.angle += self.angle_vel
    
        # update ship's forward vector
        forward = angle_to_vector(self.angle)
        
        # update ship velocity's thrust component
        if self.thrust == True:
            self.vel[0] += forward[0] * VEL_ACC
            self.vel[1] += forward[1] * VEL_ACC
 
        # update ship velocity's friction component
        self.vel[0] *= (1 - FRICTION)
        self.vel[1] *= (1 - FRICTION)
        
    def increment_angle_vel(self, angle_acc):
        self.angle_vel += angle_acc

    def decrement_angle_vel(self, angle_acc):
        self.angle_vel = angle_acc

    # sets thruster to on/off    
    def thrusters_on(self, thrusters_on = False):
        if thrusters_on:
            self.thrust = True
            ship_thrust_sound.play()
        elif not thrusters_on:
            self.thrust = False
            ship_thrust_sound.rewind()

    # shoot missile 
    def shoot(self):
        global forward, a_missile
        
        # missile's position       
        a_missile.pos[0] = self.pos[0] + forward[0] * self.radius
        a_missile.pos[1] = self.pos[1] + forward[1] * self.radius
        
        # missile's velocity
        a_missile.vel[0] = self.vel[0] + forward[0] * MISSILE_ACC
        a_missile.vel[1] = self.vel[1] + forward[1] * MISSILE_ACC
        
        missile_sound.play()
        
# Sprite class
class Sprite:
    def __init__(self, pos, vel, ang, ang_vel, image, info, sound = None):
        self.pos = [pos[0],pos[1]]
        self.vel = [vel[0],vel[1]]
        self.angle = ang
        self.angle_vel = ang_vel
        self.image = image
        self.image_center = info.get_center()
        self.image_size = info.get_size()
        self.radius = info.get_radius()
        self.lifespan = info.get_lifespan()
        self.animated = info.get_animated()
        self.age = 0
        if sound:
            sound.rewind()
            sound.play()
   
    def draw(self, canvas):
        # draw asteroid
        canvas.draw_image(asteroid_image, asteroid_info.get_center(), asteroid_info.get_size(),
                  self.pos, self.image_size, self.angle)
        # draw missile
        canvas.draw_image(missile_image, missile_info.get_center(), missile_info.get_size(),
                  a_missile.pos, a_missile.image_size)
        
    def update(self):
        # update asteroid's position
        self.pos[0] += self.vel[0]
        self.pos[1] += self.vel[1]

        # wrap asteroid's position around screen when ship moves off screen edge
        self.pos[0] %= WIDTH
        self.pos[1] %= HEIGHT

        # update asteroid's angle
        self.angle += self.angle_vel

    def collide(self, sprite2)
        sprite1.collide(sprite2)
        self.pos
        self.radius
        sprite2.get_pos()
        sprite2.get_radius()
        return True / False
    
    
    ship
    rocks (set)
    missiles (set)
    collisions:
        ship - rock
        missile - rock
    rock.collide(ship) -- true / false
    
    rock/ship collide:
    def group_collide(group, x)    
        for rock in group
            if rock.collide(ship):
                rock_set.remove(rock)
        return True / False
    
    missile/rock collide:
    def group_group_collide(group1, group2)
        group_collide(group, x) - true/false
        count number of trues (= # of collisions)
    
        return # of collisions
                               
def draw(canvas):
    global time
    
    # animate background
    time += 1
    wtime = (time / 4) % WIDTH
    center = debris_info.get_center()
    size = debris_info.get_size()
    canvas.draw_image(nebula_image, nebula_info.get_center(), nebula_info.get_size(), [WIDTH / 2, HEIGHT / 2], [WIDTH, HEIGHT])
    canvas.draw_image(debris_image, center, size, (wtime - WIDTH / 2, HEIGHT / 2), (WIDTH, HEIGHT))
    canvas.draw_image(debris_image, center, size, (wtime + WIDTH / 2, HEIGHT / 2), (WIDTH, HEIGHT))
    
    # draw lives and score
    canvas.draw_text('Lives', LIVES_POS, 24, "White", 'sans-serif')
    canvas.draw_text(str(lives), [LIVES_POS[0] + 25, LIVES_POS[1] + 25], 24, "White", 'sans-serif')
    
    canvas.draw_text('Score', SCORE_POS, 24, "White", 'sans-serif')
    canvas.draw_text(str(score), [SCORE_POS[0] + 25, SCORE_POS[1] + 25], 24, "White", 'sans-serif')

    # draw ship and sprites
    my_ship.draw(canvas)
    a_rock.draw(canvas)
    a_missile.draw(canvas)
    
    # update ship and sprites
    my_ship.update()
    a_rock.update()
    a_missile.update()
            
    
# timer handler that spawns a rock every 1 second   
def rock_spawner():
    global a_rock
    
    # generate random position for asteroid
    a_rock.pos[0] = random.randrange(WIDTH)
    a_rock.pos[1] = random.randrange(HEIGHT)

    # generate random velocity for asteroid
    a_rock.vel[0] = random.randint(-ASTEROID_VEL, ASTEROID_VEL)
    a_rock.vel[1] = random.randint(-ASTEROID_VEL, ASTEROID_VEL)
    
    # generate random angular velocity for asteroid
    a_rock.angle_vel = random.randint(-ASTEROID_ANGLE_VEL, ASTEROID_ANGLE_VEL) / 10.0
    
# keydown handler
def increment_angle_left():
    my_ship.increment_angle_vel(-ANGLE_ACC)
    
def increment_angle_right():
    my_ship.increment_angle_vel(ANGLE_ACC)

def thrusters_on():
    my_ship.thrusters_on(True)

def shoot():
    my_ship.shoot()
    
keydown_inputs = {"left" : increment_angle_left, "right" : increment_angle_right,
          "up" : thrusters_on, "space" : shoot}

def keydown(key):
    [keydown_inputs[i]() for i in keydown_inputs if key == simplegui.KEY_MAP[i]]
            
# keyup handler
def decrement_angle():
    my_ship.decrement_angle_vel(0)

def thrusters_on():
    my_ship.thrusters_on(False)

keyup_inputs = {"left" : decrement_angle, "right" : decrement_angle,
          "up" : thrusters_on}

def keyup(key):
    [keyup_inputs[i]() for i in keyup_inputs if key == simplegui.KEY_MAP[i]]

# initialize frame
frame = simplegui.create_frame("Asteroids", WIDTH, HEIGHT)

# initialize ship and two sprites
my_ship = Ship([WIDTH / 2, HEIGHT / 2], [0, 0], 0, ship_image, ship_info)
a_rock = Sprite([WIDTH / 3, HEIGHT / 3], [1, 1], 0, 0, asteroid_image, asteroid_info)
#a_missile = Sprite([2 * WIDTH / 3, 2 * HEIGHT / 3], [-1,1], 0, 0, missile_image, missile_info, missile_sound)
a_missile = Sprite([2 * WIDTH / 3, 2 * HEIGHT / 3], [0,0], 0, 0, missile_image, missile_info, missile_sound)

# register handlers
frame.set_draw_handler(draw)
frame.set_keydown_handler(keydown)
frame.set_keyup_handler(keyup)

timer = simplegui.create_timer(1000.0, rock_spawner)

# get things rolling
timer.start()
frame.start()