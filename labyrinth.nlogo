globals [
  ;Store environment config
  patch-data
  ;Observer on exit A
  arrivalA
  ;Observer on exit B
  arrivalB
  
  show-energy?
  ]
turtles-own [energy] ;; for keeping track of when the turtle is ready and when it will die


to setup
  clear-all
  ;Load the env
  load-patch-data
  ; create random grass 
  repeat 100 [ask patch random-pxcor random-pycor [set pcolor green]] 
    ; create random poison 
  repeat 10 [ask patch random-pxcor random-pycor [set pcolor violet]] 
  ;Config agent
  setup-turtles
  reset-ticks
end


;;/************************** Setting for patches ************************************/
;; This procedure loads in patch data from a file.  The format of the file is: pxcor
;; pycor pcolor.  You can view the file by opening the file PatchData.txt
to load-patch-data
  ;; We check to make sure the file exists first
  ifelse ( file-exists? "PatchData.txt" and  file-exists? "PatchDataSimple.txt")
  [
    ;; We are saving the data into a list, so it only needs to be loaded once.
    set patch-data []

    ;; This opens the file, so we can use it.
    ifelse show-signals ;Select which map to use
    [file-open "PatchData.txt"]
    [file-open "PatchDataSimple.txt"]
    
    ;; Read in all the data in the file
    while [ not file-at-end? ]
    [
      ;; file-read gives you variables.  In this case numbers.
      ;; We store them in a double list (ex [[1 1 9.9999] [1 2 9.9999] ...
      ;; Each iteration we append the next three-tuple to the current list
      set patch-data sentence patch-data (list (list file-read file-read file-read))
    ]

    user-message "File loading complete!"

    ;; Done reading in patch information.  Close the file.
    file-close
    ;Fill in the map
    show-patch-data
  ]
  [ user-message "There is no PatchData.txt or PatchDataSimple.txt file in current directory!" ]
end

;; This procedure will use the loaded in patch data to color the patches.
;; The list is a list of three-tuples where the first item is the pxcor, the
;; second is the pycor, and the third is pcolor. Ex. [ [ 0 0 5 ] [ 1 34 26 ] ... ]
to show-patch-data
  cp ct
  ifelse ( is-list? patch-data )
    [ foreach patch-data [ ask patch first ? item 1 ? [ set pcolor last ? ] ] ]
    [ user-message "You need to load in patch data first!" ]
end




to eat-grass
  ask turtles [
    if pcolor = green [
      set pcolor black
           ;; the value of energy-from-grass slider is added to energy
      set energy energy + energy-from-grass
    ]

  ]
end


to regrow-grass  ;; patch procedure

  
end


to subitdeath
  ask turtles [
  if subit_death[
  if pcolor = violet [
      set pcolor black
           ;; the value of energy of the agent is set to 0
      set energy 0 
    ]
  ]
  ]
end




;;/************************** Setting for turtles ************************************/
to setup-turtles
  set arrivalA 0
   set arrivalB 0
  create-turtles turtles_number ;; uses the value of the turtles_number slider to create turtles
  ask turtles [ 
    ;Entrance
    setxy -7 -17
    set energy 1000
    set shape "bug" 
    set color yellow
    ]
end

to move-turtles ;9.999: white 64:green 95:blue 25:orange
  ask turtles [
    ;check the color of the patch ahead ( 9.999 = white = wall, 64 = green = entrance)
     ifelse not is-patch? patch-ahead 1 or [ pcolor ] of patch-ahead 1 = 9.9999 or [ pcolor ] of patch-ahead 1 = 64
     [right random 360];Random orientatioin
     ;if the patch is blue, so it's a signal. Each signal affects the orientation
     [ifelse [ pcolor ] of patch-ahead 1 = 95
       [
         if [pxcor] of patch-ahead 1 = -17 and [pycor] of patch-ahead 1 = -7
         [ask turtles-here
           [
             move-to one-of patches with [pxcor = -16 and pycor = 16 ];move the turtle to the defined point
             facexy -15 16 ;put his head to the good direction
           ]
         ]
         
         if [pxcor] of patch-ahead 1 = -8 and [pycor] of patch-ahead 1 = -10
         [ask turtles-here
           [
             move-to one-of patches with [pxcor = -5 and pycor = -10 ]
             facexy -4 -10
           ]
         ]
         
         if [pxcor] of patch-ahead 1 = 9 and [pycor] of patch-ahead 1 = -13
         [ask turtles-here
           [
             move-to one-of patches with [pxcor = 3 and pycor = -13 ]
             facexy 3 -12
           ]
         ]
         
         if [pxcor] of patch-ahead 1 = 17 and [pycor] of patch-ahead 1 = -14
         [ask turtles-here
           [
             facexy 14 -17
           ]
         ]
         
         if [pxcor] of patch-ahead 1 = 17 and [pycor] of patch-ahead 1 = 0
         [ask turtles-here
           [
              move-to one-of patches with [pxcor = 16 and pycor = -3 ]
              facexy 15 -3
           ]
         ]
         
         if [pxcor] of patch-ahead 1 = 8 and [pycor] of patch-ahead 1 = 17
         [ask turtles-here
           [
             facexy 17 16
           ]
         ]
                  
       ]
       [forward 1];move forward 1 patch
     ]
  set energy energy - 1  ;; when the turtle moves it looses one unit of energy
  if show-energy
    [ set label energy ] ;; the label is set to be the value of the energy
  ]
end

to check-death
  ask turtles [
    if energy <= 0 [ die ] ;; removes the turtle if it has no energy left
  ]
end

to check-arrival
   ask turtles [
     ;if the turle is on one exit
     if pcolor = 15 [ ;deep red
       set arrivalA arrivalA + 1
       die
       ]
     if pcolor = 16 [ ;bright red
       set arrivalB arrivalB + 1
       die
       ]
   ]
end


;;/************************** Global functions ************************************/
to go
  move-turtles
  check-arrival
  check-death
subitdeath
  eat-grass
  regrow-grass
  tick ;; increment the tick counter and update the plot
end
@#$#@#$#@
GRAPHICS-WINDOW
224
10
724
531
17
17
14.0
1
9
1
1
1
0
0
0
1
-17
17
-17
17
1
1
1
ticks
30.0

BUTTON
27
203
156
236
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
10
161
182
194
turtles_number
turtles_number
1
1000
739
1
1
NIL
HORIZONTAL

BUTTON
54
250
117
283
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
30
21
169
54
show-energy
show-energy
1
1
-1000

BUTTON
42
117
150
150
Trace tracks
pen-down
NIL
1
T
TURTLE
NIL
NIL
NIL
NIL
1

MONITOR
732
63
796
108
ArrivalA
arrivalA
17
1
11

MONITOR
735
484
797
529
ArrivalB
arrivalB
17
1
11

SWITCH
30
64
170
97
show-signals
show-signals
0
1
-1000

PLOT
848
29
1122
247
Total arrival
Time
Arrival
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -3844592 true "" "plot arrivalA"
"pen-1" 1.0 0 -15040220 true "" "plot arrivalB"

PLOT
848
261
1121
483
Population evolution in time
Time
Number of turtles in the path
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"
"pen-1" 1.0 0 -7858858 true "" "plot count (arrivalA + arrivalB)"

SLIDER
14
328
186
361
energy-from-grass
energy-from-grass
0
2000
501
1
1
NIL
HORIZONTAL

SWITCH
39
430
160
463
subit_death
subit_death
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

This model shows agents' behaviour on how to find the exit in a labyrynth.
We are expecting to see the influence of guiding sign in the path.

At the same time, we can see that the shorter path is not always the easier one, and that sometime a longer path with few angles is better than a shorter one with lots of angles.

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

The buttons in the Interface are defined as follows:

- setup: This clears the environment and loads a new image
- You can define the number of agent in the envirnomment with the related slider.
- You can turn sign on or off with the related button
- You can show the energy each agent has with the related button
- Trace tracks will allow the user to see the tracks left by the agents, it is usefull if you want to know the exploration rate of your path
- Arrival A and B will count the number of agents that arrived at the corresponding exit ( two exits on this model, but you can add more if you want)
- 2 graphs can show you the evolution of the population in time and also how many agent found the exit.
- the subit death is the case an agent has been poisoning

## THINGS TO NOTICE

You can see the behaviour of the agents in the labyrynth, the influence of the guiding sign.

## THINGS TO TRY

- Add more agents to see their behaviour
- Add or remove grass to see the influence on the simulation and death rate

## EXTENDING THE MODEL

This model is a basic model we created in order to better understand the multiagent systems. Of course, you can do it better and add much more features ;-)

Try modifying the model so that it allows the user to experience other behaviours. There a re so manys things to do with it, let's your imagination do the rest ;-)


## NETLOGO FEATURES

-

## RELATED MODELS

This model uses some functionnalities that you may also find in the "Ants line" or "Sheep and Wolves" models. 


## CREDITS AND REFERENCES

This model was created by Djothi Grondin and Allan Lauret.

To refer to this model in publications, please name the contributors.
Thanks !
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.5
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
