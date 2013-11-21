class CalculatesAngleError
  def angle_error target, actual
    angle_error = actual - target
    angle_error += 2*Math::PI if angle_error <= -Math::PI
    angle_error -= 2*Math::PI if angle_error >=  Math::PI
    angle_error
  end
end
