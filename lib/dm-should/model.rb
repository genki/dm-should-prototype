module DataMapper
  module Model
    
    def property_with_spec(*args, &block)
      pro = property(*args)
      specs << Should::SpecCollector.collect(pro, block)
    end


    # A Model class has A SpecCollection.
    def specs
      @specs = Should::ModelSpecs.new(self) unless @specs
      @specs
    end


    def specdoc
      specs.to_s
    end

  end

end
