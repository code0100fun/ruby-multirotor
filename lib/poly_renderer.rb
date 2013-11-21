class PolyRenderer
  attr_reader :shape

  def initialize(shape)
    @shape = shape
  end

  def body
    shape.body
  end

  def pos
    body.pos
  end

  def rot
    body.rot
  end

  def verts
    (0..shape.num_verts-1).map do |i|
      v = shape.vert(i)
      [v.x, v.y]
    end
  end

  def rot_matrix
    cos = body.rot.x
    sin = body.rot.y
    Matrix[
      [cos, -sin],
      [sin,  cos]
    ]
  end

  def rot_points
    verts.map do |x, y|
      (rot_matrix * Matrix[[x], [y]]).to_a
    end.map do |(dx), (dy)|
      [pos.x + dx, pos.y + dy]
    end
  end

  def draw(window, color)
    r = rot_points
    (0..r.count-1).each do |i|
      x1, y1 = r[i]
      x2, y2 = r[(i+1) % r.count]
      window.draw_triangle(pos.x, pos.y, color,
                           x2, y2, color,
                           x1, y1, color)
    end
  end
end


