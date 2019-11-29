require 'rails_helper'

RSpec.describe BookController, type: :request do
	# Test ISBN
	let!(:valid_isbn) { '978-1-4302-1998-9' }

	describe '#index' do
		count = 10
		let!(:isbn_test) { '978-1-4302-1998-' }
		context 'fetch book list' do
			before :each do
				count.times do | i |
					Book.create!(title: "title_#{i}", isbn: "#{isbn_test}#{i}", publish_date: DateTime.now)
				end
			end
			it 'successfully' do
				get '/books'
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['books']).to_not eq nil
				expect(parsed_response['books'].count).to eq count
			end
		end

		context 'fetch book list sorted by' do
			before :each do
				count.times do | i |
					Book.create!(title: "title_#{i}", isbn: "#{isbn_test}#{i}", publish_date: rand(10.years).seconds.ago)
				end
			end
			it 'title successfully (ASC SORT)' do
				get '/books?sort_key=title&sort_direction=asc'
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['books']).to_not eq nil
				expect(parsed_response['books'].count).to eq count
			end
			it 'title successfully (DESC SORT)' do
				get '/books?sort_key=title&sort_direction=desc'
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['books']).to_not eq nil
				expect(parsed_response['books'].count).to eq count
			end
			it 'ISBN successfully (ASC SORT)' do
				get '/books?sort_key=isbn&sort_direction=asc'
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['books']).to_not eq nil
				expect(parsed_response['books'].count).to eq count
			end
			it 'ISBN successfully (DESC SORT)' do
				get '/books?sort_key=isbn&sort_direction=desc'
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['books']).to_not eq nil
				expect(parsed_response['books'].count).to eq count
			end
			it 'publish date successfully (ASC SORT)' do
				get '/books?sort_key=publish_date&sort_direction=asc'
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['books']).to_not eq nil
				expect(parsed_response['books'].count).to eq count
			end
			it 'publish date successfully (DESC SORT)' do
				get '/books?sort_key=publish_date&sort_direction=desc'
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['books']).to_not eq nil
				expect(parsed_response['books'].count).to eq count
			end
		end

		context 'fetch book list with invalid sort key' do
			it 'failed' do
				get '/books?sort_key=asdf&sort_direction=desc'
				expect(status).to eq 422
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['error']).to eq BookErrors::InvalidBookSortKey.name.demodulize
			end
		end

		context 'fetch book list with invalid sort direction' do
			it 'failed' do
				get '/books?sort_key=title&sort_direction=asdf'
				expect(status).to eq 422
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['error']).to eq BookErrors::InvalidBookSortDirection.name.demodulize
			end
		end
	end

	describe '#show' do 
		context 'specific book' do
			let!(:title) { 'Title' }
			let!(:publish_date) { DateTime.now }
			let!(:book) { Book.create(title: 'Title', isbn: valid_isbn, publish_date: publish_date) }
			it 'successful' do
				get "/books/#{book.isbn}"
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['book']['title']).to eq title
				expect(parsed_response['book']['isbn']).to eq valid_isbn
				expect(DateTime.parse(parsed_response['book']['publish_date']).to_i).to eq publish_date.to_i
			end
			it 'failed (non-existing isbn)' do
				get '/books/123-123-123'
				expect(status).to eq 404
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['error']).to eq BookErrors::BookNotFound.name.demodulize
			end
		end
	end

	describe '#create' do
		context 'book with valid parameters' do
			let!(:title) { 'Sample Title' }
			let!(:genres) { ['Fiction', 'Comedy' ] }
			let!(:authors) { ['John Doe', 'Jane Doe' ] }
			let!(:publish_date) { DateTime.now }
			before :each do
				Genre.create!( [{ name: 'Fiction' }, { name: 'Comedy' }] )
				Author.create!( [{ name: 'John Doe' }, { name: 'Jane Doe' }] )
			end
			it 'successful' do
				expect(Book.count).to eq 0
				post '/books', params: { book: { title: title, isbn: valid_isbn, genres: genres, authors: authors, publish_date: publish_date } }
				expect(status).to eq 200
				expect(Book.count).to eq 1
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['book']['isbn']).to eq valid_isbn	
				expect(parsed_response['book']['title']).to eq title
				expect(DateTime.parse(parsed_response['book']['publish_date']).to_i).to eq publish_date.to_i
				expect(BookGenre.where(book_id: parsed_response['book']['id']).count).to eq genres.count
				expect(BookAuthor.where(book_id: parsed_response['book']['id']).count).to eq authors.count
			end
		end
		context 'book with' do
			let!(:title) { 'Sample Title' }
			let!(:genre) { 'Sample Genre' }
			let!(:publish_date) { DateTime.now }
			let!(:invalid_string_param) { [ '', nil ] }
			context 'invalid title' do
				it 'failed' do
					invalid_string_param.each do | val |
						post '/books', params: { book: { title: val, isbn: valid_isbn, genre: genre, publish_date: publish_date } }
						expect(status).to eq 422
						expect(Book.count).to eq 0
						parsed_response = JSON.parse(response.body)
						expect(parsed_response['error']).to eq BookErrors::InvalidBookTitle.name.demodulize
					end
				end
			end
			context 'invalid isbn' do
				let!(:invalid_isbn_formats) { [ SecureRandom.hex, '123-123-123'] }
				it 'failed' do
					invalid_isbn_formats.each do | val |
						post '/books', params: { book: { title: title, isbn: val, publish_date: publish_date } }
						expect(status).to eq 422
						expect(Book.count).to eq 0
						parsed_response = JSON.parse(response.body)
						expect(parsed_response['error']).to eq BookErrors::InvalidBookIsbn.name.demodulize
					end
				end
			end
			context 'invalid publish date' do
				let!(:invalid_datetime) { [ '', nil, 'asd' ] }
				it 'failed' do
					invalid_datetime.each do | val |
						post '/books', params: { book: { title: title, isbn: valid_isbn, publish_date: val } }
						expect(status).to eq 422
						expect(Book.count).to eq 0
						parsed_response = JSON.parse(response.body)
						expect(parsed_response['error']).to eq BookErrors::InvalidBookPublishDate.name.demodulize
					end
				end
			end
		end
	end

	describe '#update' do
		context 'existing book\'s' do
			context 'with valid title' do
				let!(:old_title) { 'old_title' }
				let!(:new_title) { 'New Title' }
				let!(:book) { Book.create!(title: old_title, isbn: valid_isbn, publish_date: DateTime.now) }
				let!(:payload) {
					{
						book: 
						{
							title: new_title
						}
					}
				}
				it 'successful' do
					expect(book.title). to eq old_title
					put "/books/#{book.isbn}", params: payload
					expect(status).to eq 200
					book.reload
					expect(book.title). to eq new_title
					parsed_response = JSON.parse(body)
					expect(parsed_response['book']['title']).to eq new_title
				end
			end
			context 'with invalid' do
				context 'title' do
					let!(:old_title) { 'old_title' }
					let!(:book) { Book.create!(title: old_title, isbn: valid_isbn, publish_date: DateTime.now) }
					let!(:payload) { { book: { title: '' } } }
					it 'failed' do
						expect(book.title). to eq old_title
						put "/books/#{book.isbn}", params: payload
						expect(status).to eq 422
						book.reload
						expect(book.title). to eq old_title
					end
				end

				context 'isbn' do
					let!(:old_isbn) { valid_isbn }
					let!(:book) { Book.create!(title: 'Title', isbn: old_isbn, publish_date: DateTime.now) }
					let!(:payload) { { book: { isbn: '' } } }
					it 'failed' do
						expect(book.isbn). to eq old_isbn
						put "/books/#{book.isbn}", params: payload
						expect(status).to eq 422
						book.reload
						expect(book.isbn). to eq old_isbn
					end
				end

				context 'publish date' do
					let!(:old_publishdate) { DateTime.now }
					let!(:book) { Book.create!(title: 'Title', isbn: valid_isbn, publish_date: old_publishdate) }
					let!(:payload) { { book: { isbn: '' } } }
					it 'failed' do
						expect(book.publish_date). to eq old_publishdate
						put "/books/#{book.isbn}", params: payload
						expect(status).to eq 422
						book.reload
						expect(book.publish_date). to eq old_publishdate
					end
				end
			end
		end
	end

	describe '#destroy' do
		context 'existing book' do
			let!(:book) { Book.create!(title: 'Sample Title', isbn: valid_isbn, publish_date: DateTime.now) }
			it 'successfully' do
				expect(Book.count).to eq 1
				delete "/books/#{book.isbn}"
				expect(Book.count).to eq 0
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['book']['id']).to eq book.id
				expect(parsed_response['book']['isbn']).to eq book.isbn
			end
		end
		context 'not existing book' do
			let!(:book_isbn) { valid_isbn }
			it 'failed' do
				delete "/books/#{book_isbn}"
				expect(status).to eq 404
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['error']).to eq BookErrors::BookNotFound.name.demodulize
			end
		end
		context 'existing book and its linked models' do
			let!(:title) { 'Sample Title' }
			let!(:publish_date) { DateTime.now }
			let!(:genres) { [ 'Fiction', 'Scifi' ] }
			let!(:authors) { [ 'John Doe', 'Jane Doe' ] }
			before :each do
				genres.each do | genre |
					Genre.create!(name: genre)
				end
				authors.each do | author |
					Author.create!(name: author)
				end
			end
			it 'successfully' do
				# create a book first
				post '/books', params: { book: { title: title, isbn: valid_isbn, genres: genres, authors: authors, publish_date: publish_date } }
				expect(status).to eq 200
				expect(Book.count).to eq 1
				expect(BookGenre.count).to eq 2
				expect(BookAuthor.count).to eq 2
				parsed_response = JSON.parse(response.body)
				book_isbn = parsed_response['book']['isbn']

				# delete the book
				delete "/books/#{book_isbn}"
				expect(status).to eq 200
				expect(Book.count).to eq 0
				expect(BookGenre.count).to eq 0
				expect(BookAuthor.count).to eq 0
			end
		end
	end
end
