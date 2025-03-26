class PeopleController < ApplicationController
  before_action :authenticate_person!
  before_action :require_admin, except: [:edit_profile, :update_profile]
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people or /people.json
  def index
    @people = Person.all
  end

  # GET /people/1 or /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people or /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: "Person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: "Person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to people_path, status: :see_other, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def edit_profile
    @person = current_person
  end

  def update_profile
    @person = current_person
    if @person.update(profile_params)
      bypass_sign_in(@person)
      redirect_to root_path, notice: 'Profil mis à jour avec succès.'
    else
      render :edit_profile
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params.require(:id))
    end

    def require_admin
      unless current_person&.role == 'admin'
        flash[:error] = "Accès non autorisé. Seuls les administrateurs peuvent gérer les utilisateurs."
        redirect_to root_path
      end
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(
        :username,
        :firstname,
        :lastname,
        :email,
        :phone_number,
        :role,
        :iban,
        :address_id,
        :password,
        :password_confirmation
      )
    end

    def profile_params
      params.require(:person).permit(
        :username, 
        :firstname, 
        :lastname, 
        :email, 
        :phone_number, 
        :password,
        :password_confirmation,
        :current_password,
        address_attributes: [:id, :zip, :town, :street, :number]
      )
    end
end
