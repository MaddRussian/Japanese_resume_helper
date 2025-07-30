require 'prawn'
require 'prawn/table'

class JapanesePdfGenerator
  def initialize(resume_data)
    @resume_data = resume_data
  end

  def generate_rirekisho_pdf
    Prawn::Document.new(page_size: 'A4', margin: [30, 30, 30, 30]) do |pdf|
      setup_fonts(pdf)
      generate_rirekisho_content(pdf)
    end
  end

  def generate_shokumu_keirekisho_pdf
    Prawn::Document.new(page_size: 'A4', margin: [30, 30, 30, 30]) do |pdf|
      setup_fonts(pdf)
      generate_shokumu_keirekisho_content(pdf)
    end
  end

  private

  def setup_fonts(pdf)
    available_fonts = ['Times-Roman', 'Helvetica', 'Courier']
    available_fonts.each do |font_name|
      begin
        pdf.font font_name
        break
      rescue
        next
      end
    end
  end

  def sanitize_for_pdf(text)
    return "" if text.nil?
    text.to_s.encode('ASCII', 'UTF-8', invalid: :replace, undef: :replace, replace: '?')
         .gsub('+', 'plus ')
         .gsub('–', '-')
         .gsub('—', '-')
         .gsub('…', '...')
  end

  def generate_rirekisho_content(pdf)
    # Title - Using ASCII-safe text for now
    pdf.text "Rirekisho (Resume)", size: 28, style: :bold, align: :center
    pdf.move_down 30

    # Photo area (top right) - Traditional Japanese resumes have photo space
    photo_box_width = 80
    photo_box_height = 100
    photo_x = pdf.bounds.width - photo_box_width - 20
    photo_y = pdf.bounds.height - 50

    pdf.stroke_rectangle [photo_x, photo_y], photo_box_width, photo_box_height
    pdf.text_box "Photo", size: 10, align: :center, at: [photo_x, photo_y - 20], width: photo_box_width

    # Basic Information Table - Traditional format with labels on left
    basic_info = @resume_data[:basic_info]

    # Personal Information Section
    pdf.text "Personal Information", size: 16, style: :bold
    pdf.move_down 10

    personal_data = [
      ["Name", sanitize_for_pdf(basic_info[:name])],
      ["Address", sanitize_for_pdf(basic_info[:address])],
      ["Phone", sanitize_for_pdf(basic_info[:phone])],
      ["Date of Birth", ""],  # Traditional field
      ["Gender", ""],      # Traditional field
      ["Email", ""]  # Traditional field
    ]

    pdf.table(personal_data, width: pdf.bounds.width - 100, position: :left) do
      cells.padding = [8, 12]
      cells.borders = [:top, :bottom, :left, :right]
      column(0).width = 80
      column(0).font_style = :bold
      column(0).background_color = "F0F0F0"
    end

    pdf.move_down 20

    # Education Section
    pdf.text "Education", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:education].any?
      education_data = [["Period", "School Name", "Degree/Major"]]

      education_data += @resume_data[:education].map do |edu|
        [
          "#{sanitize_for_pdf(edu[:start_date])} - #{sanitize_for_pdf(edu[:end_date])}",
          sanitize_for_pdf(edu[:school_name]),
          "#{sanitize_for_pdf(edu[:degree])} #{sanitize_for_pdf(edu[:field])}"
        ]
      end

      pdf.table(education_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    else
      # Empty education table with traditional structure
      empty_edu_data = [["Period", "School Name", "Degree/Major"], ["", "", ""]]
      pdf.table(empty_edu_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    end

    pdf.move_down 20

    # Work Experience Section
    pdf.text "Work Experience", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:experience].any?
      experience_data = [["Period", "Company Name", "Position"]]

      experience_data += @resume_data[:experience].map do |exp|
        [
          "#{sanitize_for_pdf(exp[:start_date])} - #{sanitize_for_pdf(exp[:end_date])}",
          sanitize_for_pdf(exp[:company]),
          sanitize_for_pdf(exp[:title])
        ]
      end

      pdf.table(experience_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    else
      # Empty experience table with traditional structure
      empty_exp_data = [["Period", "Company Name", "Position"], ["", "", ""]]
      pdf.table(empty_exp_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    end

    pdf.move_down 20

    # Skills Section
    pdf.text "Skills & Certifications", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:skills].any?
      skills_data = [["Skill Name", "Level"]]

      skills_data += @resume_data[:skills].map do |skill|
        [sanitize_for_pdf(skill[:name]), sanitize_for_pdf(skill[:level])]
      end

      pdf.table(skills_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    else
      # Empty skills table
      empty_skills_data = [["Skill Name", "Level"], ["", ""]]
      pdf.table(empty_skills_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    end

    pdf.move_down 20

    # Certifications Section
    if @resume_data[:certifications].any?
      pdf.text "Certifications", size: 16, style: :bold
      pdf.move_down 10

      cert_data = [["Certification Name", "Completion Date"]]

      cert_data += @resume_data[:certifications].map do |cert|
        [sanitize_for_pdf(cert[:name]), sanitize_for_pdf(cert[:completion_date])]
      end

      pdf.table(cert_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    end

    # Self-PR Section (Traditional Japanese resume component)
    pdf.move_down 20
    pdf.text "Self-PR", size: 16, style: :bold
    pdf.move_down 10

    pr_text = sanitize_for_pdf(basic_info[:summary]) || "Please enter your self-PR here"
    pdf.text pr_text, size: 12

    # Date and Signature area (bottom right)
    pdf.move_down 30
    pdf.text "Created: #{Date.current.strftime('%Y-%m-%d')}", size: 12, align: :right
  end

  def generate_shokumu_keirekisho_content(pdf)
    # Title
    pdf.text "Shokumu Keirekisho (Job History)", size: 28, style: :bold, align: :center
    pdf.move_down 30

    # Basic Information
    basic_info = @resume_data[:basic_info]

    pdf.text "Basic Information", size: 16, style: :bold
    pdf.move_down 10

    basic_data = [
      ["Name", sanitize_for_pdf(basic_info[:name])],
      ["Address", sanitize_for_pdf(basic_info[:address])],
      ["Phone", sanitize_for_pdf(basic_info[:phone])],
      ["Email", ""]
    ]

    pdf.table(basic_data, width: pdf.bounds.width - 100, position: :left) do
      cells.padding = [8, 12]
      cells.borders = [:top, :bottom, :left, :right]
      column(0).width = 80
      column(0).font_style = :bold
      column(0).background_color = "F0F0F0"
    end

    pdf.move_down 20

    # Career Summary
    pdf.text "Career Summary", size: 16, style: :bold
    pdf.move_down 10

    summary_text = sanitize_for_pdf(basic_info[:summary]) || "Please enter your career summary here"
    pdf.text summary_text, size: 12

    pdf.move_down 20

    # Detailed Work Experience
    pdf.text "Work Experience", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:experience].any?
      @resume_data[:experience].each_with_index do |exp, index|
        # Company and period header
        pdf.text "[#{index + 1}] #{sanitize_for_pdf(exp[:company])}", size: 14, style: :bold
        pdf.text "Period: #{sanitize_for_pdf(exp[:start_date])} - #{sanitize_for_pdf(exp[:end_date])}", size: 12
        pdf.text "Position: #{sanitize_for_pdf(exp[:title])}", size: 12
        pdf.move_down 10

        # Job description
        pdf.text "Job Description:", size: 12, style: :bold
        pdf.text sanitize_for_pdf(exp[:description]), size: 12
        pdf.move_down 15

        # Add a line separator
        pdf.stroke_horizontal_line 0, pdf.bounds.width
        pdf.move_down 15
      end
    else
      pdf.text "No work experience available", size: 12
    end

    pdf.move_down 20

    # Skills Section
    pdf.text "Skills", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:skills].any?
      skills_data = [["Skill Name", "Level"]]

      skills_data += @resume_data[:skills].map do |skill|
        [sanitize_for_pdf(skill[:name]), sanitize_for_pdf(skill[:level])]
      end

      pdf.table(skills_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    end

    pdf.move_down 20

    # Certifications Section
    if @resume_data[:certifications].any?
      pdf.text "Certifications", size: 16, style: :bold
      pdf.move_down 10

      cert_data = [["Certification Name", "Completion Date"]]

      cert_data += @resume_data[:certifications].map do |cert|
        [sanitize_for_pdf(cert[:name]), sanitize_for_pdf(cert[:completion_date])]
      end

      pdf.table(cert_data, width: pdf.bounds.width) do
        cells.padding = [6, 8]
        cells.borders = [:top, :bottom, :left, :right]
        row(0).font_style = :bold
        row(0).background_color = "F0F0F0"
      end
    end

    # Date and Signature area
    pdf.move_down 30
    pdf.text "Created: #{Date.current.strftime('%Y-%m-%d')}", size: 12, align: :right
  end
end
