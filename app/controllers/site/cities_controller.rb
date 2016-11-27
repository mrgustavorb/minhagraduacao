class Site::CitiesController < Site::ApplicationController

  def find_by_uf
    cities = GraduationGroup.select('cities.*')
                            .distinct
                            .joins(:cities)
                            .where(graduation_groups: {id: params[:graduation_id]}, cities: {uf_id: params[:uf_id]})
                            .order('cities.name ASC')
                            
    result = cities.map { |c| [c.id, c.name] }
    render json: result
  end

end