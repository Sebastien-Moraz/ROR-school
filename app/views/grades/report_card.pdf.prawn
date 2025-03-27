prawn_document do |pdf|
  # En-tête
  pdf.text "Bulletin de notes", size: 24, style: :bold, align: :center
  pdf.move_down 20

  # Informations de l'étudiant
  pdf.text "#{@student.firstname} #{@student.lastname}", size: 16
  pdf.text "Classe: #{@student.enrolled_classes.first&.name || 'Non assigné'}", size: 14
  pdf.move_down 30

  # Pour chaque cours
  @courses.each do |course|
    # Titre du cours
    pdf.text course.subject.name, size: 14, style: :bold
    pdf.text "Professeur: #{course.person.firstname} #{course.person.lastname}", size: 12
    pdf.move_down 10

    if course.examinations.any?
      # Tableau des notes
      data = [["Examen", "Date", "Note"]]
      course.examinations.includes(:grades).order(expected_at: :desc).each do |exam|
        grade = exam.grades.find_by(person: @student)
        data << [
          exam.title,
          exam.expected_at&.strftime("%d/%m/%Y") || "-",
          grade&.value ? "#{grade.value}/6" : "Non noté"
        ]
      end

      # Calcul de la moyenne du cours
      course_average = course.examinations.joins(:grades)
                            .where(grades: { person: @student })
                            .average('grades.value')
                            .to_f.round(2)

      if course_average > 0
        data << ["Moyenne du cours", "", "#{course_average}/6"]
      end

      pdf.table(data, header: true, width: pdf.bounds.width) do |t|
        t.row(0).style(background_color: 'CCCCCC', font_style: :bold)
        t.cells.padding = 10
        t.cells.borders = [:bottom]
        t.cells.border_width = 0.5
      end
    else
      pdf.text "Aucun examen n'a encore été programmé pour ce cours.", style: :italic
    end

    pdf.move_down 20
  end

  # Moyenne générale
  pdf.move_down 30
  pdf.text "Moyenne générale", size: 16, style: :bold

  general_average = @courses.map { |course| 
    course.examinations.joins(:grades)
          .where(grades: { person: @student })
          .average('grades.value')
          .to_f
  }.reject(&:zero?).then { |averages| averages.sum / averages.size rescue 0 }.round(2)

  if general_average > 0
    rounded_average = (general_average * 2).ceil / 2.0
    pdf.text "Moyenne: #{general_average}/6", size: 14
    pdf.text "Moyenne arrondie: #{rounded_average}/6", size: 14
    pdf.text rounded_average >= 4 ? "Promotion validée" : "Promotion non validée",
             size: 14,
             style: :bold,
             color: rounded_average >= 4 ? '009900' : 'CC0000'
  else
    pdf.text "Pas encore de notes", style: :italic
  end

  # Pied de page
  pdf.number_pages "Page <page> sur <total>",
                   at: [pdf.bounds.right - 150, 0],
                   width: 150,
                   align: :right,
                   start_count_at: 1
end 