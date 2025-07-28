class JapaneseResumeGenerator
  def initialize(resume)
    @resume = resume
    @user = resume.user
  end

  # Japanese translations for common terms
  JAPANESE_TRANSLATIONS = {
    # Education
    'undergraduate' => 'Undergraduate',
    'graduate' => 'Graduate',
    'vocational' => 'Vocational School',
    'high_school' => 'High School',
    'community_college' => 'Community College',
    'technical' => 'Technical Institute',
    'language_school' => 'Language School',
    'other' => 'Other',

    # Degrees
    'Bachelor of Science' => 'Bachelor of Science',
    'Bachelor of Arts' => 'Bachelor of Arts',
    'Master of Science' => 'Master of Science',
    'Master of Arts' => 'Master of Arts',
    'PhD' => 'PhD',

    # Common fields
    'Computer Science' => 'Computer Science',
    'Engineering' => 'Engineering',
    'Business' => 'Business',
    'Economics' => 'Economics',

    # Job titles
    'Software Engineer' => 'Software Engineer',
    'Developer' => 'Developer',
    'Programmer' => 'Programmer',
    'Manager' => 'Manager',
    'Director' => 'Director',

    # Common skills
    'JavaScript' => 'JavaScript',
    'Python' => 'Python',
    'Java' => 'Java',
    'React' => 'React',
    'Ruby' => 'Ruby',
    'Rails' => 'Rails',
    'Project Management' => 'Project Management',
    'Japanese' => 'Japanese',
    'English' => 'English'
  }.freeze

  def generate_rirekisho
    {
      basic_info: generate_basic_info,
      education: generate_education_section,
      experience: generate_experience_section,
      skills: generate_skills_section,
      certifications: generate_certifications_section
    }
  end

  def generate_shokumu_keirekisho
    {
      basic_info: generate_basic_info,
      experience: generate_detailed_experience_section,
      skills: generate_skills_section,
      certifications: generate_certifications_section
    }
  end

  private

  def generate_basic_info
    {
      name: @resume.title,
      address: translate_address(@resume.address),
      phone: @resume.phone_number,
      summary: translate_summary(@resume.summary)
    }
  end

  def generate_education_section
    @resume.educations.map do |education|
      {
        school_name: education.school_name,
        institution_type: translate_institution_type(education.institution_type),
        degree: translate_degree(education.degree),
        field: translate_field(education.field),
        start_date: format_japanese_date(education.start_date),
        end_date: format_japanese_date(education.end_date),
        description: translate_description(education.description)
      }
    end
  end

  def generate_experience_section
    @resume.experiences.map do |experience|
      {
        company: experience.company_name,
        title: translate_job_title(experience.title),
        start_date: format_japanese_date(experience.start_date),
        end_date: format_japanese_date(experience.end_date),
        description: translate_description(experience.description)
      }
    end
  end

  def generate_detailed_experience_section
    @resume.experiences.map do |experience|
      {
        company: experience.company_name,
        title: translate_job_title(experience.title),
        start_date: format_japanese_date(experience.start_date),
        end_date: format_japanese_date(experience.end_date),
        description: translate_description(experience.description),
        achievements: extract_achievements(experience.description),
        technologies: extract_technologies(experience.description)
      }
    end
  end

  def generate_skills_section
    @resume.skills.map do |skill|
      {
        name: translate_skill(skill.name),
        level: determine_skill_level(skill.name)
      }
    end
  end

  def generate_certifications_section
    @resume.certifications.map do |certification|
      {
        name: certification.name,
        completion_date: format_japanese_date(certification.completion_date)
      }
    end
  end

  # Translation methods
  def translate_institution_type(type)
    JAPANESE_TRANSLATIONS[type] || type
  end

  def translate_degree(degree)
    JAPANESE_TRANSLATIONS[degree] || degree
  end

  def translate_field(field)
    JAPANESE_TRANSLATIONS[field] || field
  end

  def translate_job_title(title)
    JAPANESE_TRANSLATIONS[title] || title
  end

  def translate_skill(skill)
    JAPANESE_TRANSLATIONS[skill] || skill
  end

  def translate_address(address)
    # For PDF generation, return a safe English version
    # This prevents encoding issues with Japanese characters
    if address.present? && address.match?(/[^\x00-\x7F]/)
      # If address contains non-ASCII characters, use a placeholder
      "Address provided (Japanese characters not shown in PDF)"
    else
      address
    end
  end

  def translate_summary(summary)
    # Keep summary in English for now
    summary
  end

  def translate_description(description)
    # Keep description in English for now
    description
  end

  def format_japanese_date(date)
    return '' if date.blank?

    if date.is_a?(String) && date.match?(/\A\d{4}-\d{2}\z/)
      year, month = date.split('-')
      "#{year}-#{month}"
    else
      date.to_s
    end
  end

  def determine_skill_level(skill_name)
    # Basic skill level determination - return English for PDF compatibility
    skill_lower = skill_name.downcase
    if skill_lower.include?('expert') || skill_lower.include?('advanced')
      'Advanced'
    elsif skill_lower.include?('intermediate') || skill_lower.include?('mid')
      'Intermediate'
    elsif skill_lower.include?('basic') || skill_lower.include?('beginner')
      'Basic'
    else
      'Intermediate'
    end
  end

  def extract_achievements(description)
    # Extract achievements from description
    achievements = []
    if description.include?('achieved') || description.include?('successfully')
      achievements << 'プロジェクトの成功'
    end
    if description.include?('improved') || description.include?('increased')
      achievements << '効率性の向上'
    end
    achievements
  end

  def extract_technologies(description)
    # Extract technologies mentioned in description
    tech_keywords = ['JavaScript', 'Python', 'Java', 'React', 'Ruby', 'Rails', 'SQL', 'AWS']
    technologies = []
    tech_keywords.each do |tech|
      if description.include?(tech)
        technologies << tech
      end
    end
    technologies
  end
end
