module DataMapper
  module Should

    # A Model class has A SpecCollection.
    class SpecCollection

      attr_reader :model, :property
      attr_reader :specs

      def initialize(model)
        @model = model 

        # How about having specs as an Array for ensuring,
        @specs = []

        # and also having specs as an Mash for specdoc?
        @specs_mash = Mash.new
      end

      def add(new_specs)
        add_to_specs new_specs
        add_to_specs_mash new_specs
      end
      alias_method :<<, :add

        def add_to_specs(new_specs)
          specs << new_specs
          specs.flatten!
        end
        private :add_to_specs

        def add_to_specs_mash(new_specs)
          new_specs.each do |spec|
            key = spec.property.name
            @specs_mash[key] = []  unless @specs_mash.has_key? key
            @specs_mash[key] << spec
          end
        end
        private :add_to_specs_mash


      def [](key)
        case key
          when Fixnum: specs[key]
          when String,Symbol: @specs_mash[key]
          when DataMapper::Property: @specs_mash[key.name]
        end
      end

      def to_a
        specs.dup
      end

      def to_mash
        @specs_mash.dup
      end

      def each(&block)
        specs.each &block
      end

      include Enumerable

      def to_s
        doc = ""
        doc << "=" + model.to_s + "\n" # the name of this model as a title
        @specs_mash.each do |property, specs_of_property|
          doc << "#{property}:\n"
          specs_of_property.each do |spec|
            doc << spec.doc(:field => "-") + "\n"
          end
        end
        doc
      end


      def scopes_to_be_translated
        map { |spec_class| spec_class.scope }
      end
      alias_method :scopes, :scopes_to_be_translated

    end
  end
end
