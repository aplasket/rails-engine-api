class Merchant
  attr_reader :id,
              :name

  def initialize(attributes)
    binding.pry
    @id = 1
    @name = attributes[:name]
  end
end