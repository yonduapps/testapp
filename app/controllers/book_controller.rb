class BookController < ApplicationController
	include GenreModule

	rescue_from BookErrors::BookNotFound, with: error_handler(:not_found)
	rescue_from BookErrors::BookGenreNotFound, with: error_handler(:not_found)
	rescue_from BookErrors::BookAuthorNotFound, with: error_handler(:not_found)
	rescue_from BookErrors::InvalidBookTitle, with: error_handler(:unprocessable_entity)
	rescue_from BookErrors::InvalidBookIsbn, with: error_handler(:unprocessable_entity)
	rescue_from BookErrors::InvalidBookPublishDate, with: error_handler(:unprocessable_entity)
	rescue_from BookErrors::InvalidBookSortKey, with: error_handler(:unprocessable_entity)
	rescue_from BookErrors::InvalidBookSortDirection, with: error_handler(:unprocessable_entity)
	rescue_from BookErrors::InvalidBookAuthor, with: error_handler(:unprocessable_entity)
	rescue_from BookErrors::InvalidBookGenre, with: error_handler(:unprocessable_entity)

	def index
		render json: { books: book_service.index }
	end

	def create
		render json: { book: book_service.create }
	end

	def show
		render json: { book: book_service.show }
	end

	def update
		render json: { book: book_service.update }
	end

	def destroy
		render json: { book: book_service.destroy }
	end

	def book_service
		BookService.new(params)
	end
end
