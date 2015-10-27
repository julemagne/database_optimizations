require 'csv'
class MakeCsvJob < ActiveJob::Base
  queue_as :default

  def perform(file)
    Report.import(file)
  end
end
