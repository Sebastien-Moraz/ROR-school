json.extract! course, :id, :start_at, :end_at, :week_day, :classe_id, :subject_id, :moment_id, :person_id, :created_at, :updated_at
json.url course_url(course, format: :json)
