class ResumesController < ApplicationController
  before_action :set_resume, only: %i[show edit update destroy]

  def index
    @resumes = Resume.all
  end

  def new
    @resume = Resume.new
    @resume.educations.build
    @resume.experiences.build
    @resume.skills.build
  end

  def create
    @resume = Resume.new(resume_params)
    @resume.user = current_user

    if @resume.save
      redirect_to @resume, notice: 'Resume created successfully.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @resume.update(resume_params)
      redirect_to @resume, notice: 'Resume updated.'
    else
      render :edit
    end
  end

  def destroy
    @resume.destroy
    redirect_to resumes_path, notice: 'Resume deleted.'
  end

  private

  def set_resume
    @resume = Resume.find(params[:id])
  end

  def resume_params
    params.require(:resume).permit(
      :title, :summary, :address, :phone_number,
      educations_attributes: [:id, :school_name, :institution_type, :degree, :field, :start_date, :end_date, :description, :_destroy],
      experiences_attributes: [:id, :company_name, :title, :start_date, :end_date, :description, :_destroy],
      skills_attributes: [:id, :name, :_destroy]
    )
  end
end
