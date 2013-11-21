class PIDController
  def initialize(options={})
    @kP = options[:kP] || 0.01
    @kI = options[:kI] || 0.0000001
    @kD = options[:kD] || 0.000001
  end

  def derivative(error, dT)
    @last = error if @last.nil?
    d = (error - @last) * dT
    @last = error
  end

  def integral(error, dT)
    @i = 0 if @i.nil?
    @i += error * dT
  end

  def update(error, dT)
    (@kP * error) + (@kD * derivative(error, dT)) + (@kI * integral(error, dT))
  end

  def reset
    @last = nil
    @i = nil
  end

end
