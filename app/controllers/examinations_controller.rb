class ExaminationsController < ApplicationController
  before_action :set_examination, only: %i[ show edit update destroy ]

  # GET /examinations or /examinations.json
  def index
    @examinations = Examination.all
  end

  # GET /examinations/1 or /examinations/1.json
  def show
  end

  # GET /examinations/new
  def new
    @examination = Examination.new
  end

  # GET /examinations/1/edit
  def edit
  end

  # POST /examinations or /examinations.json
  def create
    @examination = Examination.new(examination_params)

    respond_to do |format|
      if @examination.save
        format.html { redirect_to @examination, notice: "Examination was successfully created." }
        format.json { render :show, status: :created, location: @examination }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /examinations/1 or /examinations/1.json
  def update
    respond_to do |format|
      if @examination.update(examination_params)
        format.html { redirect_to @examination, notice: "Examination was successfully updated." }
        format.json { render :show, status: :ok, location: @examination }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @examination.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /examinations/1 or /examinations/1.json
  def destroy
    @examination.destroy!

    respond_to do |format|
      format.html { redirect_to examinations_path, status: :see_other, notice: "Examination was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def manage_grades
    @examination = Examination.includes(course: [:subject, :school_class]).find(params[:id])
  end

  def add_grade
    @examination = Examination.find(params[:id])
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
    @examination = Examination.find(params[:id])
    @grade = @examination.grades.find(params[:grade_id])

    if @grade.update(value: params[:value])
      redirect_to manage_grades_examination_path(@examination), notice: "La note a été mise à jour avec succès."
    else
      redirect_to manage_grades_examination_path(@examination), alert: "Impossible de mettre à jour la note."
    end
  end

  def remove_grade
    @examination = Examination.find(params[:id])
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
      @examination = Examination.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def examination_params
      params.expect(examination: [ :title, :expected_at, :course_id ])
    end
end
