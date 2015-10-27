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
    unless params[:name]
      render :sent_report
      return
    end
    @name = params[:name]
    if params[:email]
      @email = params[:email]
      ReportMailer.report_data(@email, @name).deliver_later
    else
    end
  end

  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end
