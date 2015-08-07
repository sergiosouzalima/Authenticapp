require 'rails_helper'

describe UsersController do

  describe "#index" do
    context "when invalid parameters" do
      context "and current_user is nil" do
        it "redirects to users login action" do
          get :index
          expect(response).to redirect_to(:login)
        end
      end
    end
    context "when valid parameters" do
      context "and current_user is filled" do
        it "renders index" do
          email    = 'john_smith@gmail.net'; password = "123456"
          user    = User.create( email: email, password: password )
          session[:user_id] = user.id
          get :index
          expect(response).to render_template(:index)
        end
      end
    end
  end

  describe "#login" do
    it "renders login" do
      get :login
      expect(response).to render_template(:login)
    end
  end

  describe "#authenticate (POST)" do
    context "when invalid parameters" do
      context "user_params is empty" do
        before do
          params = {user: {email: nil, password: nil} }
          post :authenticate, params
        end
        it "redirects to root" do
          expect(response).to redirect_to(:root)
        end
        it "returns 'Usuario ou senha invalida' message to the user" do
          expect(flash[:error]).to eq "Usuário ou senha inválida."
        end
      end
      context "User doesn't exist" do
        before do
          params = {user: {email: "nancy@verizon.net", password: "123456"} }
          email  = 'john_smith@gmail.net'; password = "123456"
          user   = User.create( email: email, password: password )
          post :authenticate, params
        end
        it "redirects to root" do
          expect(response).to redirect_to(:root)
        end
        it "returns 'Usuario ou senha invalida' message to the user" do
          expect(flash[:error]).to eq "Usuário ou senha inválida."
        end
      end
      context "User exists" do
        context "and password is empty" do
          before do
            params = {user: {email: "john_smith@gmail.net", password: nil} }
            email  = 'john_smith@gmail.net'; password = "123456"
            user   = User.create( email: email, password: password )
            post :authenticate, params
          end
          it "redirects to root" do
            expect(response).to redirect_to(:root)
          end
          it "returns 'Usuario ou senha invalida' message to the user" do
            expect(flash[:error]).to eq "Usuário ou senha inválida."
          end
        end
        context "and password is wrong" do
          before do
            params = {user: {email: "john_smith@gmail.net", password: "654321"} }
            email  = 'john_smith@gmail.net'; password = "123456"
            user   = User.create( email: email, password: password )
            post :authenticate, params
          end
          it "redirects to root" do
            expect(response).to redirect_to(:root)
          end
          it "returns 'Usuario ou senha invalida' message to the user" do
            expect(flash[:error]).to eq "Usuário ou senha inválida. Restam 1/5 tentativas"
          end
        end
        context "and failed attempts has reached maximum attempts" do
          before do
            params = {user: {email: "john_smith@gmail.net", password: "123456"} }
            email  = 'john_smith@gmail.net'; password = "123456"
            @user  = User.create( email: email, password: password )
            @user.update failed_attempts: @user.attempts
            post :authenticate, params
          end
          it "redirects to root" do
            expect(response).to redirect_to(:root)
          end
          it "returns 'Usuario bloqueado' message to the user" do
            expect(flash[:error]).to eq "Usuário #{@user.email} bloqueado!"
          end
        end
        context "and failed attempts has exceeded maximum attempts" do
          before do
            params = {user: {email: "john_smith@gmail.net", password: "123456"} }
            email  = 'john_smith@gmail.net'; password = "123456"
            @user  = User.create( email: email, password: password )
            @user.update failed_attempts: @user.attempts + 1
            post :authenticate, params
          end
          it "redirects to root" do
            expect(response).to redirect_to(:root)
          end
          it "returns 'Usuario bloqueado' message to the user" do
            expect(flash[:error]).to eq "Usuário #{@user.email} bloqueado!"
          end
        end
      end
    end

 end

end
