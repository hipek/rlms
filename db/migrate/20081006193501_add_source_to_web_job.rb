class AddSourceToWebJob < ActiveRecord::Migration
  def self.up
    add_column :web_jobs, :source, :text
    add_column :web_jobs, :format_num, :text
    add_column :web_jobs, :category, :string
    add_column :web_jobs, :start_num_img, :string
  end

  def self.down
    remove_column :web_jobs, :source
    remove_column :web_jobs, :format_num
    remove_column :web_jobs, :category
    remove_column :web_jobs, :start_num_img
  end
end
