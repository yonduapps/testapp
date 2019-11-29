module GenreModule

	def index_genre
		genres = Genre.all
		render json: { genres: genres }
	end

	def show_genre
		render json: { genre: genre }
	end

	def create_genre
		genre = Genre.create!(genre_params)
		render json: { genre: genre }
	end

	def update_genre
		genre.update!(genre_params)
		render json: { genre: genre.reload }
	end

	def destroy_genre
		render json: genre.delete
	end

	def genre
		fetched_genre = Genre.where(id: id).first
		raise BookErrors::BookGenreNotFound.new unless fetched_genre.present?
		fetched_genre
	end

	def genre_params
		params.require(:genre).permit(:name)
	end

	def id
		params[:id]
	end
end