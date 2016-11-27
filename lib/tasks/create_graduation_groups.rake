# encoding: utf-8
require 'csv'

# graduation
# :id => :integer,
# :name => :string,
# :name_noaccent => :string,
# :url_friendly => :string,
# :active => :boolean,
# :updated_at => :datetime,
# :created_at => :datetime,
# :no_curso => :string,
# :load_code => :string,
# :graduation_group_id => :integer

# graduation_group
# :id => :integer,
# :name => :string,
# :name_noaccent => :string,
# :url_friendly => :string,
# :active => :boolean,
# :created_at => :datetime,
# :updated_at => :datetime,
# :views => :integer,
# :json_data => :text,
# :description => :text,
# :source => :string,
# :institutions_numbers => :integer

# namespace :create do

#   task graduation_groups: :environment do
  
#     file_path = File.join Rails.root, "docs/grupos.csv"

#     CSV.foreach(file_path, headers: true, header_converters: :symbol, col_sep:"|") do |row|
#       name                            = row[:no_curso].nome_proprio
#       no_curso                        = row[:no_curso]
#       name_noaccent                   = I18n.transliterate("#{name}").humanize
#       url_friendly                    = name_noaccent.parameterize
#       graduation_group_id             = row[:co_curso]

#       gradutation_group = GraduationGroup.new
#       graduation = Graduation.new

#     end

#   end

#   task count_institution_numbers: :environment do
#   end

# end