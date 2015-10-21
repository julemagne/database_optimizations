class ReportsController < ApplicationController
  helper_method :memory_in_mb

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

  def all_data
    @start_time = Time.now

    @assembly = Assembly.find_by_name(params[:name])
    # @assembly.sequences.each do |s|
    #   @sequences << s
    #   s.genes.each do |g|
    #     @genes << g
    #     g.hits.each do |h|
    #       @hits << h
    #     end
    #   end
    # end
    @hits=Hit.where(subject: Gene.where(sequence: Sequence.where(assembly: @assembly))).order(percent_similarity: :desc)
    # @assembly.includes(:sequences, { genes: { hits: :all } }).each do |a|
    #   @hits<<a
    # end
    # @hits.sort_by!(&:percent_similarity).reverse!

    @memory_used = memory_in_mb
  end

  private def memory_in_mb
    `ps -o rss -p #{$$}`.strip.split.last.to_i / 1024
  end
end
