require 'csv'

desc 'Import pce data'
task :import => :environment do
  # fields = ["gnis_feature_id", "community_name", "latitude", "longitude", "plant_name", "year", "month", "season",
  # "fuel_used_gal", "residential_kwh_sold","commercial_kwh_sold","community_kwh_sold","government_kwh_sold" ]

  puts "Importing #{ENV['file']}"

  counter = 0
  CSV.foreach(ENV['file'], headers: true, return_headers: false) do |line|
    data = line.to_hash
    next if ENV['id'].present? and data['gnis_feature_id'] != ENV['id']
    Pce.create(data.keep_if { |k,v| Pce.column_names.include?(k) })
    print "\r#{counter += 1}"
  end
end
