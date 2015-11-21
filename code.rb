#YOUR CODE GOES HERE
require 'pg'
require 'csv'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "ingredient")
    yield(connection)
  ensure
    connection.close
  end
end


@ingredients = []
    CSV.foreach("ingredients.csv") do |ingredient|
      @ingredients << ingredient
    end

@ingredients.each do |ingredient|
  db_connection do |conn|
    conn.exec_params("INSERT INTO ingredients (number, name)
    VALUES ($1, $2)", [ingredient[0],ingredient[1]])
  end
end
#display

db_connection do |conn|
  @ingredients_from_table = conn.exec ("SELECT number, name FROM ingredients")
end

@ingredients_from_table.each do |ingredient|
  puts "#{ingredient["number"]}. #{ingredient["name"]}"
end
