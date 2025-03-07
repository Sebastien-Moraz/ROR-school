require "application_system_test_case"

class MomentsTest < ApplicationSystemTestCase
  setup do
    @moment = moments(:one)
  end

  test "visiting the index" do
    visit moments_url
    assert_selector "h1", text: "Moments"
  end

  test "should create moment" do
    visit moments_url
    click_on "New moment"

    fill_in "Category", with: @moment.category
    fill_in "End at", with: @moment.end_at
    fill_in "Start at", with: @moment.start_at
    fill_in "Uid", with: @moment.uid
    click_on "Create Moment"

    assert_text "Moment was successfully created"
    click_on "Back"
  end

  test "should update Moment" do
    visit moment_url(@moment)
    click_on "Edit this moment", match: :first

    fill_in "Category", with: @moment.category
    fill_in "End at", with: @moment.end_at.to_s
    fill_in "Start at", with: @moment.start_at.to_s
    fill_in "Uid", with: @moment.uid
    click_on "Update Moment"

    assert_text "Moment was successfully updated"
    click_on "Back"
  end

  test "should destroy Moment" do
    visit moment_url(@moment)
    click_on "Destroy this moment", match: :first

    assert_text "Moment was successfully destroyed"
  end
end
