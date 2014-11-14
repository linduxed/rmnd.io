require "spec_helper"
require "decorator"

describe Decorator do
  describe "#==" do
    it "returns true if the other holds the same object" do
      decorator_one = Decorator.new(:an_object)
      decorator_two = Decorator.new(:an_object)

      expect(decorator_one).to eq(decorator_two)
    end

    it "returns false if the other holds another object" do
      decorator_one = Decorator.new(:an_object)
      decorator_two = Decorator.new(:another_object)

      expect(decorator_one).not_to eq(decorator_two)
    end

    it "returns false if the other is of another class" do
      decorator = Decorator.new(:an_object)
      other = String.new

      expect(decorator).not_to eq(other)
    end
  end

  describe "#eql?" do
    it "returns true if the other holds the same object" do
      decorator_one = Decorator.new(:an_object)
      decorator_two = Decorator.new(:an_object)

      expect(decorator_one).to eql(decorator_two)
    end

    it "returns false if the other holds another object" do
      decorator_one = Decorator.new(:an_object)
      decorator_two = Decorator.new(:another_object)

      expect(decorator_one).not_to eql(decorator_two)
    end

    it "returns false if the other is of another class" do
      decorator = Decorator.new(:an_object)
      other = String.new

      expect(decorator).not_to eql(other)
    end
  end

  describe "#hash" do
    it "returns a hash that combines the class and object" do
      decorator = Decorator.new(:an_object)

      expect(decorator.hash).to eq([Decorator, :an_object].hash)
    end
  end

  describe "#to_param" do
    it "delegates to the decorated object" do
      decorator = Decorator.new(double(:model, to_param: "a-param"))

      expect(decorator.to_param).to eq "a-param"
    end
  end

  describe "any method" do
    it "delegates to object" do
      object = double(:object, message: :returned_object)
      decorator = Decorator.new(object)

      expect(decorator.message(:a_parameter)).to eq(:returned_object)
      expect(object).to have_received(:message).with(:a_parameter)
    end
  end
end
