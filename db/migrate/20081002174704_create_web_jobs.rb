class CreateWebJobs < ActiveRecord::Migration
  def self.up
    create_table :web_jobs do |t|
      t.string :name
      t.string :state
      t.text :body
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end

  def self.down
    drop_table :web_jobs
  end
end
