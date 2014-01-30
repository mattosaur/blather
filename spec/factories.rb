FactoryGirl.define do 
	factory :user do
		name "Testy McTesterson"
		email "testy@McTesterson.com"
		password "password"
		password_confirmation "password"
	end
end