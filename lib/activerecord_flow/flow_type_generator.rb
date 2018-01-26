require 'erb'
require 'active_record'

module ActiverecordFlow
  class FlowTypeGenerator
    def initialize(klass)
      @klass = klass
      @flowtype_def = {}
    end

    def convert
      unless @klass.ancestors.include? ActiveRecord::Base
        raise 'Not an ActiveRecord object'
      end

      map_columns_to_flowtype
      map_associations_to_flowtype

      @flowtype_def
    end

    def render
      renderer = ERB.new(File.read('lib/templates/flow_type_template.erb'))

      renderer.result(binding).each_line.reject { |x| x.strip == '' }.join
    end

    private

    def map_columns_to_flowtype
      @klass.columns.each do |column|
        type = ActiverecordFlow::SQL_TO_FLOW_MAPPING[column.type]
        nullable = column.null || column.name == @klass.primary_key
        @flowtype_def[column.name] = "#{nullable ? '?' : ''}#{type}"
      end
    end

    def map_associations_to_flowtype
      @klass._reflections.each_key do |association_name|
        reflection = @klass._reflections[association_name]

        if reflection.is_a?(ActiveRecord::Reflection::ThroughReflection)
          reflection = reflection.delegate_reflection
        end

        nullable = reflection.options[:optional] && true

        if reflection.collection?
          activerecord_name = reflection.options[:class_name] || association_name.singularize.titleize
          type = "Array<#{activerecord_name}>"
        elsif reflection.has_one? || reflection.belongs_to?
          type = reflection.options[:class_name] || association_name.titleize
          type = get_polymorphic_type(reflection, association_name) if reflection.belongs_to? && reflection.options[:polymorphic]
        end

        @flowtype_def[association_name] = "#{nullable ? '?' : ''}#{type}"
      end
    end

    def get_polymorphic_type(reflection, association_name)
      type = []
      ActiveRecord::Base.subclasses.each do |klass|
        unless klass.reflect_on_all_associations.select { |ref| ref.options[:as] == association_name.to_sym }.empty?
          type.push(klass.name)
        end
      end
      type.join(' | ')
    end
  end
end
