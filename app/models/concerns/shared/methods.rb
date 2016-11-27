module Shared::Methods
  extend ActiveSupport::Concern
  
  def get_json
    Hashie::Mash.new JSON.parse(self.json_data)
  end

end