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
  end

  # GET /grades/1/edit
  def edit
    authorize_admin_or_teacher!
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
