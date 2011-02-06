# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

YAML.load_file('data/computers.yml').each{|a| Router::Computer.new(   a.ivars['attributes'] ).save}
YAML.load_file('data/tcclassid.yml').each{|a| Router::Tc::Classid.new(a.ivars['attributes'] ).save}
