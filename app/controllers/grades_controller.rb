require 'prawn'
require 'prawn/table'

class GradesController < ApplicationController
  before_action :authenticate_person!
  before_action :set_grade, only: %i[ show edit update destroy ]
  before_action :authorize_grade_access!, only: [:show, :edit, :update, :destroy]

  # GET /grades or /grades.json
  def index
    @grades = case current_person.role
              when 'admin', 'teacher'
                Grade.all.includes(:person, examination: { course: [:subject, :classe] })
              else
                Grade.where(person: current_person).includes(:person, examination: { course: [:subject, :classe] })
              end
  end

  # GET /grades/1 or /grades/1.json
  def show
  end

  # GET /grades/new
  def new
    authorize_admin_or_teacher!
    @grade = Grade.new
    @courses = Course.all.includes(:subject)
  end

  # GET /examinations_for_course
  def examinations_for_course
    @examinations = Course.find(params[:course_id]).examinations
    render json: @examinations.map { |exam| { id: exam.id, name: exam.name } }
  end

  # GET /grades/1/edit
  def edit
    authorize_admin_or_teacher!
    @courses = Course.all.includes(:subject)
  end

  # POST /grades or /grades.json
  def create
    authorize_admin_or_teacher!
    @grade = Grade.new(grade_params)

    respond_to do |format|
      if @grade.save
        format.html { redirect_to grade_url(@grade), notice: "La note a été créée avec succès." }
        format.json { render :show, status: :created, location: @grade }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grades/1 or /grades/1.json
  def update
    authorize_admin_or_teacher!
    respond_to do |format|
      if @grade.update(grade_params)
        format.html { redirect_to grade_url(@grade), notice: "La note a été mise à jour avec succès." }
        format.json { render :show, status: :ok, location: @grade }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grades/1 or /grades/1.json
  def destroy
    authorize_admin_or_teacher!
    @grade.destroy!

    respond_to do |format|
      format.html { redirect_to grades_url, notice: "La note a été supprimée avec succès." }
      format.json { head :no_content }
    end
  end

  def report_card
    if current_person.student?
      @student = current_person
    elsif current_person.admin? || current_person.teacher?
      if params[:student_id].present?
        @student = Person.find_by(id: params[:student_id], role: 'student')
        unless @student
          redirect_to report_card_grades_path, 
            alert: "L'étudiant demandé n'existe pas ou n'est pas un étudiant." and return
        end
      else
        @student = Person.student.first
        if @student
          redirect_to report_card_grades_path(student_id: @student.id) and return
        else
          redirect_to root_path, 
            alert: "Aucun étudiant n'est enregistré dans le système." and return
        end
      end
    else
      redirect_to root_path, alert: "Accès non autorisé" and return
    end

    @courses = if current_person.admin?
                Course.includes(:subject, :person, examinations: :grades)
                      .joins(school_class: :students)
                      .where(school_class: @student.enrolled_classes)
                      .distinct
              elsif current_person.teacher?
                Course.includes(:subject, :person, examinations: :grades)
                      .joins(school_class: :students)
                      .where(school_class: @student.enrolled_classes)
                      .where(person: current_person)
                      .distinct
              else
                Course.includes(:subject, :person, examinations: :grades)
                      .joins(school_class: :students)
                      .where(school_class: @student.enrolled_classes)
                      .distinct
              end

    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
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
          if course.person.present?
            pdf.text "Professeur: #{course.person.firstname} #{course.person.lastname}", size: 12
          end
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

        send_data pdf.render,
                  filename: "bulletin_#{@student.lastname.downcase}_#{@student.firstname.downcase}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grade
      @grade = Grade.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grade_params
      params.require(:grade).permit(:value, :expected_at, :examination_id, :person_id)
    end

    def authorize_admin_or_teacher!
      unless current_person.admin? || current_person.teacher?
        flash[:error] = "Vous n'êtes pas autorisé à effectuer cette action."
        redirect_to grades_path
      end
    end

    def authorize_grade_access!
      unless current_person.admin? || current_person.teacher? || @grade.person_id == current_person.id
        flash[:error] = "Vous n'êtes pas autorisé à accéder à cette note."
        redirect_to grades_path
      end
    end
end
