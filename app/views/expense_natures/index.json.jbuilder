json.array!(collection) do |obj|
  json.id     obj.id
  json.value  obj.to_s
  json.label  obj.to_s
end
