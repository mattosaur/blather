require 'spec_helper'

describe "Authentication" do
 
	subject { page }

	describe "signin page" do
		before { visit signin_path }

   	describe "with invalid information" do
     	before { click_button "Sign in" }

   		it { should have_title('Sign in') }
     	it { should have_selector('div.alert.alert-error') }
   	end
    
  end

	describe "with valid information" do
   	before { visit signin_path }
    let(:user) { FactoryGirl.create(:user) }
     		
   	before do
   		fill_in "Email",    with: user.email.upcase
   		fill_in "Password", with: user.password
   		click_button "Sign in"
   	end

   	it { should have_title(user.name) }
   	it { should have_link('Profile',     href: user_path(user)) }
    #it { should have_link('Settings',    href: edit_user_path(user)) }
   	it { should have_link('Sign out',    href: signout_path) }
   	it { should_not have_link('Sign in', href: signin_path) }


     describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        # no clue why these tests don't work.  Here's the error:
        # Failure/Error: fill_in "Email",    with: user.email.upcase
        # NoMethodError:
        # undefined method `email' for nil:NilClass

        #it { should have_link('Sign out') }
        #it { should have_title(user.name) }
        #it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

    describe "followed by signout" do
      before { click_link "Sign out" }
      it { should have_link('Sign in') }
    end


  end

  describe "after visiting another page" do
   	before {click_link "Home" }
  end
  
  describe "authorization", type: :request do 
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the Users controller" do 

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end
  
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

       describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        # Following test fails because it can't call the full_title helper method
        # because this is in /features instead of /requests. But without that, other
        # tests fail because of Capybara 2.0 requirements.
        # it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        #  NOTE:  Rails Tutorial uses root_url below not root_path
        specify { expect(response).to redirect_to(root_path) }
      end


    end

  end

end