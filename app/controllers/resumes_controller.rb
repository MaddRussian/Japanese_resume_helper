class ResumesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resume, only: %i[show edit update destroy]

  def index
    @resumes = Resume.all
  end

  def new
    @resume = Resume.new
    # Ensure nested attributes are properly initialized
    @resume.educations.build
    @resume.experiences.build
    @resume.skills.build
    @resume.certifications.build
  end

  def create
    Rails.logger.info "=== RESUME CREATE DEBUG ==="
    Rails.logger.info "Current user: #{current_user.inspect}"
    Rails.logger.info "User authenticated? #{user_signed_in?}"

    @resume = Resume.new(resume_params)
    @resume.user = current_user

    Rails.logger.info "Resume params: #{resume_params}"
    Rails.logger.info "Resume valid? #{@resume.valid?}"
    Rails.logger.info "Resume errors: #{@resume.errors.full_messages}" unless @resume.valid?
    Rails.logger.info "Certifications: #{@resume.certifications.map { |c| { name: c.name, completion_date: c.completion_date, valid: c.valid?, errors: c.errors.full_messages } }}"
    Rails.logger.info "Raw certifications params: #{params[:resume][:certifications_attributes]}" if params[:resume]&.dig(:certifications_attributes)

    if @resume.save
      Rails.logger.info "Resume saved successfully!"
      # Generate Japanese resume data
      generator = JapaneseResumeGenerator.new(@resume)
      rirekisho_data = generator.generate_rirekisho
      shokumu_keirekisho_data = generator.generate_shokumu_keirekisho

      # Generate PDFs
      pdf_generator = JapanesePdfGenerator.new(rirekisho_data)
      rirekisho_pdf = pdf_generator.generate_rirekisho_pdf

      pdf_generator_shokumu = JapanesePdfGenerator.new(shokumu_keirekisho_data)
      shokumu_keirekisho_pdf = pdf_generator_shokumu.generate_shokumu_keirekisho_pdf

      # Save PDFs to storage
      @resume.rirekisho_pdf.attach(
        io: StringIO.new(rirekisho_pdf.render),
        filename: "#{@resume.title}_履歴書.pdf",
        content_type: 'application/pdf'
      )

      @resume.shokumu_keirekisho_pdf.attach(
        io: StringIO.new(shokumu_keirekisho_pdf.render),
        filename: "#{@resume.title}_職務経歴書.pdf",
        content_type: 'application/pdf'
      )

      redirect_to @resume, notice: 'Resume created successfully with Japanese PDFs.'
    else
      Rails.logger.error "Resume save failed: #{@resume.errors.full_messages}"
      # Rebuild nested attributes to ensure they're properly initialized
      @resume.educations.build if @resume.educations.empty?
      @resume.experiences.build if @resume.experiences.empty?
      @resume.skills.build if @resume.skills.empty?
      @resume.certifications.build if @resume.certifications.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @rirekisho_data = JapaneseResumeGenerator.new(@resume).generate_rirekisho
    @shokumu_keirekisho_data = JapaneseResumeGenerator.new(@resume).generate_shokumu_keirekisho
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

  def download_rirekisho
    @resume = Resume.find(params[:id])
    if @resume.rirekisho_pdf.attached?
      send_data @resume.rirekisho_pdf.download,
                filename: "#{@resume.title}_履歴書.pdf",
                type: 'application/pdf'
    else
      redirect_to @resume, alert: '履歴書PDFが見つかりません。'
    end
  end

  def download_shokumu_keirekisho
    @resume = Resume.find(params[:id])
    if @resume.shokumu_keirekisho_pdf.attached?
      send_data @resume.shokumu_keirekisho_pdf.download,
                filename: "#{@resume.title}_職務経歴書.pdf",
                type: 'application/pdf'
    else
      redirect_to @resume, alert: '職務経歴書PDFが見つかりません。'
    end
  end

  private

  def set_resume
    @resume = Resume.find(params[:id])
  end

  def resume_params
    permitted = params.require(:resume).permit(
      :title, :summary, :address, :phone_number, :photo,
      educations_attributes: [:id, :school_name, :institution_type, :degree, :field, :start_date, :end_date, :description, :_destroy],
      experiences_attributes: [:id, :company_name, :title, :start_date, :end_date, :description, :_destroy],
      skills_attributes: [:id, :name, :_destroy],
      certifications_attributes: [:id, :name, :completion_date, :_destroy]
    )
    # Convert YYYY-MM to YYYY-MM-01 for all month/date fields
    if permitted[:educations_attributes]
      permitted[:educations_attributes].each do |_, attrs|
        if attrs[:start_date].present? && attrs[:start_date] =~ /^\d{4}-\d{2}$/
          attrs[:start_date] = attrs[:start_date] + '-01'
        end
        if attrs[:end_date].present? && attrs[:end_date] =~ /^\d{4}-\d{2}$/
          attrs[:end_date] = attrs[:end_date] + '-01'
        end
      end
    end
    if permitted[:experiences_attributes]
      permitted[:experiences_attributes].each do |_, attrs|
        if attrs[:start_date].present? && attrs[:start_date] =~ /^\d{4}-\d{2}$/
          attrs[:start_date] = attrs[:start_date] + '-01'
        end
        if attrs[:end_date].present? && attrs[:end_date] =~ /^\d{4}-\d{2}$/
          attrs[:end_date] = attrs[:end_date] + '-01'
        end
      end
    end
    if permitted[:certifications_attributes]
      permitted[:certifications_attributes].each do |_, attrs|
        if attrs[:completion_date].present? && attrs[:completion_date] =~ /^\d{4}-\d{2}$/
          attrs[:completion_date] = attrs[:completion_date] + '-01'
        end
      end
    end
    permitted
  end
end
