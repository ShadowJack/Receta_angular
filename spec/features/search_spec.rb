require 'rails_helper'

feature "Looking up recipes", type: :feature, js: true  do
  before do
    Recipe.create!(name: 'Pelmeni')
    Recipe.create!(name: 'Shawerma')
    Recipe.create!(name: 'Kolbaski')
    Recipe.create!(name: 'Shashlychok')
    Recipe.create!(name: 'Kulebyaka')
  end

  scenario "finding recipes" do
    visit '/'
    fill_in 'keywords', with: 'pel'
    click_on 'Search'

    expect(page).to have_content('Pelmeni')
  end
end
