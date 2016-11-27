require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :institutions do
  
  task create_profile: :environment do

    require 'nokogiri'
    require 'open-uri'
    require 'base64'

    Institution.all.each do |institution|
      encode_co_ies = Base64.encode64(institution.co_ies.to_s)
    
      url = "http://emec.mec.gov.br/emec/consulta-ies/index/d96957f455f6405d14c6542552b0f6eb/#{encode_co_ies}"
      
      doc = Nokogiri::HTML(open(url))
      

      logradouro = doc.css(".avalTabCampos")[1].search('tr:eq(2) td:eq(2)').text.strip
      numero = doc.css(".avalTabCampos")[1].search('tr:eq(2) td:eq(4)').text.gsub(/\./, '').strip
      bairro = doc.css(".avalTabCampos")[1].search('tr:eq(4) td:eq(2)').text.strip
      cep = doc.css(".avalTabCampos")[1].search('tr:eq(3) td:eq(4)').text.strip
      address = "#{logradouro},#{numero} - #{bairro}"
      phone = doc.css(".avalTabCampos")[1].search('tr:eq(6) td:eq(2)').text.strip
      
      unless phone.empty?
        phone = phone.split(/;/)
        if phone.kind_of?(Array)
          phone = phone[0]
        end  
        phone = phone.split(/\//)
        if phone.kind_of?(Array)
          phone = phone[0].strip
        end                 
      end

      site = doc.css(".avalTabCampos")[1].search('tr:eq(7) td:eq(4)').text.strip
      unless site.empty?
        site = verify_http_protocol_in_url(site)
      end

      institution_profile = InstitutionProfile.find_by(institution_id: institution.id)
      unless institution_profile
        new_profile = InstitutionProfile.new
        new_profile.institution_id = institution.id
        new_profile.site = site
        new_profile.phone = phone
        new_profile.address = address
        new_profile.cep = cep
        new_profile.save
        puts "#{institution.name} SAVE!"
      else
        institution_profile.site = site
        institution_profile.phone = phone
        institution_profile.address = address
        institution_profile.cep = cep
        institution_profile.save
        puts "#{institution.name} UPDATE!"
      end

    end

  end
end