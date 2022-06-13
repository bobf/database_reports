# frozen_string_literal: true

RSpec.describe '/databases' do
  before { sign_in user }

  describe 'GET /databases' do
    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'provides list of configured databases' do
        create(:database, name: 'my database')
        get '/databases'
        expect(document.table('.databases')).to match_text 'my database'
      end
    end

    context 'non-admin user' do
      let(:user) { create(:user) }

      it 'does not list databases' do
        create(:database, name: 'my database')
        get '/databases'
        expect(document.table('.databases')).to_not match_text 'my database'
      end

      it 'provides an authorization error message' do
        get '/databases'
        expect(document).to match_text 'You are not authorized to access this page.'
      end
    end
  end

  describe 'POST /databases' do
    let(:database_params) do
      {
        name: 'my database',
        database: 'my_database',
        username: 'user',
        password: 'password',
        host: 'database.example.com',
        port: '12345',
        description: 'My database for storing data.'
      }
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'creates a new database' do
        post '/databases', params: { database: database_params }
        expect(Database.first.database).to eql 'my_database'
      end
    end

    context 'non-admin user' do
      let(:user) { create(:user) }
      it 'does not create a new database' do
        post '/databases', params: { database: database_params }
        expect(Database.count).to be_zero
      end
    end
  end

  describe 'GET /databases/:id' do
    let!(:database) { create(:database, name: 'my database') }

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'shows database information' do
        get "/databases/#{database.id}"
        expect(document.table('.database')).to match_text 'my database'
      end
    end

    context 'non-admin user' do
      let(:user) { create(:user) }

      it 'does not show database information' do
        get "/databases/#{database.id}"
        expect(document.table('.databases')).to_not match_text 'my database'
      end

      it 'provides an authorization error message' do
        get "/databases/#{database.id}"
        expect(document).to match_text 'You are not authorized to access this page.'
      end
    end
  end

  describe 'PATCH /databases/:id' do
    let!(:database) { create(:database, name: 'my database') }
    let(:database_params) { { name: 'my updated database' } }

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'updates database configuration' do
        patch "/databases/#{database.id}", params: { database: database_params }
        expect(document.table('.database')).to match_text 'my updated database'
      end
    end

    context 'non-admin user' do
      let(:user) { create(:user) }

      it 'does not update database information' do
        get "/databases/#{database.id}"
        expect(database.reload.name).to eql 'my database'
      end

      it 'provides an authorization error message' do
        get "/databases/#{database.id}"
        expect(document).to match_text 'You are not authorized to access this page.'
      end
    end
  end

  describe 'GET /databases/new' do
    let(:database_params) do
      {
        name: 'my database',
        adapter: 'mysql',
        database: 'my_database',
        username: 'username',
        password: 'password',
        host: 'example.org',
        port: '5000'
      }
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'displays database form' do
        get '/databases/new'
        expect(document.form('.database')).to exist
      end
    end

    context 'non-admin user' do
      let(:user) { create(:user) }

      it 'does not display database form' do
        get '/databases/new'
        expect(document.form('.database')).to_not exist
      end

      it 'provides an authorization error message' do
        get '/databases/new'
        expect(document).to match_text 'You are not authorized to access this page.'
      end
    end
  end

  describe 'GET /databases/edit/:id' do
    let!(:database) { create(:database, database: 'my_database') }

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'displays database form' do
        get "/databases/#{database.id}/edit"
        expect(document.form('.database').input(name: 'database[database]')[:value]).to eql 'my_database'
      end
    end

    context 'non-admin user' do
      let(:user) { create(:user) }

      it 'does not display database form' do
        get "/databases/#{database.id}/edit"
        expect(document.form('.database')).to_not exist
      end

      it 'provides an authorization error message' do
        get "/databases/#{database.id}/edit"
        expect(document).to match_text 'You are not authorized to access this page.'
      end
    end
  end

  describe 'DELETE /databases/:id' do
    let!(:database) { create(:database, name: 'my database') }

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'deletes database configuration' do
        delete "/databases/#{database.id}"
        expect { database.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'non-admin user' do
      let(:user) { create(:user) }

      it 'does not delete database configuration' do
        delete "/databases/#{database.id}"
        expect(database.reload).to be_present
      end

      it 'deletes database configuration' do
        delete "/databases/#{database.id}"
        expect(document).to match_text 'You are not authorized to access this page.'
      end
    end
  end
end
