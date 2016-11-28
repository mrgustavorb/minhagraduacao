namespace :create do

  task ufs: :environment do

   # id         :integer          not null, primary key
   # sigla      :string(2)
   # name       :string(100)
   # created_at :datetime
   # updated_at :datetime
   # co_uf      :integer
   # region_id  :integer

    filepath = File.join Rails.root, "/docs/ies.csv"

    CSV.foreach(filepath, headers: true, header_converters: :symbol, col_sep:"|") do |row|
      sigla = row[:sgl_uf_ies]
      co_uf = row[:co_uf_ies]

      uf = Uf.find_by(sigla: co_uf)

      if uf.present?
        uf.sigla = sigla
        uf.co_uf = co_uf
        uf.save!
      else
        uf = Uf.new
        uf.sigla = sigla
        uf.co_uf = co_uf

        if uf.valid?
          uf.save!
        else
          puts "#{uf.sigla} Não Válido"
        end
      end
    end
  end

  task cities: :environment do
    
    filepath = File.join Rails.root, "/docs/ies.csv"

    CSV.foreach(filepath, headers: true, header_converters: :symbol, col_sep:"|") do |row|

      name         = row[:no_municipio_ies]
      co_municipio = row[:co_municipio_ies]
      co_uf        = row[:co_uf_ies]
      is_capital   = row[:is_capital]

      city = City.find_by(co_municipio: co_municipio)
      uf = Uf.find_by(co_uf: co_uf)

      if city.present?
        city.co_municipio = co_municipio
        city.name         = name
        if is_capital == "1"
          city.is_capital = true
        else
          city.is_capital = false
        end 
        city.uf_id        = uf.id
        city.save!
      else
        city = City.new

        city.co_municipio = co_municipio 
        city.name         = name
        if is_capital == "1"
          city.is_capital = true
        else
          city.is_capital = false
        end        
        city.uf_id        = uf.id

        if city.valid?
          city.save!
        else
          puts "Cidade invalida" 
        end
      end
    end
  end
end