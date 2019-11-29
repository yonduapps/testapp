module BookHelper
	# For ISBN-10 and ISBN-13 pattern
	# Reference: https://howtodoinjava.com/regex/java-regex-validate-international-standard-book-number-isbns/
	ISBN_PATTERN = '^(?:ISBN(?:-1[03])?:? )?(?=[0-9X]{10}$|(?=(?:[0-9]+[- ]){3})[- 0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[- ]){4})[- 0-9]{17}$)(?:97[89][- ]?)?[0-9]{1,5}[- ]?[0-9]+[- ]?[0-9]+[- ]?[0-9X]$'

	def valid_publish_date?(value)
		return false unless value.present?
		parseable = true
		begin 
			DateTime.parse(value)
		rescue ArgumentError
			parseable = false
		end
		parseable
	end

	def valid_isbn?(value)
		return false unless value.present? && value.match(ISBN_PATTERN).present?
		true
	end

	def valid_genres?(genres)
		return true if genres.present? && genres.is_a?(Array) && genres.count > 0
		raise BookErrors::InvalidBookGenre.new
	end

	def link_book_to_genres(book, genres)
		if book.present? && valid_genres?(genres)
			genres = genres.map(&:downcase)
			queried_genres = Genre.where(name: genres)
			queried_genres.each do | genre |
				BookGenre.create!(book: book, genre: genre)
			end if queried_genres.present?
		end
	end

	def valid_authors?(authors)
		return true if authors.present? && authors.is_a?(Array) && authors.count > 0
		raise BookErrors::InvalidBookAuthor.new
	end

	def link_book_to_authors(book, authors)
		if book.present? && valid_authors?(authors)
			authors = authors.map(&:downcase)
			queried_authors = Author.where(name: authors)
			queried_authors.each do | author |
				BookAuthor.create!(book: book, author: author)
			end if queried_authors.present?
		end
	end
end
