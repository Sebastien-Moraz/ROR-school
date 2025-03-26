# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Nettoyage de la base de données..."
# Suppression dans l'ordre inverse des dépendances
Grade.destroy_all
Examination.destroy_all
Course.destroy_all
SchoolClass.destroy_all
Person.destroy_all
Room.destroy_all
Subject.destroy_all
Moment.destroy_all
Address.destroy_all

puts "Création des périodes (trimestres)..."
moments = {
  trimestre1: Moment.create!(
    uid: "T1",
    category: :trimester_1,
    start_at: Time.zone.now.beginning_of_year.change(month: 9),  # Septembre
    end_at: Time.zone.now.beginning_of_year.change(month: 12, day: 20)  # Décembre
  ),
  trimestre2: Moment.create!(
    uid: "T2",
    category: :trimester_2,
    start_at: Time.zone.now.beginning_of_year.change(month: 1),  # Janvier
    end_at: Time.zone.now.beginning_of_year.change(month: 3, day: 31)  # Mars
  ),
  trimestre3: Moment.create!(
    uid: "T3",
    category: :trimester_3,
    start_at: Time.zone.now.beginning_of_year.change(month: 4),  # Avril
    end_at: Time.zone.now.beginning_of_year.change(month: 6, day: 30)  # Juin
  ),
  trimestre4: Moment.create!(
    uid: "T4",
    category: :trimester_4,
    start_at: Time.zone.now.beginning_of_year.change(month: 7),  # Juillet
    end_at: Time.zone.now.beginning_of_year.change(month: 8, day: 31)  # Août
  )
}

puts "Création des adresses..."
addresses = {
  admin: Address.create!(zip: '1000', town: 'Lausanne', street: 'Rue de l\'Administration', number: '1'),
  prof1: Address.create!(zip: '1000', town: 'Lausanne', street: 'Avenue des Sciences', number: '10'),
  prof2: Address.create!(zip: '1000', town: 'Lausanne', street: 'Rue des Mathématiques', number: '20'),
  student1: Address.create!(zip: '1000', town: 'Lausanne', street: 'Chemin des Étudiants', number: '1'),
  student2: Address.create!(zip: '1000', town: 'Lausanne', street: 'Avenue du Campus', number: '5'),
  student3: Address.create!(zip: '1000', town: 'Lausanne', street: 'Rue de l\'Université', number: '15')
}

puts "Création de l'administrateur..."
admin = Person.create!(
  email: 'admin@admin.admin',
  password: '123456',
  username: 'admin',
  firstname: 'Admin',
  lastname: 'System',
  phone_number: '0123456789',
  role: 'admin',
  address: addresses[:admin]
)

puts "Création des professeurs..."
prof_math = Person.create!(
  email: 'prof.math@school.ch',
  password: '123456',
  username: 'prof_math',
  firstname: 'Albert',
  lastname: 'Einstein',
  phone_number: '0789123456',
  role: 'teacher',
  address: addresses[:prof1]
)

prof_info = Person.create!(
  email: 'prof.info@school.ch',
  password: '123456',
  username: 'prof_info',
  firstname: 'Ada',
  lastname: 'Lovelace',
  phone_number: '0789123457',
  role: 'teacher',
  address: addresses[:prof2]
)

puts "Création des étudiants..."
students = [
  {
    email: 'etudiant1@school.ch',
    password: '123456',
    username: 'etudiant1',
    firstname: 'Marie',
    lastname: 'Curie',
    phone_number: '0789123458',
    address: addresses[:student1]
  },
  {
    email: 'etudiant2@school.ch',
    password: '123456',
    username: 'etudiant2',
    firstname: 'Isaac',
    lastname: 'Newton',
    phone_number: '0789123459',
    address: addresses[:student2]
  },
  {
    email: 'etudiant3@school.ch',
    password: '123456',
    username: 'etudiant3',
    firstname: 'Charles',
    lastname: 'Darwin',
    phone_number: '0789123460',
    address: addresses[:student3]
  }
].map { |attrs| Person.create!(attrs.merge(role: 'student')) }

puts "Création des matières..."
subjects = [
  Subject.create!(name: 'Mathématiques'),
  Subject.create!(name: 'Informatique'),
  Subject.create!(name: 'Physique')
]

puts "Création des salles..."
rooms = [
  Room.create!(name: 'A101'),
  Room.create!(name: 'B202'),
  Room.create!(name: 'C303')
]

puts "Création des classes..."
class_1a = SchoolClass.create!(
  name: '1A',
  uid: '1A-2024',
  person: prof_math,
  room: rooms[0],
  moment: moments[:trimestre1]  # Assigné au premier trimestre
)
students.each { |student| class_1a.students << student }

puts "Création des cours..."
courses = [
  Course.create!(
    school_class: class_1a,
    subject: subjects[0],
    person: prof_math,
    week_day: :monday,
    moment: moments[:trimestre1],  # Premier trimestre
    start_at: Time.zone.now.change(hour: 8, min: 15),
    end_at: Time.zone.now.change(hour: 11, min: 45)
  ),
  Course.create!(
    school_class: class_1a,
    subject: subjects[1],
    person: prof_info,
    week_day: :tuesday,
    moment: moments[:trimestre1],  # Premier trimestre
    start_at: Time.zone.now.change(hour: 13, min: 15),
    end_at: Time.zone.now.change(hour: 16, min: 45)
  )
]

puts "Création des examens et des notes..."
courses.each do |course|
  # Premier examen
  exam1 = Examination.create!(
    title: "Examen 1 - #{course.subject.name}",
    expected_at: 2.weeks.ago,
    course: course
  )
  
  # Deuxième examen
  exam2 = Examination.create!(
    title: "Examen 2 - #{course.subject.name}",
    expected_at: 1.week.ago,
    course: course
  )

  # Notes pour chaque étudiant
  students.each do |student|
    # Notes pour le premier examen (entre 4 et 6)
    Grade.create!(
      value: rand(4.0..6.0).round(1),
      examination: exam1,
      person: student,
      expected_at: exam1.expected_at
    )
    
    # Notes pour le deuxième examen (quelques notes en dessous de 4 pour tester)
    Grade.create!(
      value: rand(3.0..6.0).round(1),
      examination: exam2,
      person: student,
      expected_at: exam2.expected_at
    )
  end
end

puts "Données de test créées avec succès !"
puts "\nComptes de test :"
puts "Admin     : admin@admin.admin / 123456"
puts "Prof Math : prof.math@school.ch / 123456"
puts "Prof Info : prof.info@school.ch / 123456"
puts "Étudiant 1: etudiant1@school.ch / 123456"
puts "Étudiant 2: etudiant2@school.ch / 123456"
puts "Étudiant 3: etudiant3@school.ch / 123456"
