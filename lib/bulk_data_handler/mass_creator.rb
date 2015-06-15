require 'bulk_data_handler/mass_importer'

class BulkDataHandler::MassCreator < BulkDataHandler::MassImporter

  protected

  def self.auto_timestamps
    @auto_timestamps ||= ['created_at', 'created_on', 'updated_at', 'updated_on']
  end

  def auto_timestamp?(object, column_name)
    object.send(column_name).nil? && self.class.auto_timestamps.include?(column_name)
  end

  def auto_timestamp!(object, column_name)
    object("#{column_name}=", now)
  end

  def build_batch_sql(slice)
    sql = insert_partial
    sql << values_partial(slice)
    sql << "RETURNING #{klass.primary_key};"
  end

  def column_names
    @column_names ||= begin
      rtn = klass.column_names.map(&:to_s)
      rtn.reject! {|name| name == primary_key }
      rtn.sort!
      rtn
    end
  end

  def message
    "#{klass.name} Mass Create"
  end

  def insert_partial
    %{INSERT INTO #{quoted_table_name} (#{quote_column_names}) }
  end

  def _perform
    @returning_ids = []
    sqls.each {|sql| @returning_ids << klass.send(:insert, sql, message ) }
  end

  def cleanup
    set_primary_keys
  end

  def set_primary_keys
    @returning_ids = @returning_ids.to_a
    @returning_ids.flatten!
    @returning_ids.map!(&:to_i)
    return nil if @returning_ids.empty?
    objects.zip(@returning_ids).each do |object,id|
      object.send("#{primary_key}=", id)
      object.instance_variable_set('@new_record', false)
    end
  end

end