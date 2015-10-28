require 'csv'
class ReportsController < ApplicationController
  helper_method :memory_in_mb

  def perform_upload
    MakeCsvJob.perform_later(params[:file].path)
    flash[:success] = "Uploaded successfully"
    redirect_to action: :upload
  end

  def upload
  end

  def edit
    @report = Report.first
  end

  def update
    @report.update(report_params)
    render 'show'
  end

  def show
  end

  def submit
  end

  def search
    @start_time = Time.now
    if params[:search]
      q = "%#{params[:search]}%"
        @hits = Hit.where("hits.match_gene_name LIKE ?", q)
        @hits += Hit.where(subject: Gene.joins(sequence: :assembly).where("genes.dna LIKE ? OR assemblies.name LIKE ?", q, q))
    else
    end
    @memory_used = memory_in_mb
  end

  def index
    if params[:email] && params[:name]
      @email = params[:email]
      @name = params[:name]
      MakeCsvForEmailJob.perform_later(@name)
      ReportMailer.report_data(@email, @name).deliver_later
      render :sent_report
    else

    end
  end

  private

  def report_params
    params.permit(:uploaded_file)
  end

  def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end
