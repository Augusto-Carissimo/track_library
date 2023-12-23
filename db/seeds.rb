require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'library.csv'))
csv = CSV.parse(csv_text, :encoding => 'ISO-8859-1')

Genre.create(name: 'Rock')

csv.map do |row|
  Artist.create(name: row[1])
rescue => e
  e.message
end

csv.map do|row|
  Album.create(title: row[2], artist: Artist.find_by(name: row[1]))
rescue => e
  e.message
end

csv.map do |row|
  Track.create(title: row[0], count: row[3].to_i, rating: row[4].to_i, len: (Time.at(row[5].to_i).utc.strftime "%M:%S"), album: Album.find_by(title: row[2]), genre: Genre.first)
rescue => e
  e.message
end