# encoding: utf-8
require 'csv'
require 'active_record'

namespace :create do

  task institutions: :environment do

    filepath = File.join Rails.root, "/docs/ies.csv"


    CSV.foreach(filepath, headers: true, header_converters: :symbol, col_sep:"|") do |row|
      institution_name          = row[:no_ies].to_s.squish.nome_proprio
      co_ies                    = row[:co_ies]
      co_mantenedora            = row[:co_mantenedora]
      active                    = true
      no_ies                    = row[:no_ies].to_s.squish   
      name_noaccent             = I18n.transliterate("#{no_ies}").humanize
      url_friendly              = name_noaccent.parameterize
      sigla                     = row[:sgl_ies].to_s
      uf_id                     = row[:co_uf_ies]
      academic_organization_id  = row[:co_organizacao_academica].to_s.squish

      institution = Institution.find_by(co_ies: co_ies)

      if institution.present?
        puts "#{institution_name} existe."
        institution.name                      = institution_name
        institution.co_ies                    = co_ies
        institution.co_mantenedora            = co_mantenedora
        institution.active                    = active
        institution.no_ies                    = no_ies
        institution.name_noaccent             = name_noaccent
        institution.url_friendly              = url_friendly
        institution.sigla                     = sigla
        institution.uf_id                     = uf_id
        institution.academic_organization_id  = academic_organization_id

        if institution.valid?
          institution.save!
        else
          puts "#{institution_name} inválido"
        end
      else
        institution = Institution.new
        
        institution.name                      = institution_name
        institution.co_ies                    = co_ies
        institution.co_mantenedora            = co_mantenedora
        institution.active                    = active == "1" ? true : false
        institution.no_ies                    = no_ies
        institution.name_noaccent             = name_noaccent
        institution.url_friendly              = url_friendly
        institution.sigla                     = sigla
        institution.uf_id                     = uf_id
        institution.academic_organization_id  = academic_organization_id

        if institution.valid?
          institution.save!
          puts "#{institution_name} foi criado."
        end
      end
    end
  end

end