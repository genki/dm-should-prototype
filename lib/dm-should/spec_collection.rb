module DataMapper
  module Should

    # A Model class has A SpecCollection.
    class SpecCollection

      attr_reader :model, :specs, :property

      def initialize(model)
        @model = model 
        @specs = []
      end

      def add(new_specs)
        specs << new_specs
        specs.flatten!
      end
      alias_method :<<, :add

      def [](key)
        specs[key]
      end
      
      def to_a
        specs.dup
      end

      def each(&block)
        @specs.each &block
      end

    end
  end
end
