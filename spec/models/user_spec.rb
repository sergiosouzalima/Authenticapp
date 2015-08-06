require 'rails_helper'

RSpec.describe User, type: :model do

  context "attributes validation" do
    context 'email' do
      it { should respond_to :email }
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email) }

      invalid_emails = ["b lah","bälah","b@lah","bülah","bßlah","b!lah","b%lah","b)lah"]
      invalid_emails.each do |s|
        it { should_not allow_value(s).for(:email) }
      end
    end

    context 'password' do
      it { should respond_to :password }
      it { should validate_presence_of(:password) }
      it { should validate_length_of(:password).is_at_least(6) }
      it { should validate_length_of(:password).is_at_most(20) }
    end

    context 'attempts' do
      it { should respond_to :attempts }
    end

    context 'failed_attempts' do
      it { should respond_to :failed_attempts }
    end

    context 'password' do
      it { should respond_to :password }
      it { should validate_presence_of(:password) }
      it { should validate_length_of(:password).is_at_least(6) }
      it { should validate_length_of(:password).is_at_most(20) }
    end

  end

  context '#create' do
    context 'when valid content' do
      before :each do
        @email_01 = 'john_smith@gmail.net'; @password_01 = "123456"
        @email_02 = 'maria-souza@net.net' ; @password_02 = "1234567890"
        @email_03 = 'ana.lima@net.com.br' ; @password_03 = "abdcef-2015"
        @attempts = 5
        @user_01  = User.create( email: @email_01, password: @password_01 )
        @user_02  = User.create( email: @email_02, password: @password_02 )
        @user_03  = User.create( email: @email_03, password: @password_03 )
      end
      it "returns User instances" do
        expect(@user_01).to be_kind_of(User)
        expect(@user_02).to be_kind_of(User)
        expect(@user_03).to be_kind_of(User)
      end
      it "returns 3 User records, with correct attributes" do
        expect(@user_01.email).to        eq @email_01
        expect(@user_02.email).to        eq @email_02
        expect(@user_03.email).to        eq @email_03
        expect(@user_01.password).to     eq @password_01
        expect(@user_02.password).to     eq @password_02
        expect(@user_03.password).to     eq @password_03
      end
      it "returns 3 User records, with correct attempts attributes" do
        expect(@user_01.attempts).to     eq @attempts
        expect(@user_02.attempts).to     eq @attempts
        expect(@user_03.attempts).to     eq @attempts
      end
      it "returns 3 User records, with correct failed_attempts attributes" do
        expect(@user_01.failed_attempts).to     eq 0
        expect(@user_02.failed_attempts).to     eq 0
        expect(@user_03.failed_attempts).to     eq 0
      end
      context 'and email already exists' do
        before :each do
          @email_01 = 'john_smith@net.com'     ; @password_01 = "123456"
          @email_02 = 'john_smith@net.com'     ; @password_01 = "1234567890"
          @user_01  = User.create( email: @email_01, password: @password_01 )
          @user_02  = User.new( email: @email_02, password: @password_02 )
        end
        it "returns valid? false" do
          expect(@user_01.valid?).to be_truthy
          expect(@user_02.valid?).to be_falsy
        end
        it "returns error messages" do
          expect(@user_01.errors.messages.empty?).to be_truthy
          @user_02.save
          expect(@user_02.errors.messages.empty?).to be_falsy
        end
      end
    end
    context 'when invalid content' do
      before :each do
        @email_01 = 'john_smith@.net'     ; @password_01 = "12345"
        @email_02 = 'maria-souza@net.net' ; @password_02 = "12"
        @email_03 = 'ana.lima@net'        ; @password_03 = "ab"
        @email_04 = 'ana.lima@net.com'    ; @password_04 = nil
        @email_05 = ''                    ; @password_05 = "abcdefgh"
        @email_06 = 'ana.lima@net.com.br' ; @password_06 = "1" * 30
        @user_01  = User.new( email: @email_01, password: @password_01 )
        @user_02  = User.new( email: @email_02, password: @password_02 )
        @user_03  = User.new( email: @email_03, password: @password_03 )
        @user_04  = User.new( email: @email_04, password: @password_04 )
        @user_05  = User.new( email: @email_05, password: @password_05 )
        @user_06  = User.new( email: @email_06, password: @password_06 )
      end
      it "returns valid? false" do
        expect(@user_01.valid?).to be_falsy
        expect(@user_02.valid?).to be_falsy
        expect(@user_03.valid?).to be_falsy
        expect(@user_04.valid?).to be_falsy
        expect(@user_05.valid?).to be_falsy
        expect(@user_06.valid?).to be_falsy
      end
      it "returns error messages" do
        @user_01.save
        expect(@user_01.errors.messages.empty?).to be_falsy
        @user_02.save
        expect(@user_02.errors.messages.empty?).to be_falsy
        @user_03.save
        expect(@user_03.errors.messages.empty?).to be_falsy
        @user_04.save
        expect(@user_04.errors.messages.empty?).to be_falsy
        @user_05.save
        expect(@user_05.errors.messages.empty?).to be_falsy
        @user_06.save
        expect(@user_05.errors.messages.empty?).to be_falsy
      end
    end
  end

  context '#authenticate' do
    context 'when user has reached maximum invalid attempts' do
      before :each do
        @attempts = 5
        @email = 'john_smith@gmail.net'; @password = "123456"; @failed_attempts = @attempts + 1
        @user  = User.create( email: @email, password: @password )
        @user.update failed_attempts: @failed_attempts
      end
      it "returns User instance" do
        expect(User.authenticate(@user.email, @user.password)).to be_kind_of(User)
      end
      it "returns User record, with correct attributes" do
        user = User.authenticate(@user.email, @user.password)
        expect(user.email).to    eq @email
        expect(user.password).to eq @password
        expect(user.failed_attempts).to be >= @attempts
      end
      it "returns failed_attempts >= 5" do
        expect(User.authenticate(@user.email, @user.password).failed_attempts).to be >= @attempts
      end
    end
    context 'when valid parameters' do
      before :each do
        @attempts = 5
        @email_01 = 'john_smith@gmail.net'; @password_01 = "123456"
        @email_02 = 'maria-souza@net.net' ; @password_02 = "1234567890"
        @email_03 = 'ana.lima@net.com.br' ; @password_03 = "abdcef-2015"
        @user_01  = User.create( email: @email_01, password: @password_01 )
        @user_02  = User.create( email: @email_02, password: @password_02 )
        @user_03  = User.create( email: @email_03, password: @password_03 )
      end
      it "returns User instances" do
        expect(User.authenticate(@user_01.email, @user_01.password)).to be_kind_of(User)
        expect(User.authenticate(@user_02.email, @user_02.password)).to be_kind_of(User)
        expect(User.authenticate(@user_03.email, @user_03.password)).to be_kind_of(User)
      end
      it "returns User records, with correct attributes" do
        user = User.authenticate(@user_01.email, @user_01.password)
        expect(user.email).to    eq @email_01
        expect(user.password).to eq @password_01
        expect(user.attempts).to eq @attempts
      end
      it "returns failed_attempts equal to zero" do
        expect(User.authenticate(@user_01.email, @user_01.password).failed_attempts).to eq 0
      end
      context 'and wrong password' do
        before :each do
          @email = 'john_smith@gmail.net'; @password = "123456"
          @user  = User.create( email: @email, password: @password )
        end
        it "returns User instance" do
          expect(User.authenticate(@user.email, "000000")).to be_kind_of(User)
        end
        it "returns failed_attempts greater then zero" do
          expect(User.authenticate(@user.email, "000000").failed_attempts).to be > 0
        end
        it "returns failed_attempts incrementally from 0 to 5" do
          expect(User.authenticate(@user.email, "000000").failed_attempts).to eq 1
          expect(User.authenticate(@user.email, "000000").failed_attempts).to eq 2
          expect(User.authenticate(@user.email, "000000").failed_attempts).to eq 3
          expect(User.authenticate(@user.email, "000000").failed_attempts).to eq 4
          expect(User.authenticate(@user.email, "000000").failed_attempts).to eq 5
        end
      end
    end
    context 'when invalid parameters' do
      context "and at least one parameter isn't present" do
        it "returns nil" do
          user = User.authenticate( nil, nil )
          expect(user).to be_nil
        end
      end
      context "and user doesn't exist" do
        it "returns nil" do
          email = 'john_smith@gmail.net'; password = "123456"
          User.create( email: 'sergio@gmail.com', password: password )
          result = User.authenticate( email, password )
          expect(result).to be_nil
        end
      end
    end
  end
end

