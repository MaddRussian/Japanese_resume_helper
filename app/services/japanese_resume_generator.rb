class JapaneseResumeGenerator
  def initialize(resume)
    @resume = resume
    @user = resume.user
  end

  # Japanese translations for common terms
  JAPANESE_TRANSLATIONS = {
    # Education
    'undergraduate' => '大学',
    'graduate' => '大学院',
    'vocational' => '専門学校',
    'high_school' => '高校',
    'community_college' => '短期大学',
    'technical' => '工業高等専門学校',
    'language_school' => '語学学校',
    'other' => 'その他',

    # Degrees
    'Bachelor of Science' => '理学士',
    'Bachelor of Arts' => '文学士',
    'Master of Science' => '理学修士',
    'Master of Arts' => '文学修士',
    'PhD' => '博士',

    # Common fields
    'Computer Science' => 'コンピュータサイエンス',
    'Engineering' => '工学',
    'Business' => '経営学',
    'Economics' => '経済学',

    # Job titles
    'Software Engineer' => 'ソフトウェアエンジニア',
    'Developer' => '開発者',
    'Programmer' => 'プログラマー',
    'Manager' => 'マネージャー',
    'Director' => 'ディレクター',

    # Common skills
    'JavaScript' => 'JavaScript',
    'Python' => 'Python',
    'Java' => 'Java',
    'React' => 'React',
    'Ruby' => 'Ruby',
    'Rails' => 'Rails',
    'Project Management' => 'プロジェクトマネジメント',
    'Japanese' => '日本語',
    'English' => '英語'
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
    # Basic address translation - could be enhanced with more sophisticated translation
    address.gsub('Address', '住所').gsub('address', '住所')
  end

  def translate_summary(summary)
    # Basic summary translation - could be enhanced with AI translation
    summary.gsub('computer programmer', 'コンピュータプログラマー')
           .gsub('software engineer', 'ソフトウェアエンジニア')
           .gsub('developer', '開発者')
  end

  def translate_description(description)
    # Basic description translation - could be enhanced with AI translation
    description.gsub('responsibilities', '責任')
              .gsub('achievements', '成果')
              .gsub('projects', 'プロジェクト')
              .gsub('development', '開発')
              .gsub('management', '管理')
  end

  def format_japanese_date(date)
    return '' if date.blank?

    if date.is_a?(String) && date.match?(/\A\d{4}-\d{2}\z/)
      year, month = date.split('-')
      "#{year}年#{month}月"
    else
      date.to_s
    end
  end

  def determine_skill_level(skill_name)
    # Basic skill level determination
    skill_lower = skill_name.downcase
    if skill_lower.include?('expert') || skill_lower.include?('advanced')
      '上級'
    elsif skill_lower.include?('intermediate') || skill_lower.include?('mid')
      '中級'
    elsif skill_lower.include?('basic') || skill_lower.include?('beginner')
      '初級'
    else
      '中級'
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
