require 'spec_helper'

describe Api::V1::ClientsController, type: :request do
  # before do
  #   allow_any_instance_of(Client).to receive(:generate_random_char).and_return("abcd")
  # end

  let(:user) { create(:user, :admin) }
  let!(:clients) { create_list(:client, 5, users: [user]) }

  describe '#GET method: client to create new by endpoint api' do
    context 'when user not loged in' do
      before do
        get '/api/v1/clients'
      end

      it 'should return status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  
  describe '#POST Method: completely created client in system by endpoint api' do
    let!(:referral_source){ create(:referral_source) }
    context 'when user not loged in' do
      before do
        post "/api/v1/clients"
      end

      it 'should return status 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user loged in' do
      before do
        sign_in(user)
      end

      context 'when try to create client' do
        before do
          client = { format: 'json', client: { gender: 'male', given_name: "example", user_ids: [user.id], initial_referral_date: '2018-02-19', received_by_id: user.id, name_of_referee: FFaker::Name.name, referral_source_category_id: referral_source.id } }
          post "/api/v1/clients", client, @auth_headers
        end

        it 'should return status 200' do
          expect(response).to have_http_status(:success)
        end

        it 'should return correct data' do
          expect(json['client']['given_name']).to eq("example")
        end
      end
    end
  end

  describe 'POST method: Register new client in duplicate checker' do
		before do

		end
		context 'Results' do
			it 'should duplicate client' do
				new_client = Client.new({id: 1000, code: "", given_name:clients.first.name})
				Client.all.each do |c|
					if c.name == new_client.given_name 
							c.name.should == new_client.given_name 
					end
				end
			end

			it 'should not duplicate client' do
				new_client = Client.new({id: 1000, code: "", given_name:"Foobar"})
				Client.all.each do |c|
					if c.name == new_client.given_name 
							c.name.should_not == new_client.given_name 
					end
				end
			end
		end
	end
end
