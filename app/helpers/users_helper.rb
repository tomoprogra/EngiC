module UsersHelper
  def associated_skills_for_select
    Skill.joins(:users).distinct.pluck('LOWER(skills.name)')
  end  
end
