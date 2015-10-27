class Report < ActiveRecord::Base

  def self.import(path) #perform insted of import for ActiveJob
    CSV.foreach(path, headers: true) do |r|
      new_assembly = Assembly.where(name: r["Assembly Name"], run_on: r["Assembly Date"]).first_or_create
      new_sequence = Sequence.where(dna: r["Sequence"], quality: r["Sequence Quality"], assembly_id: new_assembly.id).first_or_create
      new_gene = Gene.where(dna: r["Gene Sequence"], starting_position: r["Gene Starting Position"], direction: r["Gene Direction"], sequence_id: new_sequence.id).first_or_create
      Hit.where(match_gene_name: r["Hit Name"], match_gene_dna: r["Hit Sequence"], percent_similarity: r["Hit Similarity"], subject_id: new_gene.id, subject_type: "Gene").first_or_create
    end
  end

end
