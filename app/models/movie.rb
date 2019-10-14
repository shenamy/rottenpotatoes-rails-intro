class Movie < ActiveRecord::Base
	@all_ratings = {}
	def self.ratings
		@all_ratings = {"G" => 1, "PG" => 1, "PG-13" => 1, "R" => 1}
	end

	def self.with_ratings(ratings)
		self.where({rating: ratings})
	end 
end
