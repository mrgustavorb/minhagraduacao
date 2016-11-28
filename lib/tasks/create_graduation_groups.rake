# encoding: utf-8
require 'csv'

# # graduation_group
# # :id => :integer,
# # :name => :string,
# # :name_noaccent => :string,
# # :url_friendly => :string,
# # :active => :boolean,
# # :created_at => :datetime,
# # :updated_at => :datetime,
# # :views => :integer,
# # :json_data => :text,
# # :description => :text,
# # :source => :string,
# # :institutions_numbers => :integer

# # graduation
# # :id => :integer,
# # :name => :string,
# # :name_noaccent => :string,
# # :url_friendly => :string,
# # :active => :boolean,
# # :updated_at => :datetime,
# # :created_at => :datetime,
# # :no_curso => :string,
# # :load_code => :string,
# # :graduation_group_id => :integer

namespace :create do

  task graduation_groups: :environment do
  
    file_path = File.join Rails.root, "docs/cursos.csv"

    CSV.foreach(file_path, headers: true, header_converters: :symbol, col_sep:"|") do |row|
      
      name                            = row[:no_curso].nome_proprio
      name_noaccent                   = I18n.transliterate("#{name}").humanize
      url_friendly                    = name_noaccent.parameterize
      co_ies                          = row[:co_ies]
      # byebug

      graduation_group = GraduationGroup.find_by(url_friendly: url_friendly)
      institution = Institution.find_by(co_ies: co_ies)
      
      if graduation_group.present?
        "Atualizando Curso - #{name}"
        graduation_group.name                 = name
        graduation_group.name_noaccent        = name_noaccent
        graduation_group.url_friendly         = url_friendly

        if institution.present?
          graduation_group.institution_ids << institution.id
          graduation_group.institutions_numbers = graduation_group.institutions_numbers + 1
        end

        if graduation_group.valid?
          graduation_group.save!
        end
      else
        "Criando Curso - #{name}"
        graduation_group = GraduationGroup.new

        graduation_group.name                 = name
        graduation_group.name_noaccent        = name_noaccent
        graduation_group.url_friendly         = url_friendly
        
        if institution.present?
          graduation_group.institution_ids << institution.id
          graduation_group.institutions_numbers = graduation_group.institutions_numbers + 1
        end

        if graduation_group.valid?
          graduation_group.save!
        else
          puts "#{graduation_group.name} inválido"
        end
      end
    end
  end

  task graduation_group_views: :environment do

    GraduationGroup.all.each do |graduation_group|
      graduation_group.views = 0
      graduation_group.save!
    end
  end

  task graduations: :environment do

    file_path = File.join Rails.root, "docs/cursos.csv"

    CSV.foreach(file_path, headers: true, header_converters: :symbol, col_sep:"|") do |row|
      name                 = row[:no_curso].nome_proprio
      name_noaccent        = I18n.transliterate("#{name}").humanize
      graduation_group_url = I18n.transliterate("#{row[:no_curso].nome_proprio}").humanize.parameterize
      url_friendly         = name_noaccent.parameterize
      co_ies               = row[:co_ies]
      active               = row[:co_situacao_curso]

      graduation = Graduation.find_by(url_friendly: url_friendly)
      gradutation_group = GraduationGroup.find_by(url_friendly: graduation_group_url)
      institution = Institution.find_by(co_ies: co_ies)

      if graduation.present?
        graduation.name                = name
        graduation.name_noaccent       = name_noaccent
        graduation.url_friendly        = url_friendly
        graduation.active              = active == "1" ? true : false
        graduation.graduation_group_id = gradutation_group.id
        graduation.institutions        << institution
      else
        graduation = Graduation.new

        graduation.name                = name
        graduation.name_noaccent       = name_noaccent
        graduation.url_friendly        = url_friendly
        graduation.active              = active == "1" ? true : false
        graduation.graduation_group_id = gradutation_group.id
        graduation.institutions        << institution

        if graduation.valid?
          graduation.save!
        else
          puts "Graduação inválida"
        end
      end
    end
  end
end