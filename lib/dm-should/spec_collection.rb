module DataMapper
  module Should

    class Specs

      include DataMapper::Assertions

      attr_reader :scope, :specs

      def initialize(scope)
        assert_kind_of "scope of Specs", scope, ::String, Symbol
        @scope = scope.to_s
        @specs = []
      end

      def add(new_specs)
        add_to_specs new_specs
      end
      alias_method :<<, :add

        def add_to_specs(new_specs)
          specs << new_specs
          specs.flatten!
        end
        private :add_to_specs


      def [](key)
        specs[key]
      end

      def to_a
        specs.dup
      end

      def each(&block)
        specs.each &block
      end

      include Enumerable

    end

    class ModelSpecs < Specs

      # Only ModelSpecs has specs as a Mash in addition to the specs Array.
      attr_reader :specs_mash
      alias_method :model, :scope

      def initialize(scope)
        assert_kind_of "scope of ModelSpecs", scope, DataMapper::Model
        @scope = scope

        @specs = []
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
            specs_mash[key] = Specs.new([scope, key].join("."))  unless specs_mash.has_key? key
            specs_mash[key] << spec
          end
        end
        private :add_to_specs_mash


      def [](key)
        case key
          when Fixnum: specs[key]
          when String,Symbol: specs_mash[key]
          when DataMapper::Property: specs_mash[key.name]
        end
      end
      alias_method :on, :[]

      def to_mash
        specs_mash.dup
      end

      def to_s
        doc = ""
        doc << "=" + model.to_s + "\n" # the name of this model as a title
        specs_mash.each do |property, specs_of_property|
          doc << "#{property}:\n"
          specs_of_property.each do |spec|
            doc << spec.doc(:field => "-") + "\n"
          end
        end
        doc
      end

      
    end

  end
end
