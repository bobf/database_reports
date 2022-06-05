# frozen_string_literal: true

RSpec.describe '/users' do
  before { sign_in user }

  describe 'GET /users' do
    before { create(:user, email: 'user@example.com') }
    before { sign_in user }

    context 'regular user' do
      let(:user) { create(:user) }

      it 'does not provide access to users index' do
        get '/users'
        expect(document).to match_text 'You are not authorized to access this page.'
      end

      it 'does not show list of users' do
        get '/users'
        expect(document.tr('user')).to_not match_text 'user@example.com'
      end
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'shows list of users' do
        get '/users'
        expect(document.tr('.user')).to match_text 'user@example.com'
      end
    end
  end

  describe 'GET /users/:id' do
    let!(:other_user) { create(:user, email: 'user@example.com') }

    context 'regular user' do
      let(:user) { create(:user) }

      it 'does not provide access to user show page' do
        get "/users/#{other_user.id}"
        expect(document).to match_text 'You are not authorized to access this page.'
      end

      it 'does not show user information' do
        get "/users/#{other_user.id}"
        expect(document.table('.user')).to_not match_text 'user@example.com'
      end
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'shows user information' do
        get "/users/#{other_user.id}"
        expect(document.table('.user')).to match_text 'user@example.com'
      end
    end
  end

  describe 'GET /users/:id/edit' do
    let!(:other_user) { create(:user, email: 'user@example.com') }

    context 'regular user' do
      let(:user) { create(:user) }

      it 'does not provide access to user edit page' do
        get "/users/#{other_user.id}/edit"
        expect(document).to match_text 'You are not authorized to access this page.'
      end

      it 'does not show user form' do
        get "/users/#{other_user.id}/edit"
        expect(document.form('.user')).to_not match_text 'user@example.com'
      end
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'shows user form' do
        get "/users/#{other_user.id}/edit"
        expect(document.form('.user').input(name: 'user[email]')[:value]).to eql 'user@example.com'
      end
    end
  end

  describe 'PATCH /users/:id' do
    let!(:other_user) { create(:user, email: 'user@example.com') }

    context 'regular user' do
      let(:user) { create(:user) }

      it 'does not provide access to updating user' do
        patch "/users/#{other_user.id}", params: { user: { email: 'updated-user@example.com' } }
        expect(document).to match_text 'You are not authorized to access this page.'
      end

      it 'does not update user information' do
        patch "/users/#{other_user.id}", params: { user: { email: 'updated-user@example.com' } }
        expect(document.table('.user')).to_not match_text 'updated-user@example.com'
      end
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'does not update user information' do
        patch "/users/#{other_user.id}", params: { user: { email: 'updated-user@example.com' } }
        expect(document.table('.user')).to match_text 'updated-user@example.com'
      end
    end
  end

  describe 'GET /users/:id/new' do
    context 'regular user' do
      let(:user) { create(:user) }

      it 'does not provide access to new user page' do
        get '/users/new'
        expect(document).to match_text 'You are not authorized to access this page.'
      end

      it 'does not show new user form' do
        get '/users/new'
        expect(document.form('.user').input(name: 'user[email]')).to_not exist
      end
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'shows user form' do
        get '/users/new'
        expect(document.form('.user').input(name: 'user[email]')).to exist
      end
    end
  end

  describe 'CREATE /users' do
    context 'regular user' do
      let(:user) { create(:user) }

      it 'does not provide access to updating user' do
        post '/users', params: { user: { email: 'new-user@example.com' } }
        expect(document).to match_text 'You are not authorized to access this page.'
      end

      it 'does not update user information' do
        post '/users', params: { user: { email: 'new-user@example.com' } }
        expect(document.table('.user')).to_not match_text 'new-user@example.com'
      end
    end

    context 'admin user' do
      let(:user) { create(:user, admin: true) }

      it 'does not update user information' do
        post '/users', params: { user: { email: 'new-user@example.com' } }
        expect(document.table('.user')).to match_text 'new-user@example.com'
      end
    end
  end

  describe 'DELETE /users/:id' do
    let!(:other_user) { create(:user, email: 'user@example.com') }

    context 'regular user' do
      let(:user) { create(:user) }

      it 'does not provide access to user deletion' do
        delete "/users/#{other_user.id}"
        expect(document).to match_text 'You are not authorized to access this page.'
      end

      it 'does not delete user' do
        delete "/users/#{other_user.id}"
        expect(other_user.reload).to_not be_deleted
      end
    end

    context 'admin user' do
      let(:user) { create(:user, email: 'admin@example.com', admin: true) }

      it 'displays to users list' do
        delete "/users/#{other_user.id}"
        expect(document.table('.users')).to match_text 'admin@example.com'
        expect(document.table('.users')).to_not match_text 'user@example.com'
      end

      it 'shows user information' do
        delete "/users/#{other_user.id}"
        expect(other_user.reload).to be_deleted
      end
    end
  end
end
