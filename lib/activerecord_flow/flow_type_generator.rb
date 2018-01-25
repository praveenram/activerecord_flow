require 'erb'
require 'active_record'

module ActiverecordFlow
  class FlowTypeGenerator
    def initialize(klass:)
      @klass = klass
      @flowtype_def = {}
    end

    def convert
      unless @klass.ancestors.include? ActiveRecord::Base
        raise 'Not an ActiveRecord object'
      end

      map_columns_to_flowtype
      map_associations_to_flowtype
    end

    def render
      renderer = ERB.new(File.read('lib/templates/flow_type_template.erb'))

      renderer.result(binding).each_line.reject { |x| x.strip == '' }.join
    end

    private

    def map_columns_to_flowtype
      @klass.columns.each do |column|
        type = ActiverecordFlow::SQL_TO_FLOW_MAPPING[column.type]
        @flowtype_def[column.name] = "#{column.null ? '?' : ''}#{type}"
      end
    end

    def map_associations_to_flowtype
      @klass._reflections.each_key do |association_name|
        reflection = @klass._reflections[association_name]
        nullable = reflection.options[:optional] && true

        if reflection.is_a?(ActiveRecord::Reflection::HasManyReflection)
          type = "Array<#{association_name.singularize.titleize}>"
        elsif reflection.is_a?(ActiveRecord::Reflection::BelongsToReflection)
          type = association_name.titleize
        end

        @flowtype_def[association_name] = "#{nullable ? '?' : ''}#{type}"
      end
    end
  end
end
