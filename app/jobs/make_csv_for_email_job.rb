require 'csv'
class MakeCsvForEmailJob < ActiveJob::Base
  queue_as :default

  def perform(name, email)
    ReportMailer.report_data(name, email).deliver_now
  end
end
