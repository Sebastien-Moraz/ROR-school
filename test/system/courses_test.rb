require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "should create course" do
    visit courses_url
    click_on "New course"

    fill_in "Classe", with: @course.classe_id
    fill_in "End at", with: @course.end_at
    fill_in "Moment", with: @course.moment_id
    fill_in "Person", with: @course.person_id
    fill_in "Start at", with: @course.start_at
    fill_in "Subject", with: @course.subject_id
    fill_in "Week day", with: @course.week_day
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "should update Course" do
    visit course_url(@course)
    click_on "Edit this course", match: :first

    fill_in "Classe", with: @course.classe_id
    fill_in "End at", with: @course.end_at.to_s
    fill_in "Moment", with: @course.moment_id
    fill_in "Person", with: @course.person_id
    fill_in "Start at", with: @course.start_at.to_s
    fill_in "Subject", with: @course.subject_id
    fill_in "Week day", with: @course.week_day
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "should destroy Course" do
    visit course_url(@course)
    click_on "Destroy this course", match: :first

    assert_text "Course was successfully destroyed"
  end
end
