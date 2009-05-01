module DataMapper
  module Should

    module TranslationRole

      def self.included(klass)
        klass.class_eval do
          include InstanceMethods
          extend ClassMethods
        end
      end

      module ClassMethods
        def translation_scope(spec_class)
          spec_class.translation_scope
        end
      end

      module InstanceMethods

        def translation_scopes
          map do |spec_class|
            self.class.translation_scope(spec_class)
          end
        end

        def translated_scopes
          map do |spec_class|
            Translation.translate(
              self.class.translation_scope(spec_class), assigns(spec_class)) 
          end
        end
        alias_method :specdocs, :translated_scopes


        def assigns(spec_class)
          spec_class.assigns
        end

        def translation_scopes_each 
          if block_given?
            map do |spec_class|
              yield self.class.translation_scope(spec_class), assigns(spec_class)
            end
          end
        end

      end
      
    end


    class Specs

      include DataMapper::Assertions

      include TranslationRole

      attr_reader :scope, :specs

      def initialize(scope)
        @scope = scope
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

      def inspect
        "\#<#{self.class} @specs=#{@specs.inspect} >"
      end

      def pretty_print(pp)
        pp.object_address_group self do
          pp.group do
            pp.breakable
            pp.text "@specs="
            pp.group 1 do
              pp.seplist(specs, lambda { pp.text ',' }) do |v|
                pp.breakable
                pp.text v.inspect 
              end
            end
          end
        end
      end

    end


    class PropertySpecs < Specs
      
      alias_method :property, :scope

      def initialize(scope)
        assert_kind_of "scope of PropertySpecs", scope, DataMapper::Property
        super
      end

    end

    class ModelSpecs < Specs

      # Only ModelSpecs has specs as a Mash in addition to the specs Array.
      attr_reader :specs_mash
      alias_method :model, :scope

      def initialize(scope)
        assert_kind_of "scope of ModelSpecs", scope, DataMapper::Model
        super
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
          Array(new_specs).each do |spec|
            key = spec.property.name
            specs_mash[key] = PropertySpecs.new(spec.property)  unless specs_mash.has_key? key
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

      def pretty_print(pp)
        pp.object_address_group self do
          pp.breakable
          pp.text "@specs_mash="
          pp.group 1 do
            pp.breakable
            pp.pp_hash specs_mash
          end
        end
      end
      
    end

  end
end
