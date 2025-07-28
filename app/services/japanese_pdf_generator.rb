require 'prawn'
require 'prawn/table'

class JapanesePdfGenerator
  def initialize(resume_data)
    @resume_data = resume_data
  end

  def generate_rirekisho_pdf
    Prawn::Document.new(page_size: 'A4', margin: [50, 50, 50, 50]) do |pdf|
      setup_fonts(pdf)
      generate_rirekisho_content(pdf)
    end
  end

  def generate_shokumu_keirekisho_pdf
    Prawn::Document.new(page_size: 'A4', margin: [50, 50, 50, 50]) do |pdf|
      setup_fonts(pdf)
      generate_shokumu_keirekisho_content(pdf)
    end
  end

  private

  def setup_fonts(pdf)
    # Use default font that supports basic Japanese characters
    pdf.font "Helvetica"
  end

  def generate_rirekisho_content(pdf)
    # Title
    pdf.text "Rirekisho (Resume)", size: 24, style: :bold, align: :center
    pdf.move_down 20

    # Basic Information
    pdf.text "Basic Information", size: 16, style: :bold
    pdf.move_down 10

    basic_info = @resume_data[:basic_info]
    basic_table_data = [
      ["Name", basic_info[:name]],
      ["Address", basic_info[:address]],
      ["Phone", basic_info[:phone]],
      ["Summary", basic_info[:summary]]
    ]

    pdf.table(basic_table_data, width: pdf.bounds.width) do
      cells.padding = 8
      cells.borders = [:bottom]
      row(0).font_style = :bold
    end

    pdf.move_down 20

    # Education Section
    pdf.text "Education", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:education].any?
      education_data = @resume_data[:education].map do |edu|
        [
          "#{edu[:start_date]} - #{edu[:end_date]}",
          edu[:school_name],
          edu[:institution_type],
          "#{edu[:degree]} #{edu[:field]}",
          edu[:description]
        ]
      end

      pdf.table(education_data, width: pdf.bounds.width, headers: ["Period", "School Name", "Type", "Degree/Major", "Details"]) do
        cells.padding = 6
        cells.borders = [:bottom]
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
      end
    end

    pdf.move_down 20

    # Work Experience Section
    pdf.text "Work Experience", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:experience].any?
      experience_data = @resume_data[:experience].map do |exp|
        [
          "#{exp[:start_date]} - #{exp[:end_date]}",
          exp[:company],
          exp[:title],
          exp[:description]
        ]
      end

      pdf.table(experience_data, width: pdf.bounds.width, headers: ["Period", "Company", "Position", "Job Description"]) do
        cells.padding = 6
        cells.borders = [:bottom]
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
      end
    end

    pdf.move_down 20

    # Skills Section
    pdf.text "Skills", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:skills].any?
      skills_data = @resume_data[:skills].map do |skill|
        [skill[:name], skill[:level]]
      end

      pdf.table(skills_data, width: pdf.bounds.width, headers: ["Skill Name", "Level"]) do
        cells.padding = 6
        cells.borders = [:bottom]
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
      end
    end

    pdf.move_down 20

    # Certifications Section
    pdf.text "Certifications", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:certifications].any?
      cert_data = @resume_data[:certifications].map do |cert|
        [cert[:name], cert[:completion_date]]
      end

      pdf.table(cert_data, width: pdf.bounds.width, headers: ["Certification Name", "Completion Date"]) do
        cells.padding = 6
        cells.borders = [:bottom]
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
      end
    end
  end

  def generate_shokumu_keirekisho_content(pdf)
    # Title
    pdf.text "Shokumu Keirekisho (Job History)", size: 24, style: :bold, align: :center
    pdf.move_down 20

    # Basic Information
    pdf.text "Basic Information", size: 16, style: :bold
    pdf.move_down 10

    basic_info = @resume_data[:basic_info]
    basic_table_data = [
      ["Name", basic_info[:name]],
      ["Address", basic_info[:address]],
      ["Phone", basic_info[:phone]],
      ["Summary", basic_info[:summary]]
    ]

    pdf.table(basic_table_data, width: pdf.bounds.width) do
      cells.padding = 8
      cells.borders = [:bottom]
      row(0).font_style = :bold
    end

    pdf.move_down 20

    # Detailed Work Experience Section
    pdf.text "Detailed Work Experience", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:experience].any?
      @resume_data[:experience].each_with_index do |exp, index|
        pdf.text "[#{index + 1}] #{exp[:company]} - #{exp[:title]}", size: 14, style: :bold
        pdf.move_down 5

        details = [
          ["Period", exp[:start_date] + " - " + exp[:end_date]],
          ["Job Description", exp[:description]]
        ]

        if exp[:achievements]&.any?
          details << ["Key Achievements", exp[:achievements].join(", ")]
        end

        if exp[:technologies]&.any?
          details << ["Technologies Used", exp[:technologies].join(", ")]
        end

        pdf.table(details, width: pdf.bounds.width) do
          cells.padding = 6
          cells.borders = [:bottom]
          row(0).font_style = :bold
        end

        pdf.move_down 15
      end
    end

    pdf.move_down 20

    # Skills Section
    pdf.text "Skills", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:skills].any?
      skills_data = @resume_data[:skills].map do |skill|
        [skill[:name], skill[:level]]
      end

      pdf.table(skills_data, width: pdf.bounds.width, headers: ["Skill Name", "Level"]) do
        cells.padding = 6
        cells.borders = [:bottom]
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
      end
    end

    pdf.move_down 20

    # Certifications Section
    pdf.text "Certifications", size: 16, style: :bold
    pdf.move_down 10

    if @resume_data[:certifications].any?
      cert_data = @resume_data[:certifications].map do |cert|
        [cert[:name], cert[:completion_date]]
      end

      pdf.table(cert_data, width: pdf.bounds.width, headers: ["Certification Name", "Completion Date"]) do
        cells.padding = 6
        cells.borders = [:bottom]
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
      end
    end
  end
end
