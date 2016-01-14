json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :date, :time, :comment
  json.url appointment_url(appointment, format: :json)
end
