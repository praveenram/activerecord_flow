require 'activerecord_flow/version'
require 'activerecord_flow/railtie' if defined?(Rails)

module ActiverecordFlow
  SQL_TO_FLOW_MAPPING = Hash.new('any').merge(
    string: 'string',
    integer: 'number',
    text: 'string',
    datetime: 'Date',
    boolean: 'boolean',
    bigint: 'number'
  )
end
