require 'bulk_data_handler/mass_importer'

class BulkDataHandler::MassUpdater < BulkDataHandler::MassImporter

  protected

  def self.auto_timestamps
    @auto_timestamps ||= ['updated_at', 'updated_on']
  end

  def auto_timestamp?(object, column_name)
    self.class.auto_timestamps.include?(column_name)
  end

  def auto_timestamp!(object, column_name)
    object("#{column_name}=", now)
  end

  def _perform
    objects.select!(&:changed?)
  end

  def default_slice_size
    100
  end

  def message
    "#{klass.name} Mass Update"
  end

  def column_names
    @column_names ||= begin
      rtn = objects.flat_map(&:changed)
      rtn << primary_key
      rtn.uniq!
      rtn
    end
  end

  def update_partial
    %{UPDATE #{quoted_table_name} SET }
  end

  def derived_partial
    %{FROM (#{values_partial}) AS tmp_updates(#{quote_column_names}) WHERE tmp_updates.#{primary_key} = #{quoted_table_name}.#{primary_key}}
  end

  def assignment_partial
    column_names.map {|name| "#{connection.quote_column_name(name)} = tmp_updates.#{connection.quote_column_name(name)}" }.join(',')
  end
end