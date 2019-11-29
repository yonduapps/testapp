class Genre < ApplicationRecord
	has_many :book_genres, dependent: :delete_all
	has_many :books, through: :book_genres

	validates :name, presence: true, uniqueness: true
	after_validation :after_validation
	before_save :downcase_name

	private 

	def after_validation
		raise BookErrors::InvalidBookGenre.new if self.errors.include?(:name)
	end

	def downcase_name
		self.name = self.name.downcase
	end
end
