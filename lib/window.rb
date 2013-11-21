class Window < Hasu::Window
  SUBSTEPS = 100
  STEP_DELTA = 60.0 / 60.0

  def initialize
    super 800, 600, false
  end

  def reset
    self.caption = 'Simulator'

    @space = CP::Space.new

    [
      [[0, 0], [0, 600]],
      [[0, 0], [800, 0]],
      [[0, 600], [800, 600]],
      [[800, 0], [800, 600]]
    ].each do |start, finish|
      add_bounding_plane start, finish
    end

    @aircraft = Aircraft.new(self)

    x = 400
    y = 300
    @aircraft.body.p = CP::Vec2.new x, y

    @space.add_body(@aircraft.shape.body)
    @space.add_shape(@aircraft.shape)
    @thread.kill if @thread
    @thread =  Thread.new do
      loop do
        @aircraft.update
        # sleep 0.00001
      end
    end
    @thread.priority = -1000
  end

  def add_bounding_plane(start, finish)
    ground_body = CP::Body.new(Float::INFINITY, Float::INFINITY)
    ground_body.p = Vectors::ORIGIN
    ground_shape = CP::Shape::Segment.new(ground_body, CP::Vec2.new(*start), CP::Vec2.new(*finish), 1.0)
    ground_shape.e = 0.0
    ground_shape.u = 0.5

    @space.add_static_shape(ground_shape)
  end

  def button_down(id)
    close if id == Gosu::KbEscape

    if id == Gosu::MsLeft
      @tracking = true
      @selected = @aircraft if @aircraft.shape.contains?(CP::Vec2.new mouse_x, mouse_y)
      @cur_position = [ mouse_x, mouse_y ]
    end

    if id == Gosu::KbA
      @aircraft.throttle(12, :left)
    end

    if id == Gosu::KbD
      @aircraft.throttle(12, :right)
    end

  end

  def button_up(id)
    if id == Gosu::KbA
      @aircraft.throttle(0, :left)
    end
    if id == Gosu::KbD
      @aircraft.throttle(0, :right)
    end
  end

  def draw
    @aircraft.draw(self)
    draw_mouse
  end

  def update
    if @tracking && @selected
      prev_x, prev_y = *@cur_position
      @cur_position = [ mouse_x, mouse_y ]

      if prev_x && prev_y
        dx = mouse_x - prev_x
        dy = mouse_y - prev_y
        # @selected.body.apply_force(CP::Vec2.new(dx, dy),
        #                            Vectors::ORIGIN)
      end
    end

    SUBSTEPS.times do
      @space.step(STEP_DELTA / SUBSTEPS)
    end
  end

  def draw_mouse
    color = 0xffcccccc

    draw_line(
      mouse_x - 10, mouse_y, color,
      mouse_x + 10, mouse_y, color
    )
    draw_line(
      mouse_x, mouse_y - 10, color,
      mouse_x, mouse_y + 10, color
    )
  end
end


