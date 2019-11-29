module BookErrors
	class BookError < StandardError
		:attrib_reader
		def initialize(extra = {})
			@extra = extra
		end
	end

	BookNotFound = Class.new BookError
	BookGenreNotFound = Class.new BookError
	BookAuthorNotFound = Class.new BookError
	InvalidBookIsbn = Class.new BookError
	InvalidBookTitle = Class.new BookError
	InvalidBookPublishDate = Class.new BookError
	InvalidBookSortKey = Class.new BookError
	InvalidBookSortDirection = Class.new BookError
	InvalidBookAuthor = Class.new BookError
	InvalidBookGenre = Class.new BookError
end