require 'calculates_angle_error'

describe CalculatesAngleError, "#angle_error" do
  let(:calculator){ CalculatesAngleError.new }

  it "returns 1 for a target of 0 and an actual of 1" do
    expect(calculator.angle_error(0, 1)).to eq 1
  end

  it "returns -1 for a target of 0 and an actual of -1" do
    expect(calculator.angle_error(0, -1)).to eq -1
  end

  it "returns 0 for a target of 0 and an actual of -2*PI" do
    expect(calculator.angle_error(0, -2*Math::PI)).to eq 0
  end

  it "returns 0 for a target of 0 and an actual of 2*PI" do
    expect(calculator.angle_error(0, 2*Math::PI)).to eq 0
  end

  it "returns -PI/2 for a target of 0 and an actual of 3*PI/2" do
    expect(calculator.angle_error(0, (3*Math::PI)/2)).to eq(-Math::PI/2)
  end

end
