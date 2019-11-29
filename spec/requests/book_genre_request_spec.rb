require 'rails_helper'

RSpec.describe GenreModule, type: :request do
	describe '#index' do
		context 'show genre list' do
			count = 5
			before :each do
				count.times do | i |
					Genre.create!(name: "Genre_#{i}")
				end
			end
			it 'successful' do
				get '/book/genres'
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['genres'].count).to eq count
			end
		end
	end
	describe '#show' do
		context 'fetch existing genre' do
			let!(:name) { 'Fiction' }
			let!(:genre) { Genre.create!(name: name) }
			it 'successful' do
				get "/book/genres/#{genre.id}"
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['genre']['name']).to eq name.downcase
			end
		end
		context 'fetch not existing genre' do
			it 'successful' do
				get "/book/genres/1"
				expect(status).to eq 404
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['error']).to eq BookErrors::BookGenreNotFound.name.demodulize
			end
		end
	end
	describe '#create' do
		context 'new genre' do
			let!(:name) { 'Fiction' }
			it 'successful' do
				post '/book/genres', params: { genre: { name: name } }
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['genre']['name']).to eq name.downcase
			end
		end

		context 'new genre with invalid name' do
			let!(:name) { 'Fiction' }
			it 'failed' do
				post '/book/genres', params: { genre: { name: '' } }
				expect(status).to eq 422
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['error']).to eq BookErrors::InvalidBookGenre.name.demodulize
			end
		end
	end
	describe '#update' do
		context 'existing genre' do
			let!(:genre) { Genre.create!(name: 'Fiction') }
			let!(:expected) { 'Scifi' }
			it 'successful' do
				expect(Genre.count).to eq 1
				put "/book/genres/#{genre.id}", params: { genre: { name: expected } }
				expect(status).to eq 200
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['genre']['name']).to eq expected.downcase
			end
		end
		context 'non-existing genre' do
			it 'failed' do
				expect(Genre.count).to eq 0
				put '/book/genres/1'
				expect(status).to eq 404
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['error']).to eq BookErrors::BookGenreNotFound.name.demodulize
			end
		end
	end
	describe '#destroy' do
		context 'existing genre' do
			let!(:genre) { Genre.create!(name: 'Fiction') }
			it 'successful' do
				expect(Genre.count).to eq 1
				delete "/book/genres/#{genre.id}"
				expect(Genre.count).to eq 0
			end
		end
		context 'non-existing genre' do
			it 'failed' do
				expect(Genre.count).to eq 0
				delete '/book/genres/1'
				expect(status).to eq 404
				parsed_response = JSON.parse(response.body)
				expect(parsed_response['error']).to eq BookErrors::BookGenreNotFound.name.demodulize
			end
		end
	end
end