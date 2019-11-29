class Author < ApplicationRecord
	has_many :book_authors, dependent: :delete_all
	has_many :books, through: :book_authors

	validates :name, presence: true, uniqueness: true
	after_validation :after_validation
	before_save :downcase_name

	private 

	def after_validation
		raise BookErrors::InvalidBookAuthor.new if self.errors.include?(:name)
	end

	def downcase_name
		self.name = self.name.downcase
	end
end
