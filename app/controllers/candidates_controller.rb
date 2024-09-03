class CandidatesController < ApplicationController
  before_action :set_candidate, only: %i[ show edit update ]
  before_action :set_experience, only: %i[ show edit ]
  before_action :set_education, only: %i[ show edit ]
  before_action :set_disabilities, only: %i[ show edit ]

  def show
  end

  def edit
    @disability_options = Disability.all
    @languages = Language.all
    @candidate_languages = CandidateLanguage.all
  end

  def update
    ActiveRecord::Base.transaction do
      @candidate.update!(candidate_params)
      @user.update!(user_params)
      update_experiences if params[:candidate][:experiences]
    end

    redirect_to candidate_path(@candidate), notice: 'Profile was successfully updated.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to edit_candidate_path(@candidate), inertia: { errors: e.record.errors.full_messages }
  end

  private

  def set_candidate
    @candidate = Candidate.find(params[:id])
    @user = @candidate.user
  end

  def set_experience
    @experiences = Experience.where(candidate: @candidate).order(end_date: :desc)
  end

  def set_education
    @educations = Education.where(candidate: @candidate).order(end_date: :desc)
  end

  def set_disabilities
    @candidate_disabilities = CandidateDisability.includes(:disability).where(candidate: @candidate)
    @disability_details = @candidate_disabilities.map do |cd|
      {
        id: cd.id,
        disability_id: cd.disability_id,
        details: cd.details,
        disability_name: cd.disability.name # Including the disability name directly
      }
    end
  end

  def update_experiences
    submitted_experience_ids = []

    params[:candidate][:experiences].each do |exp|
      if exp[:id].present? && exp[:id].to_s !~ /temp-/
        # Update existing experience
        experience = @candidate.experiences.find(exp[:id])
        experience.update!(exp.permit(:job_title, :company_name, :start_date, :end_date, :description))
        submitted_experience_ids << experience.id
      else
        # Create a new experience
        new_experience = @candidate.experiences.create!(exp.permit(:job_title, :company_name, :start_date, :end_date, :description))
        submitted_experience_ids << new_experience.id
      end
    end

    # Delete any experiences not included in the submitted data
    @candidate.experiences.where.not(id: submitted_experience_ids).destroy_all
  end

  def candidate_params
    params.require(:candidate).permit(
      :first_name, :last_name, :date_of_birth, languages: [],
      user_attributes: [:phone, :address, :city, :state, :zip_code, :country, :bio]
    )
  end

  def user_params
    params.require(:user).permit(:phone, :address, :city, :state, :zip_code, :country, :bio)
  end
end
