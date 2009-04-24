
class BePresent1
  include DataMapper::Resource 

  property :id, Serial
  property_with_spec :name, String do
    should be_present
  end

end

class BePresent2
  include DataMapper::Resource
  property :id, Serial
  property_with_spec :number, Integer do
    should be_present
  end
end

class BePositiveInteger1
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, Integer do
    should be_positive_integer
  end
end

# when :allow => nil
class BePositiveInteger2
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, Integer, :nullable => false do
    should be_positive_integer
  end
end

class BeUnique1
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, Integer do
    should be_unique
  end

end

class BeUnique2
  include DataMapper::Resource
  
  property :id, Serial
  property :category, String
  property_with_spec :number, Integer do
    should be_unique(:scope => :category)
  end

end


