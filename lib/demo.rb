Object.send :remove_const, :Config
Config = RbConfig

require 'chipmunk'
require 'gosu'
require 'hasu'
require 'matrix'
Hasu.load 'lib/window.rb'
Hasu.load 'lib/vectors.rb'
Hasu.load 'lib/block.rb'
Hasu.load 'lib/aircraft.rb'
Hasu.load 'lib/poly_renderer.rb'
Hasu.load 'lib/pid_controller.rb'
Hasu.load 'lib/stabilizer.rb'
Hasu.load 'lib/calculates_angle_error.rb'

Window.run
