class SchoolClassesController < ApplicationController
  before_action :set_school_class, only: %i[ show edit update destroy ]

  # GET /school_classes or /school_classes.json
  def index
    @school_classes = SchoolClass.all
  end

  # GET /school_classes/1 or /school_classes/1.json
  def show
  end

  # GET /school_classes/new
  def new
    @school_class = SchoolClass.new
  end

  # GET /school_classes/1/edit
  def edit
  end

  # POST /school_classes or /school_classes.json
  def create
    @school_class = SchoolClass.new(school_class_params)

    respond_to do |format|
      if @school_class.save
        format.html { redirect_to @school_class, notice: "School class was successfully created." }
        format.json { render :show, status: :created, location: @school_class }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /school_classes/1 or /school_classes/1.json
  def update
    respond_to do |format|
      if @school_class.update(school_class_params)
        format.html { redirect_to @school_class, notice: "School class was successfully updated." }
        format.json { render :show, status: :ok, location: @school_class }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_classes/1 or /school_classes/1.json
  def destroy
    @school_class.destroy!

    respond_to do |format|
      format.html { redirect_to school_classes_path, status: :see_other, notice: "School class was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def manage_students
    @school_class = SchoolClass.find(params[:id])
  end

  def add_student
    @school_class = SchoolClass.find(params[:id])
    student = Person.student.find(params[:student_id])
    
    if @school_class.students << student
      redirect_to manage_students_school_class_path(@school_class), notice: "L'étudiant a été ajouté à la classe avec succès."
    else
      redirect_to manage_students_school_class_path(@school_class), alert: "Impossible d'ajouter l'étudiant à la classe."
    end
  end

  def remove_student
    @school_class = SchoolClass.find(params[:id])
    student = Person.student.find(params[:student_id])
    
    if @school_class.students.delete(student)
      redirect_to manage_students_school_class_path(@school_class), notice: "L'étudiant a été retiré de la classe avec succès."
    else
      redirect_to manage_students_school_class_path(@school_class), alert: "Impossible de retirer l'étudiant de la classe."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_class
      @school_class = SchoolClass.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def school_class_params
      params.expect(school_class: [ :uid, :name, :person_id, :room_id, :moment_id ])
    end
end
