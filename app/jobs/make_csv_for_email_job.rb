require 'csv'
class MakeCsvForEmailJob < ActiveJob::Base
  queue_as :default

  def perform(file)
    Report.import(file)
  end
end
