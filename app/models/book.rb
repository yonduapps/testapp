class Book < ApplicationRecord
	include BookHelper

	SORT_KEYS = %i[ title isbn publish_date ].freeze
	SORT_DIRECTIONS = %i[ asc desc ].freeze

	has_many :book_genres, dependent: :delete_all
	has_many :genres, through: :book_genres
	has_many :book_authors, dependent: :delete_all
	has_many :authors, through: :book_authors

	scope :sort_by_title, -> (direction) { order(title: direction) }
	scope :sort_by_isbn, -> (direction) { order(isbn: direction) }
	scope :sort_by_publish_date, -> (direction) { order(publish_date: direction) }

	validates :title, presence: true
	validates :isbn, presence: true, uniqueness: true
	validates :publish_date, presence: true

	after_validation :after_validation

	def after_validation
		raise BookErrors::InvalidBookTitle if self.errors.include?(:title)
		raise BookErrors::InvalidBookIsbn if self.errors.include?(:isbn) || valid_isbn?(self.isbn) == false
		raise BookErrors::InvalidBookPublishDate if self.errors.include?(:publish_date)
	end
end
