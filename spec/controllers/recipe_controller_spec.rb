require 'rails_helper'

RSpec.describe RecipeController, :type => :controller do
  render_views
  describe "index" do

    before do
      Recipe.create! name: 'Pelmeni!'
      Recipe.create! name: 'Sguha!'
      Recipe.create! name: 'Borstshch!'
      Recipe.create! name: 'Bishbarmak!'
      Recipe.create! name: 'Zharkoe-po-domashnemu!'

      xhr :get, :index, format: :json, keywords: keywords
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_name
      ->(object) { object["name"] }
    end

    context "when the search finds results" do
      let(:keywords) { 'r' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
      it 'should return three results' do
        expect(results.size).to eq(3)
      end
      it "should include 'Borstshch!'" do
        expect(results.map(&extract_name)).to include('Borstshch!')
      end
      it "should include 'Bishbarmak!'" do
        expect(results.map(&extract_name)).to include('Bishbarmak!')
      end
      it "should include 'Zharkoe-po-domashnemu!'" do
        expect(results.map(&extract_name)).to include('Zharkoe-po-domashnemu!')
      end
    end

    context "when the search doesn't find results" do
      let(:keywords) { 'foo' }
      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end

  end

  describe "show" do
    before do
      xhr :get, :show, format: :json, id: recipe_id
    end

    subject(:results) { JSON.parse(response.body) }

    context "when the recipe exists" do
      let(:recipe) {
        Recipe.create!(name: 'Baked Potato w/ Cheese',
        instructions: "Nuke for 20 minutes; top with cheese")
      }
      let(:recipe_id) { recipe.id }

      it { expect(response.status).to eq(200) }
      it { expect(results["id"]).to eq(recipe.id) }
      it { expect(results["name"]).to eq(recipe.name) }
      it { expect(results["instructions"]).to eq(recipe.instructions) }
    end

    context "when the recipe doesn't exit" do
      let(:recipe_id) { -9999 }
      it { expect(response.status).to eq(404) }
    end

  end
end
