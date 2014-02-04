FactoryGirl.define do 
	factory :user do
		name "Testy McTesterson"
		email "user@example.com"
		password "password"
		password_confirmation "password"
	end
end