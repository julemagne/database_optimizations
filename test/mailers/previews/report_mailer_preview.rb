# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/report_mailer/report_data
  def report_data
    ReportMailer.report_data
  end

end
