class ReportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.report_data.subject
  #
  def report_data(email, name)
    default from: "julie@example.org", reply_to: "julie@example.org"
    @greeting = "Hello!"
    @assembly = Assembly.find_by_name(name)
    @hits=Hit.where(subject: Gene.where(sequence: Sequence.where(assembly: @assembly))).order(percent_similarity: :desc)
    mail to: email, subject: "Your Report", from: "mailgun@mailgun.org"
  end
end
