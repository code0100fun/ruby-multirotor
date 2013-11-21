class Aircraft
  attr_accessor :body, :shape, :length
  attr_reader :left_throttle, :right_throttle

  unless defined? MAX_THROTTLE
    MAX_THROTTLE = 12
  end

  def initialize(window)
    @image = Gosu::Image.new(window, 'assets/drone.png', false)
    @width = 200.0
    @height = @width / aspect
    @mass = 50.0
    @moi = CP.moment_for_poly(@mass, vertices, Vectors::ORIGIN)

    @body = CP::Body.new(@mass, @moi)

    @shape = CP::Shape::Poly.new(@body, vertices, Vectors::ORIGIN)
    @shape.collision_type = :block
    @shape.e = 0.0
    @shape.u = 0.5
    @body.apply_force(Vectors::GRAVITY, Vectors::ORIGIN)
    @left_engine = CP::Vec2.new(-@width/2, 0)
    @right_engine = CP::Vec2.new(@width/2, 0)
    @left_throttle = 0
    @right_throttle = 0

    @stabilizer = Stabilizer.new(self)
    @stabilizer.target_height = 200
    @font = Gosu::Font.new(window, "veranda", 10)
  end

  def aspect
    @image.width / @image.height
  end

  def image_scale
    @width / @image.width
  end

  def image_angle
    @body.a * (180.0/Math::PI)
  end

  def vertices
    unless @vertices
      x = @width/2
      y = @height/2
      @vertices = [
                    CP::Vec2.new(-x, -y),
                    CP::Vec2.new( x,  y),
                    CP::Vec2.new( x, -y),
                    CP::Vec2.new(-x, -y),
                    CP::Vec2.new(-x,  y),
                    CP::Vec2.new( x,  y)
                  ]
    end
    @vertices
  end

  def update
    now = Time.new
    @last_update ||= now
    @dT = now - @last_update
    @last_update = now
    @stabilizer.update(@body.a, @body.p.x, @body.p.y, @dT)
  end

  def draw(window)
    # PolyRenderer.new(shape).draw(window, 0xffdddddd)
    @image.draw_rot(@body.p.x, @body.p.y, 1, image_angle,
                    0.5, 0.5, image_scale, image_scale)
    if @right_throttle > 0
      direction, position = right_thrust_vector
      position += @body.p
      window.draw_line(position.x, position.y, 0xffff0000,
                       position.x + direction.x, position.y + direction.y, 0xffff0000)
    end

    if @left_throttle > 0
      direction, position = left_thrust_vector
      position += @body.p
      window.draw_line(position.x, position.y, 0xffff0000, position.x + direction.x, position.y + direction.y, 0xffff0000)
    end

    window.draw_quad(*center_quad)

    @font.draw("Left Throttle: #{@left_throttle}", 10, 10, 1, 1)
    @font.draw("Right Throttle: #{@right_throttle}", 10, 30, 1, 1)
    @font.draw("dT: #{@dT}", 10, 50, 1, 1)
  end

  def center_quad
    [
      @body.p.x - 10, @body.p.y - 10, 0xff0000ff,
      @body.p.x + 10, @body.p.y - 10, 0xff0000ff,
      @body.p.x + 10, @body.p.y + 10, 0xff0000ff,
      @body.p.x - 10, @body.p.y + 10, 0xff0000ff
    ]
  end

  def local_vec(vec)
    vec.rotate(@body.rot)
  end

  def left_thrust_vector
    [local_vec(Vectors::UP) * @left_throttle, local_vec(Vectors::ORIGIN + @left_engine)]
  end

  def right_thrust_vector
    [local_vec(Vectors::UP) * @right_throttle, local_vec(Vectors::ORIGIN + @right_engine)]
  end

  def update_forces
    @body.reset_forces
    @body.apply_force(Vectors::GRAVITY, Vectors::ORIGIN)
    @body.apply_force(*right_thrust_vector)
    @body.apply_force(*left_thrust_vector)
  end

  def throttle(throttle, engine)
    throttle = MAX_THROTTLE if throttle > MAX_THROTTLE
    throttle = 0 if throttle < 0
    if engine == :left
      @left_throttle = throttle
    end
    if engine == :right
      @right_throttle = throttle
    end
    update_forces
  end
end
