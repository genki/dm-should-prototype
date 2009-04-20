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
      
      def to_ary
        specs.dup
      end

      def compiled_statement
        code =   "def ensure_specs\n"
        ensure_statements.each do |statement|
          code << statement
        end
        code <<  "end"
      end

      def ensure_statements
        []
      end

    end
  end
end
