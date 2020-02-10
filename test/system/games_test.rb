require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "Should land on the /score page" do
    visit new_url
    fill_in 'word', with: 'hello'
    click_on("submit")
    assert test: "New word"
    assert_text "Play again"
  end
end
