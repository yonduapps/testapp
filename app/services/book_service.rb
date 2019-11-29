class BookService
	include BookHelper
	def initialize(params)
		@params = params
	end

	def index
		books = search.present? ? searched_books : Book.all
		books = books.send("sort_by_#{sort_key}", sort_direction) if sort_key.present?
		books = books.offset(offset).limit(limit) if books.present?
		books
	end

	def show
		raise BookErrors::InvalidBookIsbn.new unless isbn.present?
		queried_book = Book.where(isbn: isbn).first
		raise BookErrors::BookNotFound.new unless queried_book.present?
		queried_book
	end

	def create
		params = book_params
		book = Book.create!(params.slice(:title, :isbn, :publish_date))
		if book.present?
			link_book_to_genres(book, params[:genres])
			link_book_to_authors(book, params[:authors])
		end
		book
	end

	def update
		queried_book = show
		queried_book.update!(book_params)
		queried_book.reload
	end

	def searched_books
		Book.where('title LIKE :search OR isbn LIKE :search OR publish_date LIKE :search', search: "%#{search}%")
	end

	def book_params
		@params.require(:book).permit(:title, :isbn, :publish_date, :search, :genres => [], :authors => [])
	end

	def destroy
		queried_book = show
		queried_book.destroy
	end

	def isbn
		@params[:id]
	end

	def search
		@params[:search]
	end

	def sort_key
		sort_key = @params[:sort_key] ||= 'title'
		raise BookErrors::InvalidBookSortKey.new unless sort_key.present? && Book::SORT_KEYS.include?(sort_key.to_sym)
		sort_key
	end

	def sort_direction
		sort_direction = @params[:sort_direction] ||= 'asc'
		sort_direction = sort_direction.downcase
		raise BookErrors::InvalidBookSortDirection.new unless sort_key.present? && Book::SORT_DIRECTIONS.include?(sort_direction.to_sym)
		sort_direction
	end

	def offset
		offset = @params[:offset] ||= '0'
		offset.to_i
	end

	def limit
		limit = @params[:limit] ||= '10'
		limit.to_i
	end
end