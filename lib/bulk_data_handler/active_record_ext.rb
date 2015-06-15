module BulkDataHandler::ActiveRecordExt

  def mass_update(objects, options = {})
    raise BulkDataHandler::UpdatingNewRecordError if objects.any?(&:new_record?)
    mass_save(objects, options)
  end

  def mass_create(objects, options = {})
    raise BulkDataHandler::CreatingPersistedRecordError if objects.any?(&:persisted?)
    mass_save(objects, options)
  end

  def mass_save(objects, options = {})
    grouped = objects.group_by(&:new_record?)
    BulkDataHandler::MassUpdater.new(self, grouped[false], options)
    BulkDataHandler::MassCreator.new(self, grouped[true], options)
    objects
  end

  def mass_update!(objects, options = {})
    mass_update(objects, options)
    unless objects.all?( |obj| obj.errors.empty? }
    objects
  end

  def mass_create!(objects, options = {})
    mass_create(objects, options)
  end

  def mass_save!(objects, options = {})
    mass_save(objects, options)

  end

end