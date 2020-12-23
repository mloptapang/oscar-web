class CreateCaseWorkerCommunities < ActiveRecord::Migration
  def change
    create_table :case_worker_communities do |t|
      t.references "user", foreign_key: true
      t.references "community", foreign_key: true
    end
  end
end
