class Stabilizer
  attr_accessor :target_height, :target_x, :target_rotation

  def initialize aircraft
    @aircraft = aircraft
    @rotation_pid = PIDController.new :kP => 100.010, :kI => 0.0010, :kD => 90.000
    @height_pid = PIDController.new :kP => 100.110, :kI => 0.0001, :kD => 90000000.911
  end

  def target_rotation
    @target_rotation = 0 if @target_rotation.nil?
    @target_rotation
  end

  def target_height
    @target_height = 0 if @target_height.nil?
    @target_height
  end

  def rotation_error rotation
    CalculatesAngleError.new.angle_error(target_rotation, rotation)
  end

  def height_error height
    target_height - height
  end

  def update(rotation, x, height, dT)
    rotation_correction = @rotation_pid.update(rotation_error(rotation), dT)
    @aircraft.throttle(@aircraft.left_throttle - rotation_correction, :left)
    @aircraft.throttle(@aircraft.right_throttle + rotation_correction, :right)

    height_correction = @height_pid.update(height_error(height), dT)
    @aircraft.throttle(@aircraft.left_throttle - height_correction, :left)
    @aircraft.throttle(@aircraft.right_throttle - height_correction, :right)
  end
end
