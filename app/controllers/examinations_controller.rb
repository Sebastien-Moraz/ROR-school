class ExaminationsController < ApplicationController
  before_action :authenticate_person!
  before_action :set_examination, only: %i[ show edit update destroy manage_grades add_grade update_grade remove_grade ]
  before_action :check_teacher_or_admin_access, except: [:show]
  before_action :check_course_teacher_access, only: [:edit, :update, :destroy, :manage_grades, :add_grade, :update_grade, :remove_grade]

  # GET /examinations or /examinations.json
  def index
    if current_person.admin?
      @examinations = Examination.all
    else
      @examinations = Examination.joins(:course).where(course: { person_id: current_person.id })
    end
  end

  # GET /examinations/1 or /examinations/1.json
  def show
  end

  # GET /examinations/new
  def new
    @examination = Examination.new(course_id: params[:course_id])
    @courses = available_courses
  end

  # GET /examinations/1/edit
  def edit
    @courses = available_courses
  end

  # POST /examinations or /examinations.json
  def create
    @examination = Examination.new(examination_params)
    
    unless can_manage_examination?(@examination)
      redirect_to courses_path, alert: "Vous n'êtes pas autorisé à créer un examen pour ce cours."
      return
    end

    respond_to do |format|
      if @examination.save
        format.html { redirect_to @examination, notice: "L'examen a été créé avec succès." }
        format.json { render :show, status: :created, location: @examination }
      else
        @courses = available_courses
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /examinations/1 or /examinations/1.json
  def update
    respond_to do |format|
      if @examination.update(examination_params)
        format.html { redirect_to @examination, notice: "L'examen a été mis à jour avec succès." }
        format.json { render :show, status: :ok, location: @examination }
      else
        @courses = available_courses
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examinations/1 or /examinations/1.json
  def destroy
    if @examination.destroy
      respond_to do |format|
        format.html { redirect_to examinations_path, status: :see_other, notice: "L'examen et toutes ses notes associées ont été supprimés avec succès." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { 
          redirect_to examinations_path, 
          alert: @examination.errors.full_messages.first || "Impossible de supprimer cet examen." 
        }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  def manage_grades
    @examination = Examination.includes(course: [:subject, :school_class]).find(params[:id])
  end

  def add_grade
    @grade = @examination.grades.build(
      value: params[:value],
      person_id: params[:student_id],
      expected_at: @examination.expected_at
    )

    if @grade.save
      redirect_to manage_grades_examination_path(@examination), notice: "La note a été ajoutée avec succès."
    else
      redirect_to manage_grades_examination_path(@examination), alert: "Impossible d'ajouter la note."
    end
  end

  def update_grade
    @grade = @examination.grades.find(params[:grade_id])

    if @grade.update(value: params[:value])
      redirect_to manage_grades_examination_path(@examination), notice: "La note a été mise à jour avec succès."
    else
      redirect_to manage_grades_examination_path(@examination), alert: "Impossible de mettre à jour la note."
    end
  end

  def remove_grade
    @grade = @examination.grades.find(params[:grade_id])

    if @grade.destroy
      redirect_to manage_grades_examination_path(@examination), notice: "La note a été supprimée avec succès."
    else
      redirect_to manage_grades_examination_path(@examination), alert: "Impossible de supprimer la note."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_examination
      @examination = Examination.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def examination_params
      params.require(:examination).permit(:title, :expected_at, :course_id)
    end

    def check_teacher_or_admin_access
      unless current_person.admin? || current_person.teacher?
        redirect_to root_path, alert: "Accès non autorisé."
      end
    end

    def check_course_teacher_access
      unless can_manage_examination?(@examination)
        redirect_to examinations_path, alert: "Vous n'êtes pas autorisé à gérer cet examen."
      end
    end

    def can_manage_examination?(examination)
      current_person.admin? || (current_person.teacher? && examination.course.person_id == current_person.id)
    end

    def available_courses
      if current_person.admin?
        Course.all
      else
        Course.where(person_id: current_person.id)
      end
    end
end
