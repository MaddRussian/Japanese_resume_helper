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
    # Use a font that supports basic characters
    # Try different fonts that might be available
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
    # Remove or replace non-ASCII characters and handle specific symbols
    # More aggressive sanitization for Japanese characters
    text.to_s.encode('ASCII', 'UTF-8', invalid: :replace, undef: :replace, replace: '?')
         .gsub('+', 'plus ')
         .gsub('–', '-')
         .gsub('—', '-')
         .gsub('…', '...')
  end

  def generate_rirekisho_content(pdf)
    # Debug: Log the data to see what's causing encoding issues
    puts "DEBUG: Resume data for PDF generation:"
    puts "Basic info: #{@resume_data[:basic_info]}"
    puts "Skills: #{@resume_data[:skills]}"
    puts "Education: #{@resume_data[:education]}"
    puts "Experience: #{@resume_data[:experience]}"
    puts "Certifications: #{@resume_data[:certifications]}"

    # Title
    pdf.text "Rirekisho (Resume)", size: 24, style: :bold, align: :center
    pdf.move_down 20

    # Basic Information
    pdf.text "Basic Information", size: 16, style: :bold
    pdf.move_down 10

    basic_info = @resume_data[:basic_info]
    basic_table_data = [
      ["Name", sanitize_for_pdf(basic_info[:name])],
      ["Address", sanitize_for_pdf(basic_info[:address])],
      ["Phone", sanitize_for_pdf(basic_info[:phone])],
      ["Summary", sanitize_for_pdf(basic_info[:summary])]
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
      # Add headers as first row
      education_data = [["Period", "School Name", "Type", "Degree/Major", "Details"]]

      # Add education entries
      education_data += @resume_data[:education].map do |edu|
        [
          "#{sanitize_for_pdf(edu[:start_date])} - #{sanitize_for_pdf(edu[:end_date])}",
          sanitize_for_pdf(edu[:school_name]),
          sanitize_for_pdf(edu[:institution_type]),
          "#{sanitize_for_pdf(edu[:degree])} #{sanitize_for_pdf(edu[:field])}",
          sanitize_for_pdf(edu[:description])
        ]
      end

      pdf.table(education_data, width: pdf.bounds.width) do
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
      # Add headers as first row
      experience_data = [["Period", "Company", "Position", "Job Description"]]

      # Add experience entries
      experience_data += @resume_data[:experience].map do |exp|
        [
          "#{sanitize_for_pdf(exp[:start_date])} - #{sanitize_for_pdf(exp[:end_date])}",
          sanitize_for_pdf(exp[:company]),
          sanitize_for_pdf(exp[:title]),
          sanitize_for_pdf(exp[:description])
        ]
      end

      pdf.table(experience_data, width: pdf.bounds.width) do
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
      # Add headers as first row
      skills_data = [["Skill Name", "Level"]]

      # Add skills entries
      skills_data += @resume_data[:skills].map do |skill|
        [skill[:name], skill[:level]]
      end

      pdf.table(skills_data, width: pdf.bounds.width) do
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
      # Add headers as first row
      cert_data = [["Certification Name", "Completion Date"]]

      # Add certification entries
      cert_data += @resume_data[:certifications].map do |cert|
        [cert[:name], cert[:completion_date]]
      end

      pdf.table(cert_data, width: pdf.bounds.width) do
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
      ["Name", sanitize_for_pdf(basic_info[:name])],
      ["Address", sanitize_for_pdf(basic_info[:address])],
      ["Phone", sanitize_for_pdf(basic_info[:phone])],
      ["Summary", sanitize_for_pdf(basic_info[:summary])]
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
        pdf.text "[#{index + 1}] #{sanitize_for_pdf(exp[:company])} - #{sanitize_for_pdf(exp[:title])}", size: 14, style: :bold
        pdf.move_down 5

        details = [
          ["Period", sanitize_for_pdf(exp[:start_date]) + " - " + sanitize_for_pdf(exp[:end_date])],
          ["Job Description", sanitize_for_pdf(exp[:description])]
        ]

        if exp[:achievements]&.any?
          details << ["Key Achievements", sanitize_for_pdf(exp[:achievements].join(", "))]
        end

        if exp[:technologies]&.any?
          details << ["Technologies Used", sanitize_for_pdf(exp[:technologies].join(", "))]
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
      # Add headers as first row
      skills_data = [["Skill Name", "Level"]]

      # Add skills entries
      skills_data += @resume_data[:skills].map do |skill|
        [skill[:name], skill[:level]]
      end

      pdf.table(skills_data, width: pdf.bounds.width) do
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
      # Add headers as first row
      cert_data = [["Certification Name", "Completion Date"]]

      # Add certification entries
      cert_data += @resume_data[:certifications].map do |cert|
        [cert[:name], cert[:completion_date]]
      end

      pdf.table(cert_data, width: pdf.bounds.width) do
        cells.padding = 6
        cells.borders = [:bottom]
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
      end
    end
  end
end
