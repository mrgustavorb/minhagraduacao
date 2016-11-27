json.suggestions @suggestions do |json, graduation_group|
  json.(graduation_group, :id, :name)
end