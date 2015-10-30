class ReportMailer < ApplicationMailer
  default from: "julie@example.org", reply_to: "julie@example.org"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.report_mailer.report_data.subject
  #
  def report_data(name, email)

    @greeting = "Hello!"
    @assembly = Assembly.find_by_name(name)
    @hits=Hit.where(subject: Gene.where(sequence: Sequence.where(assembly: @assembly))).order(percent_similarity: :desc)
    @report=CSV.open("your-super-report.csv", "w+") do |csv|
      csv << ["Assembly Name", "Assembly Date," "Sequence", "Sequence Quality", "Gene Sequence", "Gene Starting Position", "Gene Direction", "Hit Name", "Hit Sequence", "Hit Similarity"]
      @hits.each do |h|
        csv << h.match_gene_name, h.match_gene_dna.first(100), h.percent_similarity
      end
    end

    mail to: email, subject: "Your Report", from: "mailgun@mailgun.org"

  end
end
