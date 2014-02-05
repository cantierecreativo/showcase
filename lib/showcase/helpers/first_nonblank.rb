class FirstNonBlank
  def self.find(values)
    Array(values).find(&:presence)
  end
end

