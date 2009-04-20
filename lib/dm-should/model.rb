module DataMapper
  module Model
    
    def property_with_spec(*args, &block)
      pro = property(*args)
      specs << Should::SpecCollector.collect(pro, block)
    end


    # define the :ensure_spec instance method
    def ensure_spec
      self.module_eval(specs.compiled_statement, __FILE__, __LINE__) 
    end


    # A Model class has A SpecCollection.
    def specs
      @specs = Should::SpecCollection.new(self) unless @specs
      @specs
    end

  end

end
