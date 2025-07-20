local cursor = require("mechanics/cursor_movement")
local troops = {}

troops.shotgun = {
  health   = 3,
  damage   = 2,
  range    = 1,
  movement = 2,
  gid      = 107,
  cost     = 300,
}

troops.bazooka = {
  health   = 1,
  damage   = 3,
  range    = 2,
  movement = 1,
  gid      = 107,
  cost     = 300,
}

troops.truck = {
  health   = 5,
  damage   = 0,
  range    = 1,
  movement = 3,
  gid      = 95,
  cost     = 300,
}


  troops.supply_truck = {
    health = 5,
    damage = 0,
    range = 1,
    movement = 96,
    gid     = 95,
    cost = 300

  }
  troops.carrier = {
    health = 8,
    damage = 0, 
    range = 1,
    movement = 2,
    gid     = 97,
    cost = 300,

}
  troops.tank = {
    health = 8,
    damage = 5,
    range = 2,
    movement = 2,
    gid = 98,
    cost = 300,


  }
  troops.artillery = {
    health = 5,
    damage = 3,
    range  = 5,
    movement = 1,
    power = 1,
    gid = 99,
    cost = 300,



  }

return troops
