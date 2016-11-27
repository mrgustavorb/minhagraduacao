class Site::SchoolsController < Site::ApplicationController

  before_filter :authenticate_user!, only: [:find_by_uf, :find_by_city]

  def find_by_uf
    schools = School.select('cities.id, cities.name')
                    .distinct
                    .joins(:city)
                    .where(uf_id: params[:uf_id])
                    .order('cities.name ASC')
                            
    result = schools.map { |c| [c.id, c.name] }
    render json: result
  end

  def find_by_city
    schools = School.select('schools.id, schools.no_entidade')
                    .where("uf_id = ? AND city_id = ?", params[:uf_id], params[:city_id])
                    .order('schools.no_entidade ASC')
                            
    result = schools.map { |c| [c.id, c.no_entidade] }
    render json: result
  end

end