class BulkDataHandler::MassImporter

  def initialize(klass, objects, options = {})
    @klass = klass
    @objects = [objects].flatten
    @write_connection = options[:write_connection]
    @slice_size = options[:slice_size]
  end

  class << self

    def perform(klass, objects, options = {})
      service = new(klass, objects, options)
      service.perform
    end

    alias :create :perform
    alias :update :perform
  end

  def perform
    _peform if all_valid?
    cleanup
    objects
  end

  def sqls
    values_array.each_slice(slice_size).map do |slice|
      build_batch_sql(slice)
    end
  end

  protected

  attr_reader :klass, :objects, :slice_size

  def default_slice_size
    1000
  end

  def slice_size
    @slice_size || default_slice_size
  end

  def primary_key
    @primary_key ||= klass.primary_key && klass.primary_key.to_s
  end

  def cleanup
    nil
  end

  def validate
    objects.map(&:valid?)
  end

  def all_valid?
    validate.reduce(&:&)
  end

  def connection
    @connection ||= @write_connection || klass.connection
  end

  def values_array 
    @values_array ||= begin
      values = objects.map { |obj| build_attributes(obj) }
      values.sort_by! {|item| item}
      values
    end
  end

  def build_attributes(object)
    column_names.map do |name|
      auto_timestamp!(object, name) if auto_timestamp?(object, name)
      object.send( "#{name}_before_type_cast" )
    end
  end

  def now
    ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
  end

  def table_name
    klass.quoted_table_name
  end

  def quoted_value(column_name, val)
    column = klass.columns_hash[column_name]
    if column.respond_to?(:type_cast_from_user) 
      connection.quote(column.type_cast_from_user(val), column)
    else
      connection.quote(column.type_cast(val), column) 
    end
  end

  def build_value_set(values)
    array = column_names.each_with_index.map do |name,i|
      quoted_value(name, values[i])
    end

    "(#{array.join(',')})"
  end

  def values_partial(slice)
    clause = slice.map {|arr| build_value_set(arr) }
    "VALUES (#{clause})"
  end

  def quote_column_names
    column_names.map {|name| connection.quote_column_name(name) }.join(',')
  end

end