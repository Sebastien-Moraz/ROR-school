class CoursesController < ApplicationController
  before_action :authenticate_person!
  before_action :set_course, only: %i[ show edit update destroy ]
  before_action :require_admin_or_teacher, except: [:calendar]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Le cours a été créé avec succès." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Le cours a été mis à jour avec succès." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    exams_count = @course.examinations.count
    grades_count = @course.grades.count
    @course.destroy!

    message = "Le cours a été supprimé avec succès."
    message += " #{exams_count} examen(s) et #{grades_count} note(s) ont également été supprimés." if exams_count > 0

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: message }
      format.json { head :no_content }
    end
  end

  def calendar
    if current_person.student?
      Rails.logger.info "Étudiant connecté : #{current_person.inspect}"
      Rails.logger.info "Classes inscrites : #{current_person.enrolled_classes.to_a}"
      
      @courses = current_person.enrolled_classes
                             .includes(courses: [:subject, :person])
                             .flat_map(&:courses)
      
      Rails.logger.info "Cours trouvés : #{@courses.to_a}"
      
      # Ajout de données de test si aucun cours n'est trouvé
      if @courses.empty?
        Rails.logger.warn "Aucun cours trouvé pour l'étudiant"
        flash.now[:warning] = "Aucun cours n'a été trouvé dans votre emploi du temps."
      end
    else
      redirect_to courses_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:start_at, :end_at, :week_day, :school_class_id, :subject_id, :moment_id, :person_id)
    end

    def require_admin_or_teacher
      unless current_person.admin? || current_person.teacher?
        flash[:error] = "Accès non autorisé"
        redirect_to root_path
      end
    end
end
