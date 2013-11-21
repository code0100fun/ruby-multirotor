# class Block
#   attr_accessor :body, :shape, :radius

#   def initialize(mass, radius, elasticity = 0.8)
#     @radius = radius
#     moi = CP.moment_for_poly(mass, vertices, Vectors::ORIGIN)

#     @body = CP::Body.new(mass, moi)

#     @shape = CP::Shape::Poly.new(@body, vertices, Vectors::ORIGIN)
#     @shape.collision_type = :block
#     @shape.e = elasticity
#   end

#   def vertices
#     nth_roots_of_unity(20).map do |x, y|
#       CP::Vec2.new(x*radius, y*radius)
#     end
#   end

#   def draw(window)
#     PolyRenderer.new(shape).draw(window, 0xff00ffff)
#   end

#   def nth_roots_of_unity(n)
#     (0..n-1).map { |k| Complex.polar(1, 2 * Math::PI * k / n) }.map(&:rect).reverse
#   end

# end
