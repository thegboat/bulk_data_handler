class BulkDataHandler::UpdatingNewRecordError < StandardError

  def message
    "You have attempted to updated a new record."
  end

end

class BulkDataHandler::CreatingPersistedRecordError < StandardError

  def message
    "You have attempted to create an existing record."
  end
  
end